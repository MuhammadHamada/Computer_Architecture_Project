library ieee;
use ieee.std_logic_1164.all;
entity main is 
port ( 	
	busC,busA,busB : inout std_logic_vector (31 downto 0);
	clkReg : in std_logic;
	RESETUSER	: in std_logic);

end main;

architecture main_Arch of main is
	signal ou0,ou1			: std_logic_vector(31 downto 0);
	signal cout0,outCarry,enableFR,MARen,MDRen,Clk: std_logic;	
	signal FRin,FRout :  std_logic_vector(1 downto 0);	
	signal dataOut0,dataOut1,dataOut2,dataOut3,dataOut7,ramDataOut,MDRout,MDRin :std_logic_vector(31 downto 0);
	signal dataOut4,dataOut5,dataOut6,MARin,MARout,PCin : std_logic_vector(15 downto 0);
	signal controlSignals : std_logic_vector(31 downto 0);
	signal IRaddr: std_logic_vector(15 downto 0) := (others => '0');
---------------------------------------------------------------------
	SIGNAL SEL : STD_LOGIC_VECTOR (2 DOWNTO 0);
	signal OUTPLA ,OUTMICROAR , ADDRESS ,NXTADDRESS: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL  CONTROLWORD,OUTMICROIR : STD_LOGIC_VECTOR (24 DOWNTO 0); -- hady outmicro ir l reham ka control word
	SIGNAL RESETIN ,RESET ,HLT : STD_LOGIC ;
	SIGNAL OUTIR : STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL CLKNEW : STD_LOGIC ;

Component Treg is
Generic (n : integer :=16);
port (	d : 	in std_logic_vector(n-1 downto 0) ;
	clk,rst,E,flag:in std_logic;
	q:	out std_logic_vector(n-1 downto 0));
