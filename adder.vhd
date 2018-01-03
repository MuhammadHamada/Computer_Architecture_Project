library ieee;
use ieee.std_logic_1164.all;

entity Adder is
	port (	a,b,cin	: in std_logic;
		F,cout 	: out std_logic);
end Adder;

architecture add of Adder is
begin 
	process (a,b,cin)
	begin 
		F <= a xor b xor cin;
		cout <= (a and b) or (cin and (a xor b));
	end process;
end add;
