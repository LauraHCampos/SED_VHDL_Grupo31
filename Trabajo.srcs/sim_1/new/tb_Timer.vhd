library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Timer is
end tb_Timer;

architecture Behavioral of tb_Timer is
    component Timer
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tick_en : in STD_LOGIC;
           start_time : in STD_LOGIC;
           duration : in integer;
           time_up : out STD_LOGIC);
    end component;

    signal clk, rst, tick_en, start_time, time_up : STD_LOGIC := '0';
    signal duration : integer := 5; -- Cuenta corta para simular
    constant clk_period : time := 10 ns;

begin
    uut: Timer Port Map (
        clk => clk, rst => rst, tick_en => tick_en,
        start_time => start_time, duration => duration, time_up => time_up
    );

    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- Generador de ticks (Simula el Prescaler cada 20ns)
    tick_gen: process
    begin
        wait for 20 ns;
        tick_en <= '1';
        wait for clk_period; -- Un ciclo de reloj
        tick_en <= '0';
    end process;

    stim_proc: process
    begin
        rst <= '1'; wait for 20 ns; rst <= '0';
        
        -- Iniciamos cuenta
        wait for 50 ns;
        start_time <= '1';
        wait for clk_period; -- Pulso de un ciclo
        start_time <= '0';

        -- Esperamos a ver si time_up se pone a 1
        -- Como duration=5 y generamos tick cada ~30ns, tardará unos 150ns
        wait for 300 ns;

        wait;
    end process;
end Behavioral;