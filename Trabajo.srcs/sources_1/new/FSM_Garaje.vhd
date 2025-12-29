library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_Garaje is
    Port ( clk, rst, s_obstaculo, btn_open, timer_done : in STD_LOGIC; start_timer, servo_cmd : out STD_LOGIC; state_status : out STD_LOGIC_VECTOR(2 downto 0) );
end FSM_Garaje;

architecture Behavioral of FSM_Garaje is
    type state_t is (S_CLOSED, S_PRE_OPEN, S_OPENING, S_PRE_WAIT, S_WAIT_OPEN, S_PRE_CLOSE, S_CLOSING);
    signal state, next_state : state_t;
begin
    process(clk, rst) begin
        if rst = '1' then state <= S_CLOSED;
        elsif rising_edge(clk) then state <= next_state;
        end if;
    end process;

    process(state, btn_open, timer_done, s_obstaculo) begin
        next_state <= state; start_timer <= '0'; servo_cmd <= '0'; state_status <= "000";
        case state is
            when S_CLOSED => if btn_open = '1' then next_state <= S_PRE_OPEN; end if;
            when S_PRE_OPEN => start_timer <= '1'; next_state <= S_OPENING; state_status <= "001";
            when S_OPENING => servo_cmd <= '1'; state_status <= "001"; if timer_done = '1' then next_state <= S_PRE_WAIT; end if;
            when S_PRE_WAIT => start_timer <= '1'; next_state <= S_WAIT_OPEN; state_status <= "010";
            when S_WAIT_OPEN => servo_cmd <= '1'; state_status <= "010"; if timer_done = '1' then next_state <= S_PRE_CLOSE; end if;
            when S_PRE_CLOSE => start_timer <= '1'; next_state <= S_CLOSING; state_status <= "011";
            when S_CLOSING => if s_obstaculo = '1' then next_state <= S_PRE_OPEN; elsif timer_done = '1' then next_state <= S_CLOSED; end if; state_status <= "011";
        end case;
    end process;
end Behavioral;
