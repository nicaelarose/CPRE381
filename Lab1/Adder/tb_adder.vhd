-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a full adder

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  
library std;
use std.env.all;              
use std.textio.all;           

entity tb_adder is
  generic(gCLK_HPER   : time := 10 ns);   
end tb_adder;

architecture mixed of tb_adder is


constant cCLK_PER  : time := gCLK_HPER * 2;

component full_adder is
  port(i_C          : in  std_logic;
       i_A          : in  std_logic;
       i_B          : in  std_logic;
       o_S          : out std_logic;
       o_C          : out std_logic);
end component;

signal CLK, reset : std_logic := '0';


signal s_iC  : std_logic;
signal s_iA  : std_logic;
signal s_iB  : std_logic;
signal s_oS  : std_logic;
signal s_oC  : std_logic;

begin

  DUT0: full_adder
  port map( i_C     => s_iC,
            i_A     => s_iA,
	    i_B     => s_iB,
            o_S     => s_oS,
            o_C     => s_oC);

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

    -- Test case 1:
    s_iA <= '0';
    s_iB <= '0';
    wait for gCLK_HPER*2;

    -- Test case 2:
    -- Perform average example of an input activation of 3 and a partial sum of 25. The weight is still 10. 
    s_iA <= '0';
    s_iB <= '1';
    wait for gCLK_HPER*2;

    -- Test Case 3:
    s_iA <= '1';
    s_iB <= '0';
    wait for gCLK_HPER*2;

    -- Test Case 4:
    s_iA <= '1';
    s_iB <= '1';
    s_iC <= '1';
    wait for gCLK_HPER*2;

  end process;

end mixed;
