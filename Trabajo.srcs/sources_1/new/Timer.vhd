library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Timer is
    Port ( 
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        tick_en    : in  STD_LOGIC; -- Viene del Prescaler
        start_time : in  STD_LOGIC; -- Orden de la FSM para empezar cuenta
        duration   : in  integer;   -- Cuantos ms contar
        time_up    : out STD_LOGIC  -- Señal a la FSM cuando termina
    );
end Timer;

architecture Behavioral of Timer is
    signal count : integer := 0;
    signal active : STD_LOGIC := '0';
begin
    process(clk, rst)
    begin
        if rst = '1' then
            active <= '0';
            count <= 0;
            time_up <= '0';
        elsif rising_edge(clk) then
            time_up <= '0'; -- Pulso de un ciclo al terminar
            
            if start_time = '1' then
                active <= '1';
                count <= 0;
            elsif active = '1' and tick_en = '1' then
                if count >= duration then
                    active <= '0';
                    time_up <= '1'; -- ¡Tiempo cumplido!
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;