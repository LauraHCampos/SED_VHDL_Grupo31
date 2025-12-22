library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Cumple requisito: Circuitos antirrebote 
entity Debouncer is
    Generic (
        WAIT_CYCLES : integer := 1000000 -- 10ms a 100MHz
    );
    Port ( 
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        input_sig  : in  STD_LOGIC; -- Señal ruidosa (o sincronizada)
        output_sig : out STD_LOGIC  -- Señal limpia
    );
end Debouncer;

architecture Behavioral of Debouncer is
    signal counter : integer range 0 to WAIT_CYCLES := 0;
    signal stable_val : STD_LOGIC := '0';
    signal candidate_val : STD_LOGIC := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            counter <= 0;
            stable_val <= '0';
            candidate_val <= '0';
        elsif rising_edge(clk) then
            if input_sig /= candidate_val then
                candidate_val <= input_sig;
                counter <= 0; -- Reiniciar si cambia
            elsif counter < WAIT_CYCLES then
                counter <= counter + 1;
            else
                stable_val <= candidate_val; -- Confirmar valor tras espera
            end if;
        end if;
    end process;

    output_sig <= stable_val;
end Behavioral;
