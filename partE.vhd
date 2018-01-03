
library ieee;
use ieee.std_logic_1164.all;
entity partE is 
port ( 	sel	: in std_logic_vector(1 downto 0);
	A	: in std_logic_vector(31 downto 0);
	FRcarry	: in std_logic;
	outCarry: out std_logic;
	F	: out std_logic_vector(31 downto 0));

end partE;

architecture partE_Arch of partE is
	
begin
	F <= A(30 downto 0) & '0' when sel="00" 
	else A(30 downto 0) & A(31) when sel="01"
	else A(30 downto 0) & FRcarry when sel="10"
	else  Not A when sel="11" ;
	outCarry <= A(31) when (sel="00" or sel="10")
	else FRcarry;

end partE_Arch;