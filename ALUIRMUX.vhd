library ieee;
use ieee.std_logic_1164.all;
entity AluGP is 
port ( 	GPsel	: in std_logic_vector(2 downto 0);
	A	: in std_logic_vector(31 downto 0);
	B	: in std_logic_vector(31 downto 0);
	--FRcarry	: in std_logic;
	--outCarry: out std_logic;
	--FRz	: out std_logic;
	--FRzin	: in std_logic;
	FRin	: in std_logic_vector(1 downto 0);
	IRsel	: in std_logic_vector(4 downto 0);
	enableFR : out std_logic;
	FRout	 : out std_logic_vector(1 downto 0);
	F	: out std_logic_vector(31 downto 0));

end AluGP;

architecture result of AluGP is
	signal ou0,ou1			: std_logic_vector(31 downto 0);
	signal cout0	: std_logic;		
begin
	u0: entity work.dec port map(IRsel,A,B,FRin(1),cout0,ou0);
	u1: entity work.partF port map(GPsel,A,B,ou1);
	F <= ou0 when GPsel = "101"
	else ou1;
	
	enableFR <= '1' when GPsel = "101"
	else '0';
	FRout(1) <= cout0 when GPsel = "101"
	else FRin(1);
	
	FRout(0) <= '1' when GPsel ="101" and ou0="00000000000000000000000000000000"
	else '0' when GPsel="101" and not (ou0="00000000000000000000000000000000")
	else FRin(0);
	

end result;