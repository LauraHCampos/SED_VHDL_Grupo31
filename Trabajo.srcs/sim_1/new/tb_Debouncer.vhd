library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Debouncer is
end tb_Debouncer;

architecture sim of tb_Debouncer is
    signal clk, rst, input_sig, output_sig : std_logic := '0';
begin
    uut: entity work.Debouncer 
        generic map (WAIT_CYCLES => 5) -- Reducido para simulación
        port map (clk => clk, rst => rst, input_sig => input_sig, output_sig => output_sig);
    clk <= not clk after 5 ns;

    process begin
        rst <= '1'; wait for 20 ns; rst <= '0';
        -- Simulación de rebotes (ruido)
        input_sig <= '1'; wait for 10 ns; input_sig <= '0'; wait for 10 ns;
        input_sig <= '1'; wait for 10 ns; input_sig <= '0'; wait for 10 ns;
        -- Pulsación estable
        input_sig <= '1'; wait for 100 ns;
        input_sig <= '0'; wait;
    end process;
end sim;