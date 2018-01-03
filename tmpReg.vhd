
library ieee;
use ieee.std_logic_1164.all;

entity Treg is
Generic (n : integer :=16);
port (	d : 	in std_logic_vector(n-1 downto 0) ;
	clk,rst,E,flag:in std_logic;
	q:	out std_logic_vector(n-1 downto 0));
end Treg;

architecture Tstore of Treg is 
signal z: std_logic_vector (n-1 downto 0):=(others => '0');
begin
	process(clk,rst)
	begin
		if rst = '1' then
			q <= (others=>'0');
		elsif 	E='1' and flag = '1' and rising_edge(clk) then
			q <= d; 
		elsif 	E='1' and flag = '0' and falling_edge(clk) then
			q <= d; 
		end if;
	end process;
			
end Tstore;