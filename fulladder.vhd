library ieee;
use ieee.std_logic_1164.all;

entity fullAdder is
	generic (n:integer :=16);
	port (	a,b 	: in std_logic_vector(n-1 downto 0);
		cin	: in std_logic;
		cout	: out std_logic;
		F	: out std_logic_vector(n-1 downto 0));
end fullAdder;

architecture fullAdd of fullAdder is
	component Adder is  
		port (	a,b,cin	: in std_logic;
			F,cout 	: out std_logic);
	end component;
	signal tmp:std_logic_vector(n-1 downto 0);
begin 
	fo:Adder port map(a(0),b(0),cin,F(0),tmp(0));
		loop1: for i in 1 to n-1 generate 
			fx:Adder port map(a(i),b(i),tmp(i-1),F(i),tmp(i));
			end generate;
		cout <= tmp(n-1); 
end fullAdd;