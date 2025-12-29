library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Synchronizer is
end tb_Synchronizer;

architecture sim of tb_Synchronizer is
    signal clk : std_logic := '0';
    signal async_in, sync_out : std_logic := '0';
begin
    uut: entity work.Synchronizer port map (clk => clk, async_in => async_in, sync_out => sync_out);
    clk <= not clk after 5 ns; -- 100MHz

    process begin
        wait for 23 ns; async_in <= '1'; -- Cambio asíncrono
        wait for 40 ns; async_in <= '0';
        wait;
    end process;
end sim;