
library ieee;
use ieee.std_logic_1164.all;

entity sreg is
Generic (n : integer :=16);
port (	d : 	in std_logic_vector(n-1 downto 0) ;
	clk,rst,E:in std_logic;
	q:	out std_logic_vector(n-1 downto 0));
end sreg;
-- flag 
-- REG 00
-- MAR 01 level 0
-- Tmp 10 level 1
architecture sstore of sreg is 
begin
	process(clk,rst)
	begin
		if rst = '1' then
			q <= "0000011111111111";
		elsif 	E='1' and rising_edge(clk) then
			q <= d; 
		end if;
	end process;
 	
end sstore;