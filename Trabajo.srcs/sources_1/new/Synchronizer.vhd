library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Cumple requisito: Sincronización de entradas externas 
entity Synchronizer is
    Port ( 
        clk      : in  STD_LOGIC;
        async_in : in  STD_LOGIC;
        sync_out : out STD_LOGIC
    );
end Synchronizer;

architecture Behavioral of Synchronizer is
    signal s_reg1, s_reg2 : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            s_reg1 <= async_in;
            s_reg2 <= s_reg1;
        end if;
    end process;
    
    sync_out <= s_reg2;
end Behavioral;