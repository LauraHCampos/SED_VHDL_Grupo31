library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_Controller is
    Port ( 
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        state_code : in  STD_LOGIC_VECTOR(2 downto 0);
        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        an         : out STD_LOGIC_VECTOR(7 downto 0)
    );
end Display_Controller;

architecture Behavioral of Display_Controller is
    signal refresh : unsigned(19 downto 0);
    signal sel     : std_logic_vector(1 downto 0);

    constant C_C     : std_logic_vector(6 downto 0) := "1000110";
    constant C_L     : std_logic_vector(6 downto 0) := "1000111";
    constant C_S     : std_logic_vector(6 downto 0) := "0010010";
    constant C_E     : std_logic_vector(6 downto 0) := "0000110";
    constant C_O     : std_logic_vector(6 downto 0) := "1000000";
    constant C_P     : std_logic_vector(6 downto 0) := "0001100";
    constant C_N     : std_logic_vector(6 downto 0) := "0101011"; 
    constant C_R     : std_logic_vector(6 downto 0) := "0101111"; 
    constant C_BLANK : std_logic_vector(6 downto 0) := "1111111";

begin
    -- Contador para el refresco de los displays
    process(clk) begin 
        if rising_edge(clk) then 
            refresh <= refresh + 1; 
        end if; 
    end process;

    -- Seleccionamos los 4 displays de la derecha para el multiplexado
    sel <= std_logic_vector(refresh(19 downto 18));
    
    process(sel, state_code) begin
        an <= "11111111"; -- Apagar todos por defecto
        case sel is
            when "00" => an <= "11111110"; -- Dígito 0
            when "01" => an <= "11111101"; -- Dígito 1
            when "10" => an <= "11111011"; -- Dígito 2
            when "11" => an <= "11110111"; -- Dígito 3
            when others => null;
        end case;

        -- Lógica de visualización según el estado de la FSM
        case state_code is
            when "000" => -- Mostrar "CLSE" (Closed)
                case sel is
                    when "00" => seg <= C_E; 
                    when "01" => seg <= C_S; 
                    when "10" => seg <= C_L; 
                    when "11" => seg <= C_C; 
                    when others => seg <= C_BLANK;
                end case;

            when "001" | "010" => -- Mostrar "OPEN" (Opening/Wait)
                case sel is
                    when "00" => seg <= C_N; 
                    when "01" => seg <= C_E; 
                    when "10" => seg <= C_P; 
                    when "11" => seg <= C_O; 
                    when others => seg <= C_BLANK;
                end case;

            when "011" => -- Mostrar "CLOS" (Closing)
                case sel is
                    when "00" => seg <= C_S;
                    when "01" => seg <= C_O;
                    when "10" => seg <= C_L;
                    when "11" => seg <= C_C;
                    when others => seg <= C_BLANK;
                end case;

            when "100" => -- Mostrar "Err" (Obstáculo/Error)
                case sel is
                    when "00" => seg <= C_R;
                    when "01" => seg <= C_R;
                    when "10" => seg <= C_E;
                    when others => seg <= C_BLANK;
                end case;

            when others => seg <= C_BLANK;
        end case;
    end process;
end Behavioral;