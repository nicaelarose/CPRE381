-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_datapathv2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for the
-- edge-triggered flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_datapathv2 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_datapathv2;

architecture behavior of tb_datapathv2 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component datapathv2
     port(clk			: in std_logic;
		reset		: in std_logic;
		nAddSub		: in std_logic;
		ALUSrc		: in std_logic;
		memWrite	: in std_logic;
		loadData	: in std_logic;
		regWrite	: in std_logic;
		i_A			: in std_logic_vector(4 downto 0);
		i_B			: in std_logic_vector(4 downto 0);
		i_C			: in std_logic_vector(4 downto 0);
        imm16		: in std_logic_vector(15 downto 0);
		o_d1        : out std_logic_vector(31 downto 0);
        o_d2        : out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_clk, s_reset, s_addsub, s_alu, s_memW, s_ldData, s_regW: std_logic;
  signal s_d1, s_d2 : std_logic_vector(31 downto 0);
  signal s_imm : std_logic_vector(15 downto 0);
  signal s_A, s_B, s_C : std_logic_vector(4 downto 0);
begin

  DUT: datapathv2
  port map(s_clk, s_reset, s_addsub, s_alu, s_memW, s_ldData, s_regW, s_A, s_B, s_C, s_imm, s_d1, s_d2);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_clk <= '0';
    wait for gCLK_HPER;
    s_clk <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- Reset the Registers
    s_reset <= '1';
	s_regW 	<= '0';
	s_ldData <= '0';
	s_memW	 <= '0';
	s_addsub <= '0';
	s_alu 	<= '0';
	s_C		<= "00000";
	s_A		<= "00000";
	s_B		<= "00000";
	s_imm	<= x"0000";
		-- Expect d1 and d2 to both read the zero register (0x00000000)
    wait for cCLK_PER;
	s_reset <= '0';
	s_regW 	<= '1';
	
	--Ctrls			ALUSrc		loadData	memWrite	regWrite
	--addi 			1			0			0			1
	--add 			0			0			0			1
	--lw			1			1			0			1
	--sw			1			0			1			0	--B is 1st arg not C
	-----------------MIPS---
	
	s_addsub 	<= '0';
	s_alu 	<= '1';

	s_A		<= "00000";
	s_imm 	<= x"0000";
	s_C		<= "11001";
	wait for cCLK_PER; --addi $25, $0, 0 
	s_alu	<= '1';
	s_ldData	<= '0';
	s_memW	<= '0';
	s_regW	<= '1';
	s_A		<= "00000";
	s_imm 	<= x"0100";
	s_C		<= "11010";
	wait for cCLK_PER; --addi $26, $0, 256 
	s_alu 	<= '1';
	s_ldData <= '1';
	s_memW 	<= '0';
	s_regW 	<= '1';
	s_A		<= "11001";
	s_imm 	<= x"0000";
	s_C		<= "00001";
	wait for cCLK_PER; --lw $1, 0($25)
	s_A		<= "11001";
	s_imm 	<= x"0004";
	s_C		<= "00010";
	wait for cCLK_PER; --lw $2, 4($25)
	s_alu <= '0';
	s_ldData	<= '0';
	s_memW	<= '0';
	s_regW	<= '1';
	s_A		<= "00001";
	s_B		<= "00010";
	s_C		<= "00001";
	wait for cCLK_PER; --add $1, $1, $2
	s_alu   <= '1';
	s_regW	<= '0';
	s_memW	<= '1';
	s_ldData <= '0';
	s_A		<= "11010";
	s_B		<= "00001";
	s_C		<= "00000"; --1st arg B not C
	s_imm 	<= x"0000";
	wait for cCLK_PER; --sw $1, 0($26)
	
	s_alu 	<= '1';
	s_ldData <= '1';
	s_memW 	<= '0';
	s_regW 	<= '1';
	s_A		<= "11001";
	s_imm 	<= x"0008";
	s_C		<= "00010";
	wait for cCLK_PER; --lw $2, 8($25)
	
	s_alu <= '0';
	s_ldData	<= '0';
	s_memW	<= '0';
	s_regW	<= '1';
	s_A		<= "00001";
	s_B		<= "00010";
	s_C		<= "00001";
	wait for cCLK_PER; --add $1, $1, $2

	s_alu   <= '1';
	s_regW	<= '0';
	s_memW	<= '1';
	s_ldData <= '0';
	s_A		<= "11010";
	s_B		<= "00001";
	s_C		<= "00000"; --1st arg B not C
	s_imm 	<= x"0004";
	wait for cCLK_PER; --sw $1, 4($26)
	
	s_alu 	<= '1';
	s_ldData <= '1';
	s_memW 	<= '0';
	s_regW 	<= '1';
	s_A		<= "11001";
	s_imm 	<= x"000C";
	s_C		<= "00010";
	wait for cCLK_PER; --lw $2, 12($25)	
	
	s_alu <= '0';
	s_ldData	<= '0';
	s_memW	<= '0';
	s_regW	<= '1';
	s_A		<= "00001";
	s_B		<= "00010";
	s_C		<= "00001";
	wait for cCLK_PER; --add $1, $1, $2

	s_alu   <= '1';
	s_regW	<= '0';
	s_memW	<= '1';
	s_ldData <= '0';
	s_A		<= "11010";
	s_B		<= "00001";
	s_C		<= "00000"; --1st arg B not C
	s_imm 	<= x"0008";
	wait for cCLK_PER; --sw $1, 8($26)
	
	s_alu 	<= '1';
	s_ldData <= '1';
	s_memW 	<= '0';
	s_regW 	<= '1';
	s_A		<= "11001";
	s_imm 	<= x"0010";
	s_C		<= "00010";
	wait for cCLK_PER; --lw $2, 16($25)	

	s_alu <= '0';
	s_ldData	<= '0';
	s_memW	<= '0';
	s_regW	<= '1';
	s_A		<= "00001";
	s_B		<= "00010";
	s_C		<= "00001";
	wait for cCLK_PER; --add $1, $1, $2
	
	s_alu   <= '1';
	s_regW	<= '0';
	s_memW	<= '1';
	s_ldData <= '0';
	s_A		<= "11010";
	s_B		<= "00001";
	s_C		<= "00000"; --1st arg B not C
	s_imm 	<= x"000C";
	wait for cCLK_PER; --sw $1, 12($26)
	
	s_alu 	<= '1';
	s_ldData <= '1';
	s_memW 	<= '0';
	s_regW 	<= '1';
	s_A		<= "11001";
	s_imm 	<= x"0014";
	s_C		<= "00010";
	wait for cCLK_PER; --lw $2, 20($25)	

	s_alu <= '0';
	s_ldData	<= '0';
	s_memW	<= '0';
	s_regW	<= '1';
	s_A		<= "00001";
	s_B		<= "00010";
	s_C		<= "00001";
	wait for cCLK_PER; --add $1, $1, $2
	
	s_alu   <= '1';
	s_regW	<= '0';
	s_memW	<= '1';
	s_ldData <= '0';
	s_A		<= "11010";
	s_B		<= "00001";
	s_C		<= "00000"; --1st arg B not C
	s_imm 	<= x"0010";
	wait for cCLK_PER; --sw $1, 16($26)

	s_alu 	<= '1';
	s_ldData <= '1';
	s_memW 	<= '0';
	s_regW 	<= '1';
	s_A		<= "11001";
	s_imm 	<= x"0018";
	s_C		<= "00010";
	wait for cCLK_PER; --lw $2, 24($25)

	s_alu <= '0';
	s_ldData	<= '0';
	s_memW	<= '0';
	s_regW	<= '1';
	s_A		<= "00001";
	s_B		<= "00010";
	s_C		<= "00001";
	wait for cCLK_PER; --add $1, $1, $2	
	s_alu	<= '1';
	s_ldData	<= '0';
	s_memW	<= '0';
	s_regW	<= '1';
	s_A		<= "00000";
	s_imm 	<= x"0200";
	s_C		<= "11011";
	wait for cCLK_PER; --addi $27, $0, 512 

	s_addsub <= '1';
	s_alu   <= '1';
	s_regW	<= '0';
	s_memW	<= '1';
	s_ldData <= '0';
	s_A		<= "11011";
	s_B		<= "00001";
	s_C		<= "00000"; --1st arg B not C
	s_imm 	<= x"0004";
	wait for cCLK_PER; --sw $1, -4($27)
	
	--						0+1, 1+2, 3+3, 6+4, 	10+5
	--I expect bits to be 	1, 	 3,   6,   10, and  15 at end
    wait;
  end process;
  
end behavior;
