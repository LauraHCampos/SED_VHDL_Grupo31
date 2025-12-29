library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Top_Garage is
end tb_Top_Garage;

architecture sim of tb_Top_Garage is
    signal clk : std_logic := '0';
    signal rst_n, btn, echo, trig, servo : std_logic := '1';
    signal led : std_logic_vector(1 downto 0);
begin
    -- El Top usa CPU_RESETN (Activo bajo)
    uut: entity work.Top_Garage port map (
        CLK100MHZ => clk, CPU_RESETN => rst_n, BTN_OPEN => btn,
        PMOD_ECHO => echo, PMOD_TRIG => trig, PMOD_SERVO => servo,
        LED => led, SEG => open, AN => open
    );

    clk <= not clk after 5 ns;

    process begin
        rst_n <= '0'; wait for 100 ns; rst_n <= '1';
        wait for 100 ns;
        -- Pulsar botón
        btn <= '1'; wait for 100 ns; btn <= '0';
        -- Simular eco del sensor (distancia segura)
        wait until trig = '1'; wait for 10 us; echo <= '1'; wait for 5 ms; echo <= '0';
        wait;
    end process;
end sim;
