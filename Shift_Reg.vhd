library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Shift_Reg is
    generic(n   :   integer := 8);
    port(
        clk, nRst, button   :   in  std_logic; 										   --Definição dos Clock, reset, e botão
		  RX			  			 :   in  std_logic; 											-- Além da definicao do RX(entrada)
		  TX			  			 :   out  std_logic;
		  LED					    :   out  std_logic_vector(n-1 downto 0) 				--Definição dos LED's
    );
end entity;

architecture rtl of Shift_Reg is

signal	vetor		: std_logic_vector(n downto 0); --Vetor é um sinal que represetará a saída do sistema e será demonstrada através dos leds
signal	clock2   : std_logic;						  --Clock2 recebe o sinal de saída do circuito de debouncing, ou seja, um PWM com período de 0,01 s.

begin
	
	inst     :   entity work.Debouncing(main) port map(clk, button, clock2); -- instanciando o código do debouncing (o clock de entrada de 50 MHz e 
	reg :  FOR i in n-1 downto 0 generate												 --o sinal de button são enviados, e o sinal de saída é recebido)
		process (clock2,nRst) is
		begin 																
			if nRst = '0' then 																 --Todos os índices do vetor são zerados caso o nRst esteja ativo (nivel 
				vetor(i) <= '0';															    --lógico baixo)
			
			elsif rising_edge(clock2) then												 --O vetor de saída é rotacionado para a direita sempre que houver uma
																									 --borda de subida no clock vindo do circuito de debouncing (sempre que
																									 --button for pressionado)
				vetor(i) <= vetor(i+1);
	
			end if;
		end process;
		
	end generate reg;
	
	TX <= vetor(0);																			 --O vetor com o sinal de saída é enviado para os LEDs
	vetor(n) <= RX;																				
	LED <= vetor(7 downto 0);									
	
	
end architecture;