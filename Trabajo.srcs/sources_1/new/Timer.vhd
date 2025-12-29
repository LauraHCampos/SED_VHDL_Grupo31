library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer is
    Port ( clk, rst, tick_en, start_time : in STD_LOGIC; duration : in integer; time_up : out STD_LOGIC );
end Timer;

architecture Behavioral of Timer is
    signal count : integer := 0;
    signal running : std_logic := '0';
begin
    process(clk, rst) begin
        if rst = '1' then count <= 0; running <= '0'; time_up <= '0';
        elsif rising_edge(clk) then
            if start_time = '1' then
                count <= 0; running <= '1'; time_up <= '0';
            elsif running = '1' and tick_en = '1' then
                if count < duration - 1 then count <= count + 1;
                else running <= '0'; time_up <= '1';
                end if;
            else time_up <= '0';
            end if;
        end if;
    end process;
end Behavioral;
