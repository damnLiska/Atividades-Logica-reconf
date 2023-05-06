library ieee;
--testbench do registrador paralelo parametrizado
-- Grupo: Os Panteras
-- Integrantes: Denis Paradella, Gabriel Otavio, Henrique Liska e Luiz Pessoa
-- PRATICA 05


use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is
    
end entity;

architecture sim of testbench is
    constant n          :   integer := 8; --definindo o tamanho de N, e as frequencias de clock 
    constant clkFreq    :   integer := 100e6;   -- 100 MHz
    constant clkPer     :   time    := 1000 ms / clkFreq;

    signal clk  :   std_logic := '1'; --definindo os sinais de clock, reset, 'q' e 'V'
    signal rst  :   std_logic := '0';
    signal q    :   std_logic_vector(n - 1 downto 0);
    signal v    :   std_logic_vector(n - 1 downto 0);
begin

    
    f   :   entity work.parametrized_parallel_register(main) --chamando a architecture do codigo normal(não sendo o testbench)
	generic map(n)
	port map(clk, rst,v, q);

     
    clk <= not clk after 10 ns;


        rst <=  '1', --definindo o reset atraves de algum tempo, para ver na simulação
            '0'after 230 ns, 
            '1'after 270 ns;

    	v <= (others => '0'), -- definindo "v" após algum tempo para ver na simulação
            (others => '1') after 123 ns,
            (others => '0') after 170 ns,
            (others => '1') after 210 ns,
            (others => '0') after 340 ns; 
			      -- foi colocado valores aleatorios de tempo para dar de ver na simulação com mais facilidade
       
    

end architecture;
