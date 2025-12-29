library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Timer is
end tb_Timer;

architecture sim of tb_Timer is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal tick_en : std_logic := '0';
    signal start_time : std_logic := '0';
    signal time_up : std_logic;
    signal duration : integer := 3; -- Simulamos una espera de 3 ticks
begin
    uut: entity work.Timer 
        port map ( clk => clk, rst => rst, tick_en => tick_en, 
                   start_time => start_time, duration => duration, time_up => time_up );

    clk <= not clk after 5 ns;

    process begin
        rst <= '1'; wait for 20 ns; rst <= '0';
        
        -- Simulamos la llegada de la señal del prescaler cada 40ns
        -- (En la realidad es cada 1ms)
        start_time <= '1'; wait for 10 ns; start_time <= '0';
        
        for i in 1 to 5 loop
            wait for 40 ns; tick_en <= '1'; wait for 10 ns; tick_en <= '0';
        end loop;
        
        wait;
    end process;
end sim;
