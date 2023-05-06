--Registrador Paralelo parametrizado
-- Grupo: Os Panteras
-- Integrantes: Denis Paradella, Gabriel Otavio, Henrique Liska e Luiz Pessoa
-- PRATICA 05


library ieee; 	--Chamando as bibliotecas 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity parametrized_parallel_register is
    generic(n   :   integer := 8); 
    port(
	clk 	: 	in std_logic; --clock definido como entrada do tipo std_logic
	rst	:	in std_logic; --reset definido como entrada do tipo std_logic
        v   	    :   in  std_logic_vector(n-1 downto 0); -- seria as chaves definidas como vetor de n bits
        q           :   out std_logic_vector(n - 1 downto 0) -- saida tambem definida como vetor de n bits
    );
end entity;

architecture main of parametrized_parallel_register is
begin
    process(clk, rst) is
    begin
        if rst = '0' then -- se o reset estiver em zero, a saida assume valor zero
                q <= (others => '0');            
            elsif rising_edge(clk) then  -- quando o clock estiver na borda de subida
                q <= v;                  -- "q" vai receber o valor de "v"            
            end if;
    end process;
end architecture;