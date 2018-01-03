

library ieee;
use ieee.std_logic_1164.all;
entity partC is 
port ( 	sel	: in std_logic_vector(1 downto 0);
	A	: in std_logic_vector(31 downto 0);
	FRcarry : in std_logic;
	outCarry: out std_logic;
	F	: out std_logic_vector(31 downto 0));

end partC;

architecture partC_Arch of partC is
	signal ou0,ou1 			: std_logic_vector(31 downto 0);
	signal cout0,cout1		: std_logic;		
	constant  x : std_logic_vector(31 downto 0) := (others => '0');
	constant  y : std_logic_vector(31 downto 0) := (others => '1');
begin
	out0: entity work.fullAdder generic map (n => 32) port map(A,x,'1',cout0,ou0); -- A+1
	out1: entity work.fullAdder generic map (n => 32) port map(A,y,'0',cout1,ou1); -- A-1
	F <=	A  when sel="11"
	else 	ou0 when sel="00"
	else 	ou1 when sel="01"
	else 	x when sel="10";
	outCarry <= FRcarry when sel="11"
	else	cout0  when sel="00"
	else 	cout1 when sel="01"
	else 	'0' when sel="10";
	
end partC_Arch;