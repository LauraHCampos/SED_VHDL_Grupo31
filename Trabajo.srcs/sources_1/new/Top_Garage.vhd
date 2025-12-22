library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Garage is
    Port ( 
        CLK100MHZ  : in  STD_LOGIC; -- Reloj de la placa (E3)
        CPU_RESETN : in  STD_LOGIC; -- Reset activo a nivel bajo (C12)
        
        -- Entradas físicas
        SW_SENSOR_OBS : in  STD_LOGIC; -- Simulación sensor barrera (SW0 o similar)
        BTN_OPEN      : in  STD_LOGIC; -- Botón para abrir (BTNC o similar)
        
        -- Salidas físicas (LEDs para visualizar estado)
        LED           : out STD_LOGIC_VECTOR(1 downto 0) 
        -- LED(0) = Motor Abriendo (Verde)
        -- LED(1) = Motor Cerrando (Rojo/Otro)
    );
end Top_Garage;

architecture Structural of Top_Garage is

    -- ==========================================
    -- 1. DECLARACIÓN DE COMPONENTES
    -- ==========================================
    
    component Synchronizer
        Port ( 
            clk      : in  STD_LOGIC;
            async_in : in  STD_LOGIC;
            sync_out : out STD_LOGIC
        );
    end component;

    component Debouncer
        Generic ( WAIT_CYCLES : integer := 1000000 );
        Port ( 
            clk        : in  STD_LOGIC;
            rst        : in  STD_LOGIC;
            input_sig  : in  STD_LOGIC;
            output_sig : out STD_LOGIC
        );
    end component;

    component Pulse_Generator
        Generic ( MAX_COUNT : integer := 100000 );
        Port ( 
            clk      : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            tick_1ms : out STD_LOGIC
        );
    end component;

    component Timer
        Port ( 
            clk        : in  STD_LOGIC;
            rst        : in  STD_LOGIC;
            tick_en    : in  STD_LOGIC;
            start_time : in  STD_LOGIC;
            duration   : in  integer;
            time_up    : out STD_LOGIC
        );
    end component;
    
    component FSM_Garaje
        Port ( 
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            s_obstaculo : in  STD_LOGIC;
            btn_open    : in  STD_LOGIC;
            timer_done  : in  STD_LOGIC;
            start_timer : out STD_LOGIC;
            motor_open  : out STD_LOGIC;
            motor_close : out STD_LOGIC
        );
    end component;

    -- ==========================================
    -- 2. SEÑALES INTERNAS
    -- ==========================================
    
    signal rst_sys       : STD_LOGIC; -- Reset del sistema (Activo Alto)
    signal tick_1ms      : STD_LOGIC; -- Base de tiempos
    
    -- Señales intermedias para sincronización
    signal sync_btn_open   : STD_LOGIC;
    signal sync_sensor_obs : STD_LOGIC;
    
    -- Señales limpias y estables (listas para usar en lógica)
    signal clean_btn_open   : STD_LOGIC;
    signal clean_sensor_obs : STD_LOGIC;
    
    -- Interfaz Timer-FSM
    signal fsm_start_timer : STD_LOGIC;
    signal timer_done_sig  : STD_LOGIC;

begin

    -- Gestión del Reset: El botón de la placa es '0' al pulsar, lo invertimos a '1'
    rst_sys <= not CPU_RESETN;

    -- ==========================================
    -- 3. INSTANCIACIÓN DE BLOQUES
    -- ==========================================

    -- A) GENERADOR DE PULSOS (Prescaler)
    Inst_Prescaler: Pulse_Generator
    Generic Map ( MAX_COUNT => 100000 ) -- 100,000 ciclos = 1ms a 100MHz
    Port Map (
        clk      => CLK100MHZ,
        rst      => rst_sys,
        tick_1ms => tick_1ms
    );

    -- B) ACONDICIONAMIENTO DE ENTRADAS (SYNC + DEBOUNCE)
    
    -- Canal 1: Botón de Abrir
    Sync_Btn: Synchronizer
    Port Map (
        clk      => CLK100MHZ,
        async_in => BTN_OPEN,
        sync_out => sync_btn_open
    );
    
    Debounce_Btn: Debouncer
    Generic Map ( WAIT_CYCLES => 1000000 ) -- 10ms de filtro
    Port Map (
        clk        => CLK100MHZ,
        rst        => rst_sys,
        input_sig  => sync_btn_open,
        output_sig => clean_btn_open
    );

    -- Canal 2: Sensor de Obstáculo (Switch)
    Sync_Sensor: Synchronizer
    Port Map (
        clk      => CLK100MHZ,
        async_in => SW_SENSOR_OBS,
        sync_out => sync_sensor_obs
    );
    
    Debounce_Sensor: Debouncer
    Generic Map ( WAIT_CYCLES => 1000000 ) -- 10ms de filtro
    Port Map (
        clk        => CLK100MHZ,
        rst        => rst_sys,
        input_sig  => sync_sensor_obs,
        output_sig => clean_sensor_obs
    );

    -- C) TEMPORIZADOR DEL SISTEMA
    Inst_Timer: Timer
    Port Map (
        clk        => CLK100MHZ,
        rst        => rst_sys,
        tick_en    => tick_1ms,       -- Conectado al prescaler
        start_time => fsm_start_timer,-- Orden viene de la FSM
        duration   => 5000,           -- 5000 ms = 5 Segundos
        time_up    => timer_done_sig  -- Aviso va a la FSM
    );

    -- D) MÁQUINA DE ESTADOS (CONTROL)
    Inst_FSM: FSM_Garaje
    Port Map (
        clk         => CLK100MHZ,
        rst         => rst_sys,
        
        -- Entradas limpias
        s_obstaculo => clean_sensor_obs,
        btn_open    => clean_btn_open,
        timer_done  => timer_done_sig,
        
        -- Salidas de control interna
        start_timer => fsm_start_timer,
        
        -- Salidas al exterior (LEDs)
        motor_open  => LED(0),
        motor_close => LED(1)
    );

end Structural;