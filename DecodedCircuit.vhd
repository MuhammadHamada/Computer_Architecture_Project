
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DecodedCircuit IS
	PORT (
		IR: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		CW: IN std_logic_vector(24 DOWNTO 0);
		ORIGINAL_CW: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END DecodedCircuit;

ARCHITECTURE structure OF DecodedCircuit IS
------------------------------------------------------------------
COMPONENT Decoder
	GENERIC(INPUT_SIZE: integer := 2);
	PORT (
		input: IN std_logic_vector(INPUT_SIZE-1 DOWNTO 0);
		output: OUT std_logic_vector((2**INPUT_SIZE)-1 DOWNTO 0);
		en: IN std_logic
	);
END COMPONENT;
--------------------------------------------------------------------
SIGNAL out3_5, out3_7, out3_8, out3_9: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL out2_3, out2_4: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL isRegDst, isRdstMDR, lst_case_in, lst_case_out, fst_case, new5, isRegSrc: STD_LOGIC;
SIGNAL RorMDRin, RorMDRoutA: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL RsrcIn, RdstIn, RsrcOutA, RdstOutA, RsrcOutB, RdstOutB: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL RorMDRorTMP: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL o1, o2, o3, o4: STD_LOGIC;
BEGIN
 -- Implementation of Decoders
	F4: Decoder
		GENERIC MAP(INPUT_SIZE => 2)
		PORT MAP(cw(10 DOWNTO 9), out2_3, '1');
	F5: Decoder
		GENERIC MAP(INPUT_SIZE => 2)
		PORT MAP(cw(12 DOWNTO 11), out2_4, '1');

	out3_5 <= cw(15 DOWNTO 13);
	ORIGINAL_CW(31 DOWNTO 29) <= cw(18 DOWNTO 16);
	out3_7 <= cw(21 DOWNTO 19);
	out3_9 <= cw(24 DOWNTO 22);
	-------------------------------------
 -- Extract the original CW of the compressed CW
	ORIGINAL_CW(28) <= '1' when (out3_9="001") or (RorMDRorTMP="010") else '0';
	ORIGINAL_CW(27) <= '1' when out3_9="100" else '0';
	ORIGInAL_CW(26) <= '1' when (out3_9="011") or (RorMDRorTMP="001") else '0';
	ORIGINAL_CW(25) <= '1' when out3_9="111" else '0';
----------------------------------------------------------------------------------------
	ORIGINAL_CW(24 DOWNTO 21) <= RsrcOutB WHEN (out3_9="010" or RorMDRorTMP="100")
		ELSE RdstOutB WHEN out3_9="101"
		ELSE "0000";
	WhichRsrcOutB: Decoder
		GENERIC MAP(INPUT_SIZE => 2)
		PORT MAP(IR(7 DOWNTO 6), RsrcOutB, '1');
	WhichRdstOutB: Decoder
		GENERIC MAP(INPUT_SIZE => 2)
		PORT MAP(IR(3 DOWNTO 2), RdstOutB, '1');
-----------------------------------------------------------------------------------------
	ORIGINAL_CW(20) <= '1' when out3_7="011" or RorMDRoutA="01" else '0';
	ORIGINAL_CW(19) <= '1' when out3_7="001" else '0';
	ORIGINAL_CW(18) <= '1' when out3_7="010" else '0';
-----------------------------------------------------------------------------------------
	ORIGINAL_CW(17 DOWNTO 14) <= RsrcOutA WHEN out3_7="100"
		ELSE RdstOutA WHEN (RorMDRoutA="10" or out3_7="101")
		ELSE "0000";

	WhichRsrcOutA: Decoder
		GENERIC MAP(INPUT_SIZE => 2)
		PORT MAP(IR(7 DOWNTO 6), RsrcOutA, '1');
	WhichRdstOutA: Decoder
		GENERIC MAP(INPUT_SIZE => 2)
		PORT MAP(IR(3 DOWNTO 2), RdstOutA, '1');
-----------------------------------------------------------------------------------------
	ORIGINAL_CW(13) <= '1' when out3_5="101" else '0';
	ORIGINAL_CW(12) <= '1' when out3_5="011" else '0';
	ORIGINAL_CW(11) <= '1' when out3_5="100" else '0';
	ORIGINAL_CW(10) <= '1' when out3_5="010" else '0';
-----------------------------------------------------------------------------------------
	ORIGINAL_CW(9 DOWNTO 6) <= RsrcIn WHEN out3_5="001"
		ELSE RdstIn WHEN (RorMDRin="10" or out3_5="110")
		ELSE "0000";

	WhichRsrcIn: Decoder
		GENERIC MAP(INPUT_SIZE => 2)
		PORT MAP(IR(7 DOWNTO 6), RsrcIn, '1');

	WhichRdstIn: Decoder
		GENERIC MAP(INPUT_SIZE => 2)
		PORT MAP(IR(3 DOWNTO 2), RdstIn, '1');
-----------------------------------------------------------------------------------------
	ORIGINAL_CW(5) <= out2_4(3); --F4 (no-trans, MARinA, MARinC)
	ORIGINAL_CW(4) <= '1' WHEN RorMDRin="01" or out2_4(2)='1' ELSE '0';
	ORIGINAL_CW(3) <= out2_4(1);

	ORIGINAL_CW(2 DOWNTO 1) <= out2_3(3 DOWNTO 2); --F3 (no-op, dest, cmp, ORthenAfterSRC)
	ORIGINAL_CW(0) <= new5; --F1 (Read, Write)
	-------------------------------------------
 -- Choose whether to load RdstINa or MDRinA
	isRegDst <= not(IR(5) or IR(4)); --1
	isRegSrc <= not(IR(9) or IR(8)); --1
	lst_case_in <= '1' WHEN CW(15 DOWNTO 13)="111"
		ELSE '0'; --1
	lst_case_out <= '1' WHEN CW(21 DOWNTO 19)="111"
		ELSE '0';--1
	fst_case <= '1' WHEN CW(24 DOWNTO 22)="000"
		ELSE '0';--1
	
	new5 <= (not(isRegDst) and lst_case_in) or CW(5);

	RorMDRin <= "10" WHEN isRegDst='1' and lst_case_in='1'
		ELSE "01" WHEN lst_case_in='1'
		ELSE "00";
	RorMDRorTMP <= "100" WHEN isRegSrc='1' and fst_case='1'
		ELSE "010" WHEN isRegDst='1' and fst_case='1'
		ELSE "001" WHEN fst_case='1'
		ELSE "000";
	RorMDRoutA <= "10" WHEN isRegDst='1' and lst_case_out='1'
		ELSE "01" WHEN lst_case_out='1'
		ELSE "00";
	
END structure;
