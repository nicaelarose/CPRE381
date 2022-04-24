-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_full_adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the fuller adder
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  
library std;
use std.env.all;              
use std.textio.all;            

entity tb_full_adder_N is
  generic(gCLK_HPER   : time := 10 ns); 
end tb_full_adder_N;

architecture mixed of tb_full_adder_N is

constant cCLK_PER  : time := gCLK_HPER * 2;

component full_adder_N is
  port(i_vC          :  in std_logic;
       i_vA          :  in std_logic_vector(31 downto 0);
       i_vB          :  in std_logic_vector(31 downto 0);
       o_vS          : out std_logic_vector(31 downto 0);
       o_vC          : out std_logic);
end component;

signal CLK, reset : std_logic := '0';


signal s_iC  : std_logic;
signal s_iA  : std_logic_vector(31 downto 0);
signal s_iB  : std_logic_vector(31 downto 0);
signal s_oS  : std_logic_vector(31 downto 0);
signal s_oC  : std_logic;

begin

  DUT0: full_adder_N
  port map( i_vC     => s_iC,
            i_vA     => s_iA,
            i_vB     => s_iB,
	    o_vS     => s_oS,
	    o_vC     => s_oC);

 
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

    -- Test Case 1: 
    s_iA <= "00000000000000000000000000000000";
    s_iB <= "00000000000000000000000000000001";
    s_iC <= '1';
    wait for gCLK_HPER*2;

    -- Test case 2:
    -- Perform a addition to create overflow and have carry equal to 1
    s_iA       <= "00000000000000000000000001100000";
    s_iB       <= "00000000000000000000000000111100";
    s_iC <= '0';
    wait for gCLK_HPER*2;

    -- Test Case 3:
    -- Perform an addition to make the sum 0 with out adding zero plus zero.
    s_iA <= "11111111111111111111111111111111";
    s_iB <= "00000000000000000000000000000000";
    s_iC <= '1';
    wait for gCLK_HPER*2;


  end process;

end mixed;
