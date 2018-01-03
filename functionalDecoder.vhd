library ieee;
use ieee.std_logic_1164.all;
entity dec is
port ( 	sel	: in std_logic_vector(4 downto 0);
	A	: in std_logic_vector(31 downto 0);
	B	: in std_logic_vector(31 downto 0);
	FRcarry	: in std_logic;
	outCarry: out std_logic;
	F	: out std_logic_vector(31 downto 0));

end dec;

architecture dec_Arch of dec is
	signal ou0,ou1,ou2,ou3,ou4  		: std_logic_vector(31 downto 0);
	signal cout0,cout1,cout2,cout3 		: std_logic;		
	

begin
	out0: entity work.partA port map(sel(1 downto 0),A,B,ou0,FRcarry,cout0);
	out1: entity work.partB port map(sel(1 downto 0),A,B,ou1); 
	out2: entity work.partC port map(sel(1 downto 0),A,FRcarry,cout1,ou2); 
	out3: entity work.partD port map(sel(1 downto 0),A,FRcarry,cout2,ou3); 
	out4: entity work.partE port map(sel(1 downto 0),A,FRcarry,cout3,ou4);

	F <= ou0 when sel(4 downto 2)="000" 
	else ou1 when sel(4 downto 2)="001" 
	else ou2 when sel(4 downto 2)="100" 
	else ou3 when sel(4 downto 2)="101" 
	else ou4 when sel(4 downto 2)="110";

	outCarry <= cout0 when sel(4 downto 2)="000" 
	else FRcarry when sel(4 downto 2)="001" 
	else cout1 when sel(4 downto 2)="100" 
	else cout2 when sel(4 downto 2)="101" 
	else cout3 when sel(4 downto 2)="110";

end dec_Arch;
