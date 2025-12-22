library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Pulse_Generator is
    Generic (
        MAX_COUNT : integer := 100000 -- 100,000 ciclos @ 100MHz = 1ms
    );
    Port ( 
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        tick_1ms : out STD_LOGIC -- Pulso de un ciclo de reloj
    );
end Pulse_Generator;

architecture Behavioral of Pulse_Generator is
    signal count : integer range 0 to MAX_COUNT-1 := 0;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            count <= 0;
            tick_1ms <= '0';
        elsif rising_edge(clk) then
            if count = MAX_COUNT - 1 then
                count <= 0;
                tick_1ms <= '1';
            else
                count <= count + 1;
                tick_1ms <= '0';
            end if;
        end if;
    end process;
end Behavioral;