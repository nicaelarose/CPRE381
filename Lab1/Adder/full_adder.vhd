-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- full_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a full adder
--that adds each bit and outputs the sum and shows if there is a carry bit
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
  port(i_C          : in  std_logic;
       i_A          : in  std_logic;
       i_B          : in  std_logic;
       o_S          : out std_logic;
       o_C          : out std_logic);

end full_adder;

architecture structural of full_adder is

begin
   o_S <= (NOT i_C AND (i_A XOR i_B)) OR (i_C AND (i_A XNOR i_B));
   o_C <= (NOT i_C AND (i_A AND i_B)) OR (i_C AND (i_A OR i_B));
  
end structural;

