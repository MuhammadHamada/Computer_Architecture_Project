LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PLA IS  
		PORT (      IR          :  IN STD_LOGIC_VECTOR (15 DOWNTO 0);   
			    FLAG        :  IN STD_LOGIC_VECTOR (1 DOWNTO 0);     
			    SEL 	:  IN STD_LOGIC_VECTOR (2 DOWNTO 0);
  		            OUT1        :  OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			    RESET,HLT   :  OUT STD_LOGIC );    
END ENTITY PLA;

ARCHITECTURE DATA_FLOW OF PLA IS
	SIGNAL ORafterSRC,ORcmp,ORdst,InitialAddress : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL TwoOperand,OneOperand,Branch,NoOperand : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL SelOperand : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL SELOPPORMODE : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL SELSRCORNOT : STD_LOGIC ;
	SIGNAL TwoOperandSRC,TwoOperandNotSRC : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL TwoOperandYALADST,TwoOperandMOV,TwoOperandCMP : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL SelNoOperand,SelBranch  :STD_LOGIC_VECTOR (2 DOWNTO 0) ;
	SIGNAL BRANCHORNOT,ISMOVE :STD_LOGIC ;
	SIGNAL AFTERSRCNOTDST,AFTERSRCDST :STD_LOGIC_VECTOR (4 DOWNTO 0) ;
	SIGNAL MODEDSTNOTSRC :STD_LOGIC_VECTOR (4 DOWNTO 0) ;
	SIGNAL SELOTAFTERSRC,HLT1,RESET1 :STD_LOGIC;
	SIGNAL OPCODE : STD_LOGIC_VECTOR (5 DOWNTO 0);
BEGIN
	OUT1 <= "00000" WHEN  SEL="000"
	ELSE  ORdst   WHEN  SEL="001"
	ELSE  ORcmp   WHEN  SEL="010"
 	ELSE  ORafterSRC   WHEN  SEL="011"
        ELSE  InitialAddress;
	OPCODE <= IR(15)&IR(14)&IR(13)&IR(12)&IR(11)&IR(10);
	-- Select The number of operand in the instruction from the IR and save it in the initialAddress
	SelOperand <= (IR(15)&IR(14));
	InitialAddress <= TwoOperand WHEN SelOperand="00" -- Address where to go in case of two operand
	ELSE  OneOperand WHEN SelOperand="01"
	ELSE  Branch WHEN SelOperand="10"
	ELSE  NoOperand;

	SelSrcOrNot <= IR(9) OR IR(8); -- Based on whether you are register mode or not **SelSrcOrNot='1' in case you arn't register mode
	TwoOperandNotSRC <= "00"&IR(9)&IR(8)&"0";
	TwoOperand <= TwoOperandSRC WHEN SelSrcOrNot='0' -- Go to Address of dest directly in case the src is register mode or to MOV or to CMP
	ELSE TwoOperandNotSrc; -- Go to this Address in case it's not register mode

 	-- First two bits of the IR selects whether it's Mov or CMP or other
	SelOppOrMode <= IR(1)&IR(0); --MOVE OR CMP OR YALA DST 
	-- Get the address from the mode of the dest in case it's not MOV or CMP
	TwoOperandYALADST <= "01"&IR(5)&IR(4)&"0";	
	-- Get the address in case it's MOV
	TwoOperandMOV <= "10"&IR(5)&IR(4)&"0";
	-- Get the address in case it's CMP
	TwoOperandCMP <= "01101" WHEN (IR(5) OR IR(4))='0' -- dest is register mode
		ELSE "01"&IR(5)&IR(4)&"0";
	TwoOperandSRC <= TwoOperandYALADST WHEN  SelOppOrMode="00" 
		ELSE  TwoOperandMOV WHEN  SelOppOrMode="01"
		ELSE  TwoOperandCMP;

	OneOperand <= "01"&IR(5)&IR(4)&"0";
	SelBranch <= IR(12)&IR(11)&IR(10);
	SelNoOperand <= IR(12)&IR(11)&IR(10);
	NoOperand <= "00000" WHEN SelNoOperand="000"
	ELSE "11011" WHEN SelNoOperand="001"
	ELSE "00000" WHEN SelNoOperand= "010"
	ELSE "01011" WHEN SelNoOperand="011"
	ELSE "00011";
	HLT  <= '0'  WHEN OPCODE  ="110000"
	ELSE '1';
	RESET <='1' WHEN OPCODE  ="110010"
	ELSE '0';
	BranchOrNot <=  '1' WHEN SelBranch="000"
	ELSE FLAG(0) WHEN SelBranch="001" -- Z->0
	ELSE (NOT FLAG(0)) WHEN SelBranch="010"
	ELSE  (NOT FLAG(1))WHEN SelBranch="011" -- C->1
	ELSE ((NOT FLAG(1)) OR FLAG(0))WHEN SelBranch="100"
	ELSE FLAG(1) WHEN SelBranch="101" 
	ELSE (FLAG(0)OR FLAG(1));
	BRANCH <= "00000" WHEN BranchOrNot='0'
	ELSE "11101" ;
	ORCMP <= "00101"  WHEN IR(1)='1'
	ELSE "00000";
	ORDST <="00"&IR(5)&IR(4)&"0";
	IsMove <= IR(0);
	AFTERSRCDST <= "01000"WHEN SELOPPORMODE="00"
	ELSE  "11000" WHEN  SELOPPORMODE="01"
	ELSE  "01101" ;
	MODEDSTNOTSRC <="11"&IR(5)&IR(4)&"0";
	AFTERSRCNOTDST <= "01001"WHEN ISMOVE='0'
	ELSE  MODEDSTNOTSRC ;
	SELOTAFTERSRC <= IR(5)OR IR(4);
	ORAFTERSRC <= AFTERSRCDST WHEN SELOTAFTERSRC ='0'
	ELSE AFTERSRCNOTDST;
	
END Data_flow;