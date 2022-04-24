------------------------------------------------------------------
-- Nicaela Rose
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_regfile.vhd
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

entity tb_regfile is
  generic(gCLK_HPER   : time := 50 ns);
end tb_regfile;

architecture behavior of tb_regfile is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component regfile
    port(clk			: in std_logic;
		i_wA		: in std_logic_vector(4 downto 0);
		i_wD		: in std_logic_vector(31 downto 0);
		i_wC		: in std_logic;
		i_r1		: in std_logic_vector(4 downto 0);
		i_r2		: in std_logic_vector(4 downto 0);
		reset		: in std_logic;
        o_d1        : out std_logic_vector(31 downto 0);
        o_d2        : out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_clk, s_reset, s_wC  : std_logic;
  signal s_wD, s_d1, s_d2 : std_logic_vector(31 downto 0);
  signal s_wA, s_r1, s_r2 : std_logic_vector(4 downto 0);
begin

  DUT: regfile
  port map(s_clk, s_wA, s_wD, s_wC, s_r1, s_r2, s_reset, s_d1, s_d2);

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
    -- Reset the FF
    s_reset <= '1';
	s_wC 	<= '0';
	s_wA	<= "00000";
	s_r1	<= "00000";
	s_r2	<= "00000";
	s_wD	<= x"00000000";
		-- Expect d1 and d2 to both read the zero register (0x00000000)
    wait for cCLK_PER;

	s_reset <= '0';
	s_wC 	<= '1';
	s_wA	<= "00001";
	s_r1	<= "00001";
	s_r2	<= "00000";
	s_wD	<= x"000DECAF";
		-- Expect d1 to read $1 (0xDECAF) and 
		-- d2 to read the zero register (0x00000000)
	wait for cCLK_PER;
	
	s_wC 	<= '1';
	s_wA	<= "00010";
	s_r1	<= "00001";
	s_r2	<= "00010";
	s_wD	<= x"00DEECAF";
		-- Expect d1 to read $1 (0xDECAF) and 
		-- d2 to read $2 (0xDEECAF)
	wait for cCLK_PER;
	
	s_wC 	<= '0';
	s_wA	<= "00011";
	s_r1	<= "00001";
	s_r2	<= "00011";
	s_wD	<= x"00FAC000";
		-- Expect no write to occur
		-- d1 to read $1 (0xDECAF) and 
		-- d2 to read register 3 (0x00000000) still null, no write
	wait for cCLK_PER;
	
	s_wC 	<= '1';
	s_wA	<= "00100";
	s_r1	<= "00100";
	s_r2	<= "00010";
	s_wD	<= x"44444444";
		-- Expect d1 to read $4 (0x44444444) and 
		-- d2 to read $2 should still be (0xDEECAF)
	wait for cCLK_PER;
	
	s_wC 	<= '1';
	s_wA	<= "11111";
	s_r1	<= "11111";
	s_r2	<= "00000";
	s_wD	<= x"FFFFFFFF";
		-- Expect d1 to read $31 (0xFFFFFFFF) and 
		-- d2 to read the zero register (0x00000000)
	wait for cCLK_PER;

    wait;
  end process;
  
end behavior;
