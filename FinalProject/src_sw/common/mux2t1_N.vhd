-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

-- Modified to have a 5-bit version and a 32-bit version

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_5 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(4 downto 0);
       i_D1         : in std_logic_vector(4 downto 0);
       o_O          : out std_logic_vector(4 downto 0));

end mux2t1_5;

architecture structural of mux2t1_5 is

  component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_MUX: for i in 0 to 4 generate
    MUXI: mux2t1 port map(
              i_S      => i_S,      -- All instances share the same select input.
              i_D0     => i_D0(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => i_D1(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX;
  
end structural;

-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_32 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(31 downto 0);
       i_D1         : in std_logic_vector(31 downto 0);
       o_O          : out std_logic_vector(31 downto 0));

end mux2t1_32;

architecture structural of mux2t1_32 is

  component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;

begin

  -- Instantiate N mux instances.
  G_NBit_MUX: for i in 0 to 31 generate
    MUXI: mux2t1 port map(
              i_S      => i_S,      -- All instances share the same select input.
              i_D0     => i_D0(i),  -- ith instance's data 0 input hooked up to ith data 0 input.
              i_D1     => i_D1(i),  -- ith instance's data 1 input hooked up to ith data 1 input.
              o_O      => o_O(i));  -- ith instance's data output hooked up to ith data output.
  end generate G_NBit_MUX;
  
end structural;