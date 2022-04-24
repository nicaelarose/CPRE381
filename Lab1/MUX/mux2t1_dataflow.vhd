-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_dataflow.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 1-bit wide 2:1
-- MUX using structural VHDL, generics, and generate statements
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_dataflow is
 
  port(iCLK	: in std_logic;
       i_S	: in std_logic;
       i_D0	: in std_logic;
       i_D1	: in std_logic;
       o_O	: out std_logic);

end mux2t1_dataflow;

architecture dataflow of mux2t1_dataflow is

begin
  o_O <= i_D0 when (i_S = '0') else
         i_D1;

end dataflow;
  

