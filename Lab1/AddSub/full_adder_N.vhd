-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- full_adder_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
--MUX using structural VHDL, generics, and generate statements
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_N is
  generic(N : integer := 32); 
  port( i_vC         :  in std_logic;
        i_vA         :  in std_logic_vector(N-1 downto 0);
        i_vB         :  in std_logic_vector(N-1 downto 0);
        o_vS         : out std_logic_vector(N-1 downto 0);
        o_vC         : out std_logic);

end full_adder_N;

architecture structural of full_adder_N is

  component full_adder is
    port(i_C                  :  in std_logic;
         i_A                  :  in std_logic;
         i_B                  :  in std_logic;
         o_S                  : out std_logic;
         o_C                  : out std_logic);
  end component;

  signal t_C : std_logic_vector(N downto 0);

begin

  t_C(0) <= i_vC;
  o_vC   <= t_C(N);

  -- Instantiate N full_adder instances.
  G_NBit_ADDER: for i in 0 to N-1 generate
    ADDER: full_adder port map(
              i_C       => t_C(i),
              i_A       => i_vA(i), 
              i_B       => i_vB(i), 
              o_S       => o_vS(i), 
              o_C       => t_C(i+1));  
  
  end generate G_NBit_ADDER;    
  
end structural;
