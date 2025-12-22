library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Top_Garage is
-- Entidad vacía, es un banco de pruebas
end tb_Top_Garage;

architecture Behavioral of tb_Top_Garage is

    -- Declaramos la unidad bajo prueba (UUT)
    component Top_Garage
    Port ( 
        CLK100MHZ     : in  STD_LOGIC;
        CPU_RESETN    : in  STD_LOGIC; -- OJO: Reset activo a nivel bajo
        SW_SENSOR_OBS : in  STD_LOGIC;
        BTN_OPEN      : in  STD_LOGIC;
        LED           : out STD_LOGIC_VECTOR(1 downto 0)
    );
    end component;

    -- Entradas
    signal CLK100MHZ     : STD_LOGIC := '0';
    signal CPU_RESETN    : STD_LOGIC := '1'; -- Inicialmente no pulsado (1 en la placa)
    signal SW_SENSOR_OBS : STD_LOGIC := '0';
    signal BTN_OPEN      : STD_LOGIC := '0';

    -- Salidas
    signal LED : STD_LOGIC_VECTOR(1 downto 0);

    -- Periodo de reloj (100 MHz)
    constant clk_period : time := 10 ns;

begin

    -- Instanciación del Top
    uut: Top_Garage Port Map (
        CLK100MHZ     => CLK100MHZ,
        CPU_RESETN    => CPU_RESETN,
        SW_SENSOR_OBS => SW_SENSOR_OBS,
        BTN_OPEN      => BTN_OPEN,
        LED           => LED
    );

    -- Proceso de Reloj
    clk_process :process
    begin
        CLK100MHZ <= '0';
        wait for clk_period/2;
        CLK100MHZ <= '1';
        wait for clk_period/2;
    end process;

    -- Proceso de Estímulos (Simula lo que harías con tus manos en la placa)
    stim_proc: process
    begin
        -- 1. Estado inicial y RESET
        -- En la Nexys, el reset se pulsa poniendo la señal a '0'
        CPU_RESETN <= '0'; 
        wait for 100 ns;
        CPU_RESETN <= '1'; -- Soltamos reset (Sistema arranca)
        wait for 100 ns;

        -- -----------------------------------------------------------
        -- PRUEBA 1: CICLO COMPLETO SIN OBSTÁCULOS
        -- -----------------------------------------------------------
        
        -- Pulsamos botón abrir (simulamos pulsación limpia para simplificar el TB)
        -- Si no has bajado los tiempos en el código VHDL, aquí no pasará nada.
        BTN_OPEN <= '1';
        wait for 200 ns; -- Tiempo suficiente para que el debouncer lo capture (si lo trucaste)
        BTN_OPEN <= '0';

        -- Observar LED(0) encendido (Verde - Abriendo)
        -- Esperar a que termine de abrir (depende de tu constante duration)
        wait for 2000 ns; 
        
        -- Ahora debería estar en ESPERA (LEDs apagados)
        wait for 2000 ns;

        -- Ahora debería estar CERRANDO (LED(1) rojo encendido)
        wait for 2000 ns;

        -- Fin del ciclo, vuelve a reposo.
        wait for 1000 ns;

        -- -----------------------------------------------------------
        -- PRUEBA 2: EMERGENCIA (OBSTÁCULO)
        -- -----------------------------------------------------------
        
        -- Iniciamos apertura de nuevo
        BTN_OPEN <= '1'; wait for 200 ns; BTN_OPEN <= '0';
        
        -- Esperamos a que llegue a la fase de CIERRE
        -- (Abriendo + Espera + un poco de Cerrando)
        wait for 5000 ns; 
        
        -- ¡Simulamos obstáculo!
        -- En el laboratorio remoto esto es activar el Switch 0
        SW_SENSOR_OBS <= '1';
        wait for 300 ns; -- Lo mantenemos un poco
        SW_SENSOR_OBS <= '0';

        -- VERIFICACIÓN VISUAL EN ONDAS:
        -- Deberías ver que el LED(1) se apaga inmediatamente y 
        -- el LED(0) se vuelve a encender (reapertura).

        wait;
    end process;

end Behavioral;