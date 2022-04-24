-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2:1 MUX.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port(i_D0		: in std_logic;
       i_D1		: in std_logic;
       o_O		: out std_logic;
       i_S		: in std_logic);

end mux2t1;

architecture structural of mux2t1 is
begin

	o_O <= ((not i_S AND i_D0) OR (i_S AND i_D1)); 

end structural;

