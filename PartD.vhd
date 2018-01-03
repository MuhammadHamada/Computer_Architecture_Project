library ieee;
use ieee.std_logic_1164.all;
entity partD is 
port ( 	sel	: in std_logic_vector(1 downto 0);
	A	: in std_logic_vector(31 downto 0);
	FRcarry	: in std_logic;
	outCarry: out std_logic;
	F	: out std_logic_vector(31 downto 0));

end partD;

architecture partD_Arch of partD is
	
begin
	F <= '0' & A(31 downto 1)  when sel="00"
	else  A(0)& A(31 downto 1) when sel="01" 
	else FRcarry & A(31 downto 1) when sel="10" 
	else A(31)& A(31 downto 1) when sel="11" ;

	outCarry <= 	A(0) when not (sel ="01")
	else FRcarry;
	
end partD_Arch;