library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_FSM_Garaje is
end tb_FSM_Garaje;

architecture sim of tb_FSM_Garaje is
    signal clk, rst, obs, btn, done, start, servo : std_logic := '0';
    signal state : std_logic_vector(2 downto 0);
begin
    uut: entity work.FSM_Garaje port map (clk, rst, obs, btn, done, start, servo, state);
    clk <= not clk after 5 ns;

    process begin
        rst <= '1'; wait for 20 ns; rst <= '0';
        -- 1. Intentar abrir
        btn <= '1'; wait for 20 ns; btn <= '0';
        wait for 50 ns; done <= '1'; wait for 10 ns; done <= '0'; -- Fin apertura
        wait for 50 ns; done <= '1'; wait for 10 ns; done <= '0'; -- Fin espera
        -- 2. Detectar obstáculo en el cierre
        wait for 30 ns; obs <= '1'; wait for 20 ns; obs <= '0';
        wait;
    end process;
end sim;