


--Grupo: Os panteras
--Atividade de Debouncing

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Debouncing is
    Port (
        clk   				: in STD_LOGIC; 			--clock de 50 MHz
        button				: in STD_LOGIC;				--bit de entrada
        result 		                : out STD_LOGIC				--bit de saída
		  
    );
end Debouncing;

architecture main of Debouncing is			

	 signal x1, x2, SCLR	 	 	: STD_LOGIC;
	 signal contador			: integer range 0 to 500000;	 --sinal que extoura e reinicia
	 									 --depois de 10 ms (p/ fclock = 50 MHz)
begin

	 SCLR  <= x1 xor x2;
	 process(clk, x2, x1)
	 begin
	 
		if rising_edge(clk) then
			x1 <= button;				--Process responsavel por caracterizar os dois 
			x2 <= x1;				--flip-flops D da entrada do circuito, sempre
		end if;						--que houver borda de subida no clock o bit da entrada
	 end process;						--é passado para a variável posterior
	
	 process(clk, button, x2, SCLR, contador)
	 begin
		if SCLR = '1' then
				contador <= 0;			--Enquanto SCLR for 1 o contador não irá contar
			
		elsif rising_edge(clk) then
							
			if (contador = 500000) then
					result <= x2;		--contador é incrementado 500 mil vezes para atingir
			else					--o período de 10 ms, ja que a frequencia de clock
				contador <= contador + 1;	--utilizada é de 50 MHz (500k *(1/50M) = 0,01)
			end if;					--Quando a contagem extoura a saída recebe x2
		end if;
    end process;

end main;

--Resumidamente, sempre que houver uma mudança no estado de button (entrada), o contador será resetado e só "abrirá"
--caminho para o bit ir para result (saída) depois de 10 milisegundos, caso nao haja nenhuma outra variação na entrada