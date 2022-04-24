-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_extender.vhd
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

entity tb_extender is
  generic(gCLK_HPER   : time := 50 ns);
end tb_extender;

architecture behavior of tb_extender is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component extender
    port(i_I        : in std_logic_vector(15 downto 0);     -- Data value input
	   i_C			: in std_logic; --0 for zero, 1 for signextension
       o_O          : out std_logic_vector(31 downto 0));   -- Data value output
end component;

  -- Temporary signals to connect to the dff component.
  signal s_C, s_clk	: std_logic;
  signal s_I : std_logic_vector(15 downto 0);
  signal s_O : std_logic_vector(31 downto 0);
begin
	DUT: extender
	port map(s_I, s_C, s_O);

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
  
	P_TB: process
	begin

	s_I <= x"0000";
	s_C <= '0';
	wait for cCLK_PER; -- Zero Extend to x00000000
	
	s_I <= x"0000";
	s_C <= '1';
	wait for cCLK_PER; -- Sign Extend to x00000000
	
	s_I <= x"FFFF";
	s_C <= '0';
	wait for cCLK_PER; -- Zero Extend to x0000FFFF
	
	s_I <= x"FFFF";
	s_C <= '1';
	wait for cCLK_PER; -- Sign Extend to xFFFFFFFF
	
	s_I <= x"7FFF";
	s_C <= '1';
	wait for cCLK_PER; -- Sign Extend to x00007FFF
	
	s_I <= x"8000";
	s_C <= '1';
	wait for cCLK_PER; -- Sign Extend to xFFFF8000
	
    wait;
  end process;
  
end behavior;
