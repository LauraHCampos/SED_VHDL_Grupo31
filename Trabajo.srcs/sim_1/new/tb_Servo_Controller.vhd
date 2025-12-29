library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Servo_Controller is
end tb_Servo_Controller;

architecture sim of tb_Servo_Controller is
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal position_cmd : std_logic := '0';
    signal pwm_out      : std_logic;

    -- Periodo de reloj de 100MHz (10ns)
    constant clk_period : time := 10 ns;
begin

    -- Instancia del componente
    uut: entity work.Servo_Controller
        port map (
            clk => clk,
            rst => rst,
            position_cmd => position_cmd,
            pwm_out => pwm_out
        );

    -- Generador de reloj
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Proceso de estímulos
    stim_proc: process
    begin		
        -- Reset inicial
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        
        -- Escenario 1: Puerta cerrada (position_cmd = '0')
        -- Se espera un pulso corto (aprox 0.5ms - 1ms)
        position_cmd <= '0';
        wait for 22 ms; -- Esperamos un ciclo PWM completo (20ms) + margen
        
        -- Escenario 2: Puerta abierta (position_cmd = '1')
        -- Se espera un pulso más largo (aprox 1.5ms - 2ms)
        position_cmd <= '1';
        wait for 22 ms;

        wait;
    end process;

end sim;
