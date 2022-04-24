-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_decoder_n.vhd
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

entity tb_decoder5t32 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_decoder5t32;

architecture behavior of tb_decoder5t32 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component decoder5t32
     port(i_I          : in std_logic_vector(4 downto 0);     -- Data value input
       o_O          : out std_logic_vector(31 downto 0));   -- Data value output
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_I : std_logic_vector(4 downto 0);
  signal s_O : std_logic_vector(31 downto 0);
  signal s_CLK : std_logic;

begin

  DUT: decoder5t32
  port map(s_I, s_O);

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
  
  -- Testbench process  
  P_TB: process
  begin
    -- Test Case 1
    s_I <= "00001";
    wait for cCLK_PER; -- should be "00000000000000000000000000000010"
	
	 -- Test Case 2
    s_I <= "00100";
    wait for cCLK_PER; -- should be "00000000000000000000000000010000"
	
	 -- Test Case 3
    s_I <= "00011";
    wait for cCLK_PER; -- should be "00000000000000000000000000001000"
	
	 -- Test Case 4
    s_I <= "11111";
    wait for cCLK_PER; -- should be "10000000000000000000000000000000"

    wait;
  end process;
  
end behavior;
