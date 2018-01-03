
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Decoder IS
	GENERIC(INPUT_SIZE: integer := 2);
	PORT (
		input: IN std_logic_vector(INPUT_SIZE-1 DOWNTO 0);
		output: OUT std_logic_vector((2**INPUT_SIZE)-1 DOWNTO 0);
		en: IN std_logic
	);
END Decoder;

ARCHITECTURE structure OF Decoder IS
BEGIN
	PROCESS(input)
	BEGIN
		output <= (OTHERS => '0');
		IF en='1' THEN
			output(to_integer(unsigned(input))) <= '1';
		END IF;
	END PROCESS;
END structure;
