-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_mux2t1_dataflow.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the MUX 2:1 unit
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;
library std;
use std.env.all;
use std.textio.all;

entity tb_mux2t1 is
  generic(gCLK_HPER	: time := 10 ns);
end tb_mux2t1;

architecture mixed of tb_mux2t1 os

constant cCLK_HPER	: time := gCLK_HPER * 2;

component mux2t1_dataflow is
  port(iCLK	: in std_logic;
       i_S	: in std_logic;
       i_D0	: in std_logic;
       i_D1	: in std_logic;
       o_O	: out std_logic);
end component;

signal CLK, reset : std_logic := '0';

signal s_iX : std_logic;
signal s_iY : std_logic;
signal s_oXY : std_logic;
signal s_S : std_logic;

begin


DUT0: mux2t1_dataflow
port map(
	iCLK	=> CLK,
	i_D0	=> s_iX,
	i_D1	=> s_iY,
	i_S	=> s_S,
	o_O	=> s_oXY);

P_CLK: process
begin
  CLK <= '1';
  wait for gCLK_HPER;
  CLK <= '0';
  wait for gCLK_HPER;
end process;

P_RST: process
begin
    reset <= '0';
  wait for gCLK_HPER/2;
    reset <= '1';
  wait for gCLK_HPER*2;
    reset <= '0';
    wait;
end process;


  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; 

    s_S    <= '1';  -- Should output s_iY so s_oXY should be 1
    s_iX   <= '0';  
    s_iY   <= '1';  
    wait for gCLK_HPER*2;


    -- Test case 2:
    -- Perform average example of an input activation of 3 and a partial sum of 25. The weight is still 10. 
    s_S    <= '0';  
    s_iX   <= '0';  
    s_iY   <= '1';  
    wait for gCLK_HPER*2;

    -- Test Case 3:
    s_S    <= '0';  
    s_iX   <= '1';  
    s_iY   <= '1';  
    wait for gCLK_HPER*2;

  end process;

end mixed;











