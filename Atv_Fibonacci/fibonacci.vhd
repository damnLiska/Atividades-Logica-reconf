--Grupo: Os panteras

--Atividade: Fazer a sequencia de fibonacci utilizando maquina de estados

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.display.all; -- Adicione essa linha para utilizar o pacote display

entity fibonacci is
    generic (input_freq: integer := 50e6); -- fpga trabalhando a 50kHz, temos input_freq de valor 1000, fazendo depois a constante 'microsegundo' ter exatamente 1ms
    port (
        p     : out display_vector(5 downto 0);
        clk   : in std_logic;
        nRst  : in std_logic
    );
end entity fibonacci;

architecture rtl of fibonacci is                       -- definição da arquitetura
    constant microsegundo      : integer := input_freq / 1e6; 		--constante microsegundo que recebe o valor de input_freq dividido por 1000000 -> input_freq tem valor 1000
    signal contador            : integer := 0;                    -- definição de sinais para serem usados no estouro de 1 segundo
    signal state               : integer range 0 to 1 := 0;
    signal fibonacci_atual     : unsigned(5 downto 0) := (others => '0'); -- sinais para fazer a contagem  de fibonacci
    signal fibonacci_next      : unsigned(5 downto 0) := (others => '0');
begin
    fsm: process(clk, nRst) is        
    begin
        if rising_edge(clk) then
            case state is
                when 0 => 													-- Estado de reset
                    contador <= 0;
                    fibonacci_atual <= (others => '0');
                    fibonacci_next <= (others => '0');
                    if contador = 0 then
                        state <= 1;										-- Transição para o Estado de cálculo
                    end if;
                when 1 => 													-- Estado de cálculo
                    if contador = 0 then
                        fibonacci_atual <= fibonacci_next;     -- fibonacci_atual recebe o valor da fibonacci_next
                        fibonacci_next <= fibonacci_atual + fibonacci_next; -- fibonacci_next recebe fibonacci_atual + fibonacci_next
                    end if;												-- fazendo assim com que o valor atual seja a soma dos dois numeros anteriores
                    contador <= contador + 1;
                    if contador = 1000000 * microsegundo then 	-- a cada 1 milhão de microssegundos se obtém 1 segundo
                        state <= 0; 
                        contador <= 0;
                    end if;
            end case;
        end if;
        p <= display(unsigned(fibonacci_atual), 6, 10, anode); --envia o valor de 'p' para o display, atualizando sempre a cada 1 segundo
    end process fsm;
end architecture;