library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Pulse_Generator is
end tb_Pulse_Generator;

architecture sim of tb_Pulse_Generator is
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal tick_1ms : std_logic;
begin
    -- Instancia con MAX_COUNT reducido a 5 para ver los pulsos en la gráfica
    uut: entity work.Pulse_Generator 
        generic map ( MAX_COUNT => 5 )
        port map ( clk => clk, rst => rst, tick_1ms => tick_1ms );

    clk <= not clk after 5 ns; -- Reloj de 100MHz

    process begin
        rst <= '1'; wait for 20 ns;
        rst <= '0'; wait for 200 ns;
        wait;
    end process;
end sim;
