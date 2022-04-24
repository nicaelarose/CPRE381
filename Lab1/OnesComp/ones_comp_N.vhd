-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- ones_comp_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a ones complementor
--that will negate each bit given in the single input

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ones_comp_N is
  generic(N : integer := 32); 
  port(i_D          : in  std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end ones_comp_N;

architecture structural of ones_comp_N is

  component invg
    port(i_A        : in std_logic;
         o_F        : out std_logic);
  end component;

begin
  -- Instantiate N mux instances.
  G_NBit_ONES_COMP: for i in 0 to N-1 generate
    NEG: invg port map(
              i_A   => i_D(i),   
              o_F   => o_O(i));  
  end generate G_NBit_ONES_COMP;
  
end structural;
