library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_FSM_Garaje is
end tb_FSM_Garaje;

architecture Behavioral of tb_FSM_Garaje is

    component FSM_Garaje
    Port ( clk, rst, s_obstaculo, btn_open, timer_done : in STD_LOGIC;
           start_timer, motor_open, motor_close : out STD_LOGIC);
    end component;

    signal clk, rst, s_obstaculo, btn_open, timer_done : STD_LOGIC := '0';
    signal start_timer, motor_open, motor_close : STD_LOGIC;
    constant clk_period : time := 10 ns;

begin

    uut: FSM_Garaje Port Map (
        clk => clk, rst => rst, s_obstaculo => s_obstaculo,
        btn_open => btn_open, timer_done => timer_done,
        start_timer => start_timer, motor_open => motor_open, motor_close => motor_close
    );

    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        -- Reset inicial
        rst <= '1'; wait for 20 ns; rst <= '0'; wait for 20 ns;

        -- CASO 1: Ciclo Normal (Abrir -> Esperar -> Cerrar)
        -- ------------------------------------------------
        
        -- 1. Pulsamos abrir
        btn_open <= '1'; wait for 20 ns; btn_open <= '0';
        
        -- Verificamos visualmente que start_timer se activó y motor_open = '1'
        wait for 50 ns; 
        
        -- 2. Simulamos que el Timer ha terminado (Puerta llegó arriba)
        timer_done <= '1'; wait for clk_period; timer_done <= '0';
        
        -- Ahora debería estar en WAIT (motores apagados). Esperamos un poco...
        wait for 50 ns;
        
        -- 3. Simulamos Timer terminado (Tiempo de espera cumplido)
        timer_done <= '1'; wait for clk_period; timer_done <= '0';
        
        -- Ahora debería estar CERRANDO (motor_close = '1')
        wait for 50 ns;
        
        -- 4. Fin de cierre normal
        timer_done <= '1'; wait for clk_period; timer_done <= '0';
        
        -- Vuelta a Reposo
        wait for 100 ns;


        -- CASO 2: Prueba de Seguridad (Obstáculo)
        -- ---------------------------------------
        
        -- 1. Iniciamos ciclo de nuevo
        btn_open <= '1'; wait for 20 ns; btn_open <= '0';
        
        -- Pasamos rápido a estado WAIT (timer done)
        wait for 20 ns; timer_done <= '1'; wait for clk_period; timer_done <= '0';
        
        -- Pasamos rápido a estado CLOSING (timer done)
        wait for 20 ns; timer_done <= '1'; wait for clk_period; timer_done <= '0';
        
        -- ESTAMOS CERRANDO. ¡Aparece un obstáculo!
        wait for 20 ns;
        s_obstaculo <= '1'; 
        wait for 20 ns;
        s_obstaculo <= '0';
        
        -- VERIFICAR: La FSM debe haber saltado a OPENING o PRE_OPEN inmediatamente.
        -- motor_close debe ser '0' y motor_open debe ser '1'
        
        wait;
    end process;
end Behavioral;