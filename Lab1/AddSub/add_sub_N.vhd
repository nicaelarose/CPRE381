-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- add_sub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit adder-subtractor
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity add_sub_N is
  generic(N : integer := 32); 
  port( i_C         :  in std_logic;
        i_nAdd_Sub  :  in std_logic;
        i_A         :  in std_logic_vector(N-1 downto 0);
        i_B         :  in std_logic_vector(N-1 downto 0);
        o_S         : out std_logic_vector(N-1 downto 0);
        o_C         : out std_logic);

end add_sub_N;

architecture structural of add_sub_N is

  component full_adder_N
    port(i_vC        :  in std_logic;
         i_vA        :  in std_logic_vector(N-1 downto 0);
         i_vB        :  in std_logic_vector(N-1 downto 0);
         o_vS        : out std_logic_vector(N-1 downto 0);
         o_vC        : out std_logic);
  end component;

  component ones_comp_N 
    port(i_D         : in  std_logic_vector(N-1 downto 0);
         o_O         : out std_logic_vector(N-1 downto 0));
  end component;

  component mux2t1_N
    port(i_S         : in  std_logic;
         i_D0        : in  std_logic_vector(N-1 downto 0);
         i_D1        : in  std_logic_vector(N-1 downto 0);
         o_OA        : out std_logic_vector(N-1 downto 0));
  end component;

  signal s_inv_iB : std_logic_vector(N-1 downto 0);
  signal s_mux_oD : std_logic_vector(N-1 downto 0);
  signal s_oC     : std_logic;

begin


 g_Invert: ones_comp_N
    port MAP(i_D   =>  i_B,
             o_O   =>  s_inv_iB);

 -- The N-Bit 2:1 Mux
 g_Mux: mux2t1_N
   port MAP(i_S   =>  i_nAdd_Sub,
            i_D0  =>  i_B,
            i_D1  =>  s_inv_iB,
            o_OA  =>  s_mux_oD);

 -- The N-Bit Adder
 g_Adder: full_adder_N
  port MAP(i_vC  =>  i_nAdd_Sub,
           i_vA  =>  i_A,
           i_vB  =>  s_mux_oD,
           o_vS  =>  o_S,
           o_vC  =>  s_oC);

 o_C <= NOT i_nAdd_Sub AND s_oC;
  
end structural;
