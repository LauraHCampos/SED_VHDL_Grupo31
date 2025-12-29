library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Ultrasonic_sensor is
    Port ( clk, rst, echo : in STD_LOGIC; trigger, obstacle : out STD_LOGIC );
end Ultrasonic_sensor;

architecture Behavioral of Ultrasonic_sensor is
    signal count : unsigned(21 downto 0);
    type state_t is (IDLE, SEND_TRIG, WAIT_ECHO, MEASURE);
    signal state : state_t;
    constant THRESHOLD : integer := 870000; -- ~15cm
begin
    process(clk, rst) begin
        if rst = '1' then state <= IDLE; obstacle <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    trigger <= '0';
                    if count < 6000000 then count <= count + 1;
                    else count <= (others => '0'); state <= SEND_TRIG;
                    end if;
                when SEND_TRIG =>
                    trigger <= '1';
                    if count < 1000 then count <= count + 1;
                    else trigger <= '0'; count <= (others => '0'); state <= WAIT_ECHO;
                    end if;
                when WAIT_ECHO =>
                    if echo = '1' then state <= MEASURE; count <= (others => '0');
                    elsif count > 2000000 then state <= IDLE;
                    else count <= count + 1;
                    end if;
                when MEASURE =>
                    if echo = '1' then count <= count + 1;
                    else
                        if count < THRESHOLD then obstacle <= '1';
                        else obstacle <= '0';
                        end if;
                        state <= IDLE; count <= (others => '0');
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
