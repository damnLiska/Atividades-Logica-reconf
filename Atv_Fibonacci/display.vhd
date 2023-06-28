--Grupo: Os panteras
--Esse código já foi disponibilizado pelo professor, sem modificações feitas nele

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package display is

	-- Type Declaration (optional)
	type display_type is (anode, catode);
	type display_vector is array(natural range <>) of std_logic_vector(0 to 6);

	-- Function Declaration (optional)
	function seven_segment_decode (hex_num : in std_logic_vector(3 downto 0); mode : in display_type) return std_logic_vector;
	function sl_to_dt(mode	:	std_logic) return display_type;
	function display(number : integer; digits: positive; num_base : integer; mode : in display_type) return display_vector;
	function display(number : unsigned; digits: positive; num_base : integer; mode : in display_type) return display_vector;
	function display(number : std_logic_vector; digits: positive; num_base : integer; mode : in display_type) return display_vector;
	
	-- component
	component counter is
		generic(
			clk_freq		:	integer := 50e6;
			update_freq	:	integer := 100;
			n_bits		:	integer := 10
		);
		port(
			clk	:	in		std_logic;
			nRst	:	in		std_logic;
			en		:	in		std_logic;
			q		:	out 	unsigned(n_bits - 1 downto 0)
		);
	end component counter;
	
end package;


package body display is

	-- Type Declaration (optional)

	-- Subtype Declaration (optional)

	-- Constant Declaration (optional)

	-- Function Declaration (optional)
	function seven_segment_decode (hex_num : in std_logic_vector(3 downto 0); mode : in display_type) return std_logic_vector is
		variable segment_out : std_logic_vector(6 downto 0);
   begin
      case hex_num is
          when "0000" => segment_out := "0000001";  -- Displays 0
          when "0001" => segment_out := "1001111";  -- Displays 1
          when "0010" => segment_out := "0010010";  -- Displays 2
          when "0011" => segment_out := "0000110";  -- Displays 3
          when "0100" => segment_out := "1001100";  -- Displays 4
          when "0101" => segment_out := "0100100";  -- Displays 5
          when "0110" => segment_out := "0100000";  -- Displays 6
          when "0111" => segment_out := "0001111";  -- Displays 7
          when "1000" => segment_out := "0000000";  -- Displays 8
          when "1001" => segment_out := "0000100";  -- Displays 9
          when "1010" => segment_out := "0001000";  -- Displays A
          when "1011" => segment_out := "1100000";  -- Displays B
          when "1100" => segment_out := "0110001";  -- Displays C
          when "1101" => segment_out := "1000010";  -- Displays D
          when "1110" => segment_out := "0110000";  -- Displays E
          when "1111" => segment_out := "0111000";  -- Displays F
          when others => segment_out := "1111111";  -- Turns off all segments
      end case;
		if mode = catode then
			return not segment_out;
		else 
		   return segment_out;
		end if;
   end function seven_segment_decode;
	
	function sl_to_dt(mode	:	std_logic) return display_type is
	begin
		if mode = '1' then
			return catode;
		else 
			return anode;
		end if;
			
	end function sl_to_dt;
	
	function display(number : integer; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0);
		variable temp			:	integer;
	begin
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;
			
		temp := number;
		for i in 0 to digits - 1 loop
			
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			temp := temp/num_base;
			
		end loop;
		return dec_digits;
	end function display;
	
	function display(number : unsigned; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0);
		variable temp			:	integer;
	begin
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;
			
		temp := to_integer(number);
		for i in 0 to digits - 1 loop
			
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			temp := temp/num_base;
			
		end loop;
		return dec_digits;
	end function display;
	
	function display(number : std_logic_vector; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0);
		variable temp			:	integer;
	begin
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;
		temp := to_integer(unsigned(number));
		for i in 0 to digits - 1 loop
			
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			temp := temp/num_base;
			
		end loop;
		return dec_digits;
	end function display;

	-- Function Body (optional)

	-- Procedure Declaration (optional)

	-- Procedure Body (optional)

end display;

-- Conatador
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic(
		clk_freq		:	integer := 50e6;
		update_freq	:	integer := 100;
		n_bits		:	integer := 10
	);
	port(
		clk	:	in		std_logic;
		nRst	:	in		std_logic;
		en		:	in		std_logic;
		q		:	out 	unsigned(n_bits - 1 downto 0)
	);
end entity counter;

architecture behavioral of counter is
	constant max	:	integer := clk_freq/update_freq;
begin

	process(clk, nRst) is
		variable ticks	:	integer range 0 to max - 1;
		variable cnt 	:	unsigned(n_bits - 1 downto 0);
	begin
		if nRst = '0' then
			cnt := (others => '0');
			ticks := 0; 
		elsif rising_edge(clk) then
			if en = '1' then
				if ticks = max - 1 then
					ticks := 0;
					cnt := cnt + 1;
				else 
					ticks := ticks + 1;
				end if;
			end if;
		end if;
		q <= cnt;
	end process;

end architecture;