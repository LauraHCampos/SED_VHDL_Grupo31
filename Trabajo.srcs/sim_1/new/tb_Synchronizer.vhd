library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Synchronizer is
-- Entidad vacía
end tb_Synchronizer;

architecture Behavioral of tb_Synchronizer is

    -- Componente a probar
    component Synchronizer
    Port ( clk : in STD_LOGIC;
           async_in : in STD_LOGIC;
           sync_out : out STD_LOGIC);
    end component;

    -- Señales de conexión
    signal clk : STD_LOGIC := '0';
    signal async_in : STD_LOGIC := '0';
    signal sync_out : STD_LOGIC;

    -- Periodo de reloj (10ns = 100MHz)
    constant clk_period : time := 10 ns;

begin

    uut: Synchronizer Port Map (
        clk => clk,
        async_in => async_in,
        sync_out => sync_out
    );

    -- Generación de Reloj
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Proceso de estímulos
    stim_proc: process
    begin
        wait for 100 ns;
        
        -- Simulamos una entrada asíncrona que cambia aleatoriamente
        async_in <= '1';
        wait for 23 ns; -- No sincronizado con el reloj
        async_in <= '0';
        wait for 15 ns;
        async_in <= '1';
        wait for 40 ns; -- Pulso largo
        async_in <= '0';

        wait;
    end process;
end Behavioral;