end Component;
	
  
begin
	Clk <=  clkReg and HLT;
	IRaddr(9 downto 0) <= dataOut6(9 downto 0); 
	MARen <= controlSignals(2) OR controlSignals(1);
	MDRen <= controlSignals(4) or controlSignals(5) or controlSignals(3);
	
	PCin <= busC(15 downto 0) and "0000001111111111" when  controlSignals(31 downto 29)="000"
	else busC(15 downto 0);
	 
	RAM: entity work.ram port map(Clk,controlSignals(0),MARout,MDRout,ramDataOut);

	R0: entity work.reg generic map (n => 32) port map(busC,Clk,RESETIN,controlSignals(6),dataOut0);
	R1: entity work.reg generic map (n => 32) port map(busC,Clk,RESETIN,controlSignals(7),dataOut1);
	R2: entity work.reg generic map (n => 32) port map(busC,Clk,RESETIN,controlSignals(8),dataOut2);
	R3: entity work.reg generic map (n => 32) port map(busC,Clk,RESETIN,controlSignals(9),dataOut3);
	PC: entity work.reg generic map (n => 16) port map(PCin,Clk,RESETIN,controlSignals(10),dataOut4); 
	SP: entity work.sreg generic map (n => 16) port map(busC(15 downto 0),Clk,RESETIN,controlSignals(11),dataOut5); 
	IR: entity work.reg generic map (n => 16) port map(busC(15 downto 0),Clk,RESETIN,controlSignals(12),dataOut6); 
	TMP:entity work.reg generic map (n => 32) port map(busA,Clk,RESETIN,controlSignals(13),dataOut7); 
	FLAG:entity work.reg generic map (n => 2) port map(FRin,Clk,RESETIN,EnableFR,FRout); 
	MAR:entity work.reg generic map (n => 16) port map(MARin,Clk,RESETIN,MARen,MARout); 
	MDR:entity work.treg generic map (n => 32) port map(MDRin,Clk,RESETIN,MDRen,controlSignals(0),MDRout); 

	TA0:entity work.triBuffer generic map (n => 32) port map(controlSignals(14),dataOut0,busA); -- R0
	TA1:entity work.triBuffer generic map (n => 32) port map(controlSignals(15),dataOut1,busA); -- R1
	TA2:entity work.triBuffer generic map (n => 32) port map(controlSignals(16),dataOut2,busA); -- R2
	TA3:entity work.triBuffer generic map (n => 32) port map(controlSignals(17),dataOut3,busA); -- R3
	TA4:entity work.triBuffer generic map (n => 16) port map(controlSignals(18),dataOut4,busA(15 downto 0)); -- PC
	TA5:entity work.triBuffer generic map (n => 16) port map(controlSignals(19),dataOut5,busA(15 downto 0)); -- SP

	TB0:entity work.triBuffer generic map (n => 16) port map(controlSignals(25),IRaddr,busB(15 downto 0)); -- IR
	TB1:entity work.triBuffer generic map (n => 32) port map(controlSignals(26),dataOut7,busB); -- TMP
	TB2:entity work.triBuffer generic map (n => 16) port map(controlSignals(27),dataOut4,busB(15 downto 0)); -- PC
	TB3:entity work.triBuffer generic map (n => 32) port map(controlSignals(21),dataOut0,busB); -- R0
	TB4:entity work.triBuffer generic map (n => 32) port map(controlSignals(22),dataOut1,busB); -- R1
	TB5:entity work.triBuffer generic map (n => 32) port map(controlSignals(23),dataOut2,busB); -- R2
	TB6:entity work.triBuffer generic map (n => 32) port map(controlSignals(24),dataOut3,busB); -- R3

	MDRA: entity work.triBuffer generic map (n => 32) port map(controlSignals(20),MDRout,busA); 
	MDRB: entity work.triBuffer generic map (n => 32) port map(controlSignals(28),MDRout,busB); 
	

	MARBUFFA: entity work.triBuffer generic map (n => 16) port map(controlSignals(1),busA(15 downto 0),MARin); 
	MARBUFFC: entity work.triBuffer generic map (n => 16) port map(controlSignals(2),busC(15 downto 0),MARin); -- R3


	MDRBUFFC:   entity work.triBuffer generic map (n => 32) port map(controlSignals(4),busC,MDRin); 
	MDRBUFFRAM: entity work.triBuffer generic map (n => 32) port map(controlSignals(5),ramDataOut,MDRin); -- R3
	MDRBUFFB  : entity work.triBuffer generic map (n => 32) port map(controlSignals(3),busB,MDRin); 
	ALU:entity work.AluGP port map(controlSignals(31 downto 29),busA,busB,FRout,dataOut6(14 downto 10),enableFR,FRin,busC);
---------------------------------------------------------------------------------------
	PLA1    : entity work.PLA PORT MAP (dataOut6,FRout,SEL,OUTPLA,RESET,HLT);  
	MICROAR : entity work.my_nDFFrising  GENERIC MAP (n=>5)  PORT MAP  (Clk ,RESETIN,'1',NXTADDRESS,OUTMICROAR); 
	MICROIR : entity work.my_nDFFfalling GENERIC MAP (n=>25) PORT MAP (Clk ,RESETIN,'1',CONTROLWORD,OUTMICROIR);
	MYROM   : entity work.ROM PORT MAP (CONTROLWORD ,ADDRESS); 
---------------------------------------------------------------------------------------
	DECODEDWORD: entity work.DecodedCircuit port map(dataOut6,OUTMICROIR,controlSignals);
-----------------------------------------------------------------------------------------


----------------------------------------------------------------------------
	SEL     <= OUTMICROIR(6)&OUTMICROIR(8)&OUTMICROIR(7);
	ADDRESS <= OUTMICROAR OR OUTPLA;
	NXTADDRESS <= OUTMICROIR(4)&OUTMICROIR(3)&OUTMICROIR(2)&OUTMICROIR(1)&OUTMICROIR(0);
	RESETIN  <= RESET OR RESETUSER;


end main_Arch;
