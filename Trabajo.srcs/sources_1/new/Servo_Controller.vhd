library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Servo_Controller is
    Port ( clk, rst, position_cmd : in STD_LOGIC; pwm_out : out STD_LOGIC );
end Servo_Controller;

architecture Behavioral of Servo_Controller is
    constant PWM_PERIOD : integer := 2000000;
    constant POS_DOWN : integer := 50000; -- Cerrado
    constant POS_UP : integer := 160000; -- Abierto
    signal count : integer := 0;
    signal duty : integer;
begin
    duty <= POS_UP when position_cmd = '1' else POS_DOWN;
    process(clk, rst) begin
        if rst = '1' then count <= 0;
        elsif rising_edge(clk) then
            if count < PWM_PERIOD - 1 then count <= count + 1;
            else count <= 0;
            end if;
            if count < duty then pwm_out <= '1'; else pwm_out <= '0'; end if;
        end if;
    end process;
end Behavioral;