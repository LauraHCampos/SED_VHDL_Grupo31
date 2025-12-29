library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Ultrasonic_sensor is
end tb_Ultrasonic_sensor;

architecture sim of tb_Ultrasonic_sensor is
    signal clk, rst, echo, trigger, obstacle : std_logic := '0';
begin
    uut: entity work.Ultrasonic_sensor port map (clk, rst, echo, trigger, obstacle);
    clk <= not clk after 5 ns;

    process begin
        rst <= '1'; wait for 20 ns; rst <= '0';
        wait until trigger = '1'; wait until trigger = '0';
        -- Simular OBSTÁCULO (Pulso de eco corto: 10us)
        wait for 10 us; echo <= '1'; wait for 10 us; echo <= '0';
        
        wait for 1 ms; -- Esperar siguiente ciclo
        wait until trigger = '1'; wait until trigger = '0';
        -- Simular CAMINO LIBRE (Pulso de eco largo: 2ms)
        wait for 10 us; echo <= '1'; wait for 2 ms; echo <= '0';
        wait;
    end process;
end sim;
