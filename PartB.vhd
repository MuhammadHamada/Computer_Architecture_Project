
library ieee;
use ieee.std_logic_1164.all;
entity partB is 
port ( 	sel	: in std_logic_vector(1 downto 0);
	A,B	: in std_logic_vector(31 downto 0);
	F	: out std_logic_vector(31 downto 0));

end partB;

architecture partB_Arch of partB is

begin

	F <=	A AND B when sel="00"
	else 	A OR B when sel="01"
	else 	A XOR B when sel="10"
	else 	A AND "not"(B) when sel="11";
	
end partB_Arch;