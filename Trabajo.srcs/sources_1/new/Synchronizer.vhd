library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Synchronizer is
    Port ( clk : in STD_LOGIC; async_in : in STD_LOGIC; sync_out : out STD_LOGIC );
end Synchronizer;

architecture Behavioral of Synchronizer is
    signal sreg : std_logic_vector(1 downto 0);
begin
    process(clk) begin
        if rising_edge(clk) then
            sreg <= sreg(0) & async_in;
        end if;
    end process;
    sync_out <= sreg(1);
end Behavioral;
