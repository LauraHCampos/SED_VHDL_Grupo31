library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Garage is
    Port ( 
        CLK100MHZ  : in  STD_LOGIC;
        CPU_RESETN : in  STD_LOGIC; -- Reset activo a nivel bajo (Botón rojo)
        BTN_OPEN   : in  STD_LOGIC; -- Pulsador central
        
        -- Conexiones Pmod para la maqueta
        PMOD_ECHO  : in  STD_LOGIC; -- Sensor Ultrasonidos
        PMOD_TRIG  : out STD_LOGIC; -- Sensor Ultrasonidos
        PMOD_SERVO : out STD_LOGIC; -- Señal PWM al Servo
        
        -- Salidas de la placa
        LED        : out STD_LOGIC_VECTOR(2 downto 0);
        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        an         : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Top_Garage;

architecture Structural of Top_Garage is

    -- DECLARACIÓN DE COMPONENTES

    -- Sincronizador para evitar metaestabilidad
    component Synchronizer is
        Port ( clk, async_in : in STD_LOGIC; sync_out : out STD_LOGIC );
    end component;

    -- Antirrebotes para el botón físico
    component Debouncer is
        Generic ( WAIT_CYCLES : integer := 1000000 );
        Port ( clk, rst, input_sig : in STD_LOGIC; output_sig : out STD_LOGIC );
    end component;

    -- Generador de pulsos de 1ms (Prescaler)
    component Pulse_Generator is
        Generic ( MAX_COUNT : integer := 100000 );
        Port ( clk, rst : in STD_LOGIC; tick_1ms : out STD_LOGIC );
    end component;

    -- Temporizador para estados de la FSM
    component Timer is
        Port ( clk, rst, tick_en, start_time : in STD_LOGIC; duration : in integer; time_up : out STD_LOGIC );
    end component;

    -- Controlador del Sensor de Ultrasonidos
    component Ultrasonic_sensor is
        Port ( clk, rst, echo : in STD_LOGIC; trigger, obstacle : out STD_LOGIC );
    end component;

    -- Controlador del Servo (Generador PWM)
    component Servo_Controller is
        Port ( clk, rst, position_cmd : in STD_LOGIC; pwm_out : out STD_LOGIC );
    end component;

    -- Máquina de Estados (Cerebro del sistema)
    component FSM_Garaje is
        Port ( 
            clk, rst, s_obstaculo, btn_open, timer_done : in STD_LOGIC; 
            start_timer, servo_cmd : out STD_LOGIC; 
            state_status : out STD_LOGIC_VECTOR(2 downto 0) 
        );
    end component;

    -- Controlador de los Displays de 7 Segmentos
    component Display_Controller is
        Port ( 
            clk, rst : in STD_LOGIC; 
            state_code : in STD_LOGIC_VECTOR(2 downto 0); 
            seg : out STD_LOGIC_VECTOR(6 downto 0); 
            an : out STD_LOGIC_VECTOR(7 downto 0) 
        );
    end component;

    -- SEÑALES INTERNAS PARA CONECTAR MÓDULOS

    signal rst_i         : std_logic;
    signal tick_1ms_i    : std_logic;
    signal btn_sync      : std_logic;
    signal btn_clean     : std_logic;
    signal start_timer_i : std_logic;
    signal timer_done_i  : std_logic;
    signal obstacle_i    : std_logic;
    signal servo_cmd_i   : std_logic;
    signal state_code_i  : std_logic_vector(2 downto 0);

begin

    -- Lógica de Reset (CPU_RESETN es activo bajo, rst_i será activo alto)
    rst_i <= not CPU_RESETN;

    -- INSTANCIACIÓN DE LOS COMPONENTES (PORT MAP)

    -- Prescaler: Genera base de tiempos de 1ms
    Prescaler: Pulse_Generator 
        generic map ( MAX_COUNT => 100000 )
        port map ( clk => CLK100MHZ, rst => rst_i, tick_1ms => tick_1ms_i );

    -- Acondicionamiento del botón de apertura
    Sync: Synchronizer 
        port map ( clk => CLK100MHZ, async_in => BTN_OPEN, sync_out => btn_sync );

    Deboun: Debouncer 
        generic map ( WAIT_CYCLES => 1000000 )
        port map ( clk => CLK100MHZ, rst => rst_i, input_sig => btn_sync, output_sig => btn_clean );

    -- Sensores y Actuadores (Ultrasonidos y Servo)
    Ultrasonic: Ultrasonic_sensor 
        port map ( clk => CLK100MHZ, rst => rst_i, echo => PMOD_ECHO, trigger => PMOD_TRIG, obstacle => obstacle_i );
        --PMOD_TRIG <= '1';
    Servo: Servo_Controller 
        port map ( clk => CLK100MHZ, rst => rst_i, position_cmd => servo_cmd_i, pwm_out => PMOD_SERVO );

    -- Control de tiempo para la FSM
    Tim: Timer 
        port map ( clk => CLK100MHZ, rst => rst_i, tick_en => tick_1ms_i, start_time => start_timer_i, duration => 5000, time_up => timer_done_i );

    -- Inteligencia del sistema
    FSM: FSM_Garaje 
        port map ( 
            clk => CLK100MHZ, rst => rst_i, s_obstaculo => obstacle_i, 
            btn_open => btn_clean, timer_done => timer_done_i, 
            start_timer => start_timer_i, servo_cmd => servo_cmd_i, state_status => state_code_i 
        );

    -- Visualización
    Display: Display_Controller 
        port map ( clk => CLK100MHZ, rst => rst_i, state_code => state_code_i, seg => SEG, an => AN );

    -- Testigos en LEDs (Útil para depuración rápida)
    LED(0) <= servo_cmd_i;   -- LED encendido si la puerta debería estar abierta
    LED(1) <= obstacle_i;    -- LED encendido si el sensor detecta algo
    LED(2) <= PMOD_ECHO;
end Structural;
