
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY my_nDFFrising IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst        : IN std_logic;
		  EN : IN STD_LOGIC;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END my_nDFFrising;

ARCHITECTURE a_my_nDFF OF my_nDFFrising IS
BEGIN
PROCESS (Clk,Rst,EN)
BEGIN
IF Rst = '1' THEN
		q <= (OTHERS=>'0');
ELSIF rising_edge(Clk)AND EN='1' THEN
		q <= d;
END IF;
END PROCESS;

END a_my_nDFF;

