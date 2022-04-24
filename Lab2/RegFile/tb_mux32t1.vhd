-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_mux32t1.vhd
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

use work.mypack.all;

entity tb_mux32t1 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_mux32t1;

architecture behavior of tb_mux32t1 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component mux32t1
     port(i_I          : in TwoDArray;     -- Data value input
		i_S			: in std_logic_vector(4 downto 0);
		o_O         : out std_logic_vector(31 downto 0));   -- Data value output
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic;
  signal s_I : TwoDArray;
  signal s_S : std_logic_vector(4 downto 0);
  signal s_O : std_logic_vector(31 downto 0);


begin

  DUT: mux32t1
  port map(s_I, s_S, s_O);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  P_INIT: process
  begin 
	for i in 0 to 31 loop
		s_I(i) <= x"00000000";
	end loop;
	wait for cCLK_PER * 4;
	for i in 0 to 10 loop
		s_I(i) <= x"00000000";
	end loop;
	for i in 10 to 20 loop
		s_I(i) <= x"0000FFFF";
	end loop;
	for i in 20 to 31 loop
		s_I(i) <= x"FFFFFFFF";
	end loop;
	wait;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    -- Test Case 1, 9
    s_S <= "00001";
    wait for cCLK_PER; -- should be "0x00000000" --(Both times)
	
	 -- Test Case 2, 10
    s_S <= "00100";
    wait for cCLK_PER; -- should be "0x00000000" --(Both times)
	
	 -- Test Case 3, 11
    s_S <= "00011";
    wait for cCLK_PER; -- should be "0x00000000" --(Both times)
	
	 -- Test Case 4, 12
    s_S <= "11111";
    wait for cCLK_PER; -- should be "0x00000000" --0x0000FFFF on 2nd time and on
	
	--s_I changes to 2nd set of inputs, 0x00 for reg 0-10, 
	--0xFFFF for 11-20, 0xFFFFFFFF 21-31
	
	-- Test Case 5
	s_S <= "10010";
    wait for cCLK_PER; -- should be "0x0000FFFF"
	
	 -- Test Case 6
    s_S <= "00101";
    wait for cCLK_PER; -- should be "0x00000000"
	
	 -- Test Case 7
    s_S <= "01111";
    wait for cCLK_PER; -- should be "0x0000FFFF"
	
	 -- Test Case 8
    s_S <= "11111";
    wait for cCLK_PER; -- should be "0xFFFFFFFF"
  end process;
  

  

  
end behavior;
