library IEEE;

use IEEE.std_logic_1164.all;

entity leddcd is
	port(
		 data_in : in std_logic_vector(7 downto 0);
		 segments_out : out std_logic_vector(6 downto 0)
		);
end entity leddcd;

architecture data_flow of leddcd is
begin

segments_out <= "0001000" when data_in = x"61" else
		   	   "0000011" when data_in = x"62" else
		   	   "1000110" when data_in = x"63" else
		   	   "0100001" when data_in = x"64" else
		   	   "0000110" when data_in = x"65" else
			   "0001110";

end architecture data_flow;
