library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Debouncer is
    Generic ( WAIT_CYCLES : integer := 1000000 ); -- 10ms a 100MHz
    Port ( clk, rst, input_sig : in STD_LOGIC; output_sig : out STD_LOGIC );
end Debouncer;

architecture Behavioral of Debouncer is
    signal count : integer := 0;
    signal state : std_logic := '0';
begin
    process(clk, rst) begin
        if rst = '1' then count <= 0; state <= '0';
        elsif rising_edge(clk) then
            if input_sig /= state then
                if count < WAIT_CYCLES then count <= count + 1;
                else state <= input_sig; count <= 0;
                end if;
            else count <= 0;
            end if;
        end if;
    end process;
    output_sig <= state;
end Behavioral;
