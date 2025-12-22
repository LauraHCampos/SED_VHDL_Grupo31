library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM_Garaje is
    Port ( 
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        
        -- Entradas
        s_obstaculo : in  STD_LOGIC; -- '1' si detecta objeto
        btn_open    : in  STD_LOGIC; -- '1' pulsado (ya viene limpio del debouncer)
        timer_done  : in  STD_LOGIC; -- '1' cuando el timer termina la cuenta
        
        -- Salidas
        start_timer : out STD_LOGIC; -- Orden para iniciar/resetear cuenta del timer
        motor_open  : out STD_LOGIC; -- Control Motor Abrir (LED0)
        motor_close : out STD_LOGIC  -- Control Motor Cerrar (LED1)
    );
end FSM_Garaje;

architecture Behavioral of FSM_Garaje is

    -- Definición de Estados (Moore)
    type state_type is (
        S_CLOSED,       -- Puerta totalmente cerrada (Reposo)
        S_PRE_OPEN,     -- Estado transitorio para iniciar timer de apertura
        S_OPENING,      -- Puerta abriéndose (simulado por tiempo)
        S_PRE_WAIT,     -- Estado transitorio para iniciar timer de espera
        S_WAIT_OPEN,    -- Puerta abierta esperando (Garage abierto)
        S_PRE_CLOSE,    -- Estado transitorio para iniciar timer de cierre
        S_CLOSING       -- Puerta cerrándose
    );
    
    signal state_reg, state_next : state_type;

begin

    -- 1. Proceso Secuencial: Memoria de Estado
    process(clk, rst)
    begin
        if rst = '1' then
            state_reg <= S_CLOSED;
        elsif rising_edge(clk) then
            state_reg <= state_next;
        end if;
    end process;

    -- 2. Proceso Combinacional: Lógica de Siguiente Estado y Salidas
    process(state_reg, btn_open, timer_done, s_obstaculo)
    begin
        -- Valores por defecto para evitar latches
        state_next <= state_reg;
        start_timer <= '0';
        motor_open  <= '0';
        motor_close <= '0';

        case state_reg is
            
            -- Estado: CERRADA (Reposo)
            when S_CLOSED =>
                -- Esperamos botón para abrir
                if btn_open = '1' then
                    state_next <= S_PRE_OPEN;
                end if;

            -- Estado: PREPARAR APERTURA (Pulso start)
            when S_PRE_OPEN =>
                start_timer <= '1'; -- Disparamos el timer (5 seg de subida)
                state_next  <= S_OPENING;

            -- Estado: ABRIENDO
            when S_OPENING =>
                motor_open <= '1'; -- Activamos motor abrir
                -- Simulamos que tarda un tiempo en llegar arriba (o final de carrera virtual)
                if timer_done = '1' then
                    state_next <= S_PRE_WAIT;
                end if;

            -- Estado: PREPARAR ESPERA (Pulso start)
            when S_PRE_WAIT =>
                start_timer <= '1'; -- Disparamos el timer (5 seg de espera arriba)
                state_next  <= S_WAIT_OPEN;

            -- Estado: ESPERANDO ABIERTA
            when S_WAIT_OPEN =>
                -- La puerta está quieta arriba. Esperamos a que pase el tiempo para cerrar sola.
                -- (Opcional: Si pulsan botón aquí, podríamos reiniciar el timer)
                if timer_done = '1' then
                    state_next <= S_PRE_CLOSE;
                end if;

            -- Estado: PREPARAR CIERRE (Pulso start)
            when S_PRE_CLOSE =>
                start_timer <= '1'; -- Disparamos el timer (5 seg de bajada)
                state_next  <= S_CLOSING;

            -- Estado: CERRANDO
            when S_CLOSING =>
                motor_close <= '1'; -- Activamos motor cerrar
                
                -- PRIORIDAD 1: SEGURIDAD (Obstáculo)
                if s_obstaculo = '1' then
                    -- Si hay algo en medio, reabrimos inmediatamente
                    state_next <= S_PRE_OPEN; 
                
                -- PRIORIDAD 2: Fin de recorrido
                elsif timer_done = '1' then
                    state_next <= S_CLOSED;
                end if;

            when others =>
                state_next <= S_CLOSED;
        end case;
    end process;

end Behavioral;