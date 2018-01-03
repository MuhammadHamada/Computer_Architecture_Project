library ieee;
use ieee.std_logic_1164.all;
entity partF is 
port ( 	sel	: in std_logic_vector(2 downto 0);
	A	: in std_logic_vector(31 downto 0);
	B	: in std_logic_vector(31 downto 0);
	F	: out std_logic_vector(31 downto 0));

end partF;

architecture partF_Arch of partF is
	signal ou0,ou1,ou2,ou3,ou4,ou5 			: std_logic_vector(31 downto 0);
	signal cout0,cout1,cout2,cout3,cout4,cout5		: std_logic;		
	constant  x : std_logic_vector(31 downto 0) := (31 downto 16 => '0' , others => '1');
	constant  y : std_logic_vector(31 downto 0) := ( others => '0');
	constant  two : std_logic_vector(31 downto 0) := ((1) => '1', others => '0');
	constant  negOne : std_logic_vector(31 downto 0) := (others => '1');
	constant  negTwo : std_logic_vector(31 downto 0) := ((0) => '0' , others => '1');
	signal newA,newB : std_logic_vector(31 downto 0);
	signal emp:std_logic_vector(31 downto 0) := (others => 'Z');
begin
	newA <= A AND x;
	newB <= B AND x;
	out0: entity work.fullAdder generic map (n => 32) port map(newA ,newB,'0',cout0,ou0); -- A+B
	out1: entity work.fullAdder generic map (n => 32) port map(newA,y,'1',cout1,ou1); -- A+1
	out2: entity work.fullAdder generic map (n => 32) port map(newA,negOne,'0',cout2,ou2); -- A-1
	out3: entity work.fullAdder generic map (n => 32) port map(newA,two,'0',cout3,ou3); -- A+2
	out4: entity work.fullAdder generic map (n => 32) port map(newA,negTwo,'0',cout4,ou4); -- A-2
	out5: entity work.fullAdder generic map (n => 32) port map(B,y,'0',cout5,ou5);	
	F <=	ou0  when sel="000"
	else 	ou1 when sel="001"
	else 	ou2 when sel="010"
	else 	ou3 when sel="011"
	else 	ou4 when sel="100"
	else 	ou5 when sel="110"
	else 	emp;
end partF_Arch;