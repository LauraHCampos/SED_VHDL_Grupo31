library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Pulse_Generator is
    Generic ( MAX_COUNT : integer := 100000 ); -- 1ms a 100MHz
    Port ( clk, rst : in STD_LOGIC; tick_1ms : out STD_LOGIC );
end Pulse_Generator;

architecture Behavioral of Pulse_Generator is
    signal count : integer := 0;
begin
    process(clk, rst) begin
        if rst = '1' then count <= 0; tick_1ms <= '0';
        elsif rising_edge(clk) then
            if count < MAX_COUNT - 1 then
                count <= count + 1; tick_1ms <= '0';
            else
                count <= 0; tick_1ms <= '1';
            end if;
        end if;
    end process;
end Behavioral;
