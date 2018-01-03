library ieee;
use ieee.std_logic_1164.all;
entity partA is 
port ( 	sel	: in std_logic_vector(1 downto 0);
	A,B	: in std_logic_vector(31 downto 0);
	F	: out std_logic_vector(31 downto 0);
	FRcarry	: in std_logic;
	outCarry: out std_logic);

end partA;

architecture partA_Arch of partA is

	signal ou0,ou1,ou2,ou3  		: std_logic_vector(31 downto 0);
	signal cout0,cout1,cout2,cout3 		: std_logic;		
	signal  x : std_logic_vector(31 downto 0) := (others => '1');
begin
	x(0) <= "not"(FRcarry);
	out0: entity work.fullAdder generic map (n => 32) port map(A,B,'0',cout0,ou0); -- A+B
	out1: entity work.fullAdder generic map (n => 32) port map(A,B,FRcarry,cout1,ou1); -- A+B+C
	out2: entity work.fullAdder generic map (n => 32) port map(A,"not"(B),'1',cout2,ou2); -- A-B
	out3: entity work.fullAdder generic map (n => 32) port map(ou2,x,'1',cout3,ou3); -- A-B-C
	F <=	ou0 when sel="00"
	else 	ou1 when sel="01"
	else 	ou2 when sel="10"
	else 	ou3 when sel="11";

	outCarry <=	cout0 when sel="00"
	else 	cout1 when sel="01"
	else 	cout2 when sel="10"
	else 	cout3 when sel="11" and cout2='1'
	else 	cout2 when sel="11";
	
end partA_Arch;

