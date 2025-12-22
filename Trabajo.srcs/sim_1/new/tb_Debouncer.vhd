library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Debouncer is
end tb_Debouncer;

architecture Behavioral of tb_Debouncer is

    component Debouncer
    Generic ( WAIT_CYCLES : integer ); -- Declaramos que tiene un genérico
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_sig : in STD_LOGIC;
           output_sig : out STD_LOGIC);
    end component;

    signal clk, rst, input_sig, output_sig : STD_LOGIC := '0';
    constant clk_period : time := 10 ns;

begin

    -- Instanciamos con WAIT_CYCLES = 5 para simulación rápida
    uut: Debouncer
    Generic Map ( WAIT_CYCLES => 5 ) 
    Port Map (
        clk => clk,
        rst => rst,
        input_sig => input_sig,
        output_sig => output_sig
    );

    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- 1. Simulamos "ruido" (pulsos más cortos que 5 ciclos)
        -- La salida NO debería cambiar
        input_sig <= '1'; wait for 20 ns; 
        input_sig <= '0'; wait for 10 ns;
        input_sig <= '1'; wait for 30 ns;
        input_sig <= '0'; wait for 50 ns;

        -- 2. Señal estable (pulsada más de 5 ciclos)
        -- La salida DEBE ponerse a '1' tras la espera
        input_sig <= '1';
        wait for 200 ns; 

        -- 3. Soltamos botón con ruido
        input_sig <= '0'; wait for 10 ns;
        input_sig <= '1'; wait for 10 ns;
        input_sig <= '0'; -- Ya estable a 0
        
        wait;
    end process;
end Behavioral;
