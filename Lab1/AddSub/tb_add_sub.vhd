-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_add_sub.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the adder-subtractor 
--unit with n_bits
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all; 
library std;
use std.env.all;               
use std.textio.all;           


entity tb_add_sub_N is
  generic(gCLK_HPER   : time := 10 ns);  
end tb_add_sub_N;

architecture mixed of tb_add_sub_N is


constant cCLK_PER  : time := gCLK_HPER * 2;

component add_sub_N is
  port(i_C          :  in std_logic;
       i_nAdd_Sub   :  in std_logic;
       i_A          :  in std_logic_vector(31 downto 0);
       i_B          :  in std_logic_vector(31 downto 0);
       o_S          : out std_logic_vector(31 downto 0);
       o_C          : out std_logic);
end component;


signal CLK, reset : std_logic := '0';


signal s_iC        : std_logic;
signal s_nAdd_Sub : std_logic;
signal s_iA        : std_logic_vector(31 downto 0);
signal s_iB        : std_logic_vector(31 downto 0);
signal s_oS        : std_logic_vector(31 downto 0);
signal s_oC        : std_logic;

begin

  DUT0: add_sub_N
  port map( i_C        => s_iC,
            i_nAdd_Sub => s_nAdd_Sub,
            i_A        => s_iA,
            i_B        => s_iB,
	    o_S        => s_oS,
	    o_C        => s_oC);

  

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
    -- Performs a simple addition 7+4 = 11 (0xB) 
    s_iA <= "00000000000000000000000000000111";
    s_iB <= "00000000000000000000000000000100";
    s_iC <= '0';
    s_nAdd_Sub <= '0';
    wait for gCLK_HPER*2;
 

    -- Test case 2:
    -- Perform a simple subtraction 100 - 60 = 40 (0x28)
    s_iA       <= "00000000000000000000000001100100";
    s_iB       <= "00000000000000000000000000111100";
    s_iC       <= '0';
    s_nAdd_Sub <= '1';
    wait for gCLK_HPER*2;

    -- Test Case 3:
    -- Perform an addition to set an overflow meaning after adding oC should be 1. Adding an enormous number so I am not going to convert to decimal
    s_iA <= "11111111111111111111111111110000";
    s_iB <= "00000000000000000000000000011111";
    s_iC <= '1';
    s_nAdd_Sub <= '0';
    wait for gCLK_HPER*2;


    -- Test Case 4:
    -- Perform an subtraction to set the value under 0, subtracting 4 - 7 = -3 or an enormous number
    s_iA <= "00000000000000000000000000000100";
    s_iB <= "00000000000000000000000000000111";
    s_iC <= '0';
    s_nAdd_Sub <= '1'
    wait for gCLK_HPER*2;
   
  end process;

end mixed;
