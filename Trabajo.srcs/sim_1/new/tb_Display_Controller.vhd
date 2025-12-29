library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Display_Controller is
end tb_Display_Controller;

architecture sim of tb_Display_Controller is
    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal state_code : std_logic_vector(2 downto 0) := "000";
    signal seg        : std_logic_vector(6 downto 0);
    signal an         : std_logic_vector(7 downto 0);
begin
    -- Instancia del controlador
    uut: entity work.Display_Controller 
        port map ( clk => clk, rst => rst, state_code => state_code, seg => seg, an => an );

    -- Reloj de 100 MHz
    clk <= not clk after 5 ns;

    process begin
        -- Reset inicial
        rst <= '1'; wait for 20 ns; rst <= '0';
        
        -- Escenario 1: Estado S_CLOSED ("CLSE")
        state_code <= "000"; wait for 100 ns;
        
        -- Escenario 2: Estado S_OPENING / S_WAIT_OPEN ("OPEN")
        state_code <= "001"; wait for 100 ns;
        
        -- Escenario 3: Estado S_CLOSING ("CLOS")
        state_code <= "011"; wait for 100 ns;

        -- Escenario 4: Estado de Error / Obstáculo ("Err")
        state_code <= "100"; wait for 100 ns;
        
        wait;
    end process;
end sim;
