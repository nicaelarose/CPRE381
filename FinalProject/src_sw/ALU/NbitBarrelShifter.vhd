library IEEE;
use IEEE.std_logic_1164.all;

entity NbitBarrelShifter is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_Shift     : in std_logic_vector(4 downto 0);
       i_S         : in std_logic_vector(1 downto 0);--bit 0 is right or left, bit 1 is signed or unsigned
       i_In        : in std_logic_vector(31 downto 0);
       o_O         : out std_logic_vector(31 downto 0));

end NbitBarrelShifter;

architecture structural of NbitBarrelShifter is

  component mux4t1 is
    port(i_S             : in std_logic_vector(1 downto 0);
         i_D0            : in std_logic;
         i_D1            : in std_logic;
         i_D2            : in std_logic;
         i_D3            : in std_logic;
         o_O             : out std_logic);
  end component;

  component mux2t1_32 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  signal s_In        : std_logic_vector(N-1 downto 0);
  signal s_C, s_C1, s_C2, s_C3, s_C4         : std_logic_vector(N-1 downto 0);
  signal s_CO, S_CO1, s_CO2, s_CO3, s_CO4    : std_logic_vector(N-1 downto 0);
  signal s_S         : std_logic_vector(1 downto 0);
  signal s_shift     : integer;

  begin

  s_In <= i_In;

  s_S <= "10" when (i_In(31) = '0' AND i_S = "00") else
         i_S;
  
  G_NBit_BarrelShifter11: for i in 31 to 31 generate
    MUXI: mux4t1 port map(
              i_S       => s_S,
              i_D0      => '1',
              i_D1      => s_In(i-1),
	      i_D2      => '0',
              i_D3      => s_In(i-1),
              o_O       => s_C(i));
  end generate G_NBit_BarrelShifter11;

  G_NBit_BarrelShifter12: for i in 1 to 30 generate
    MUXI1: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_In(i+1),
              i_D1      => s_In(i-1),
	      i_D2      => s_In(i+1),
              i_D3      => s_In(i-1),
              o_O       => s_C(i));
  end generate G_NBit_BarrelShifter12;

  G_NBit_BarrelShifter13: for i in 0 to 0 generate
    MUXI2: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_In(i+1),
              i_D1      => '0',
	      i_D2      => s_In(i+1),
              i_D3      => '0',
              o_O       => s_C(i));
  end generate G_NBit_BarrelShifter13;
  
  Mux1: mux2t1_32
  port MAP(i_S             => i_Shift(0),
           i_D0            => i_In,
           i_D1            => s_C,
           o_O             => s_CO);

  G_NBit_BarrelShifter21: for i in 30 to 31 generate
    MUXI: mux4t1 port map(
              i_S       => s_S,
              i_D0      => '1',
              i_D1      => s_CO(i-2),
	      i_D2      => '0',
              i_D3      => s_CO(i-2),
              o_O       => s_C1(i));
  end generate G_NBit_BarrelShifter21;

  G_NBit_BarrelShifter22: for i in 2 to 29 generate
    MUXI1: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_CO(i+2),
              i_D1      => s_CO(i-2),
	      i_D2      => s_CO(i+2),
              i_D3      => s_CO(i-2),
              o_O       => s_C1(i));
  end generate G_NBit_BarrelShifter22;

  G_NBit_BarrelShifter23: for i in 0 to 1 generate
    MUXI2: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_CO(i+2),
              i_D1      => '0',
	      i_D2      => s_CO(i+2),
              i_D3      => '0',
              o_O       => s_C1(i));
  end generate G_NBit_BarrelShifter23;
  
  Mux2: mux2t1_32
  port MAP(i_S             => i_Shift(1),
           i_D0            => s_CO,
           i_D1            => s_C1,
           o_O             => s_CO1);

  G_NBit_BarrelShifter31: for i in 28 to 31 generate
    MUXI: mux4t1 port map(
              i_S       => s_S,
              i_D0      => '1',
              i_D1      => s_CO1(i-4),
	      i_D2      => '0',
              i_D3      => s_CO1(i-4),
              o_O       => s_C2(i));
  end generate G_NBit_BarrelShifter31;

  G_NBit_BarrelShifter32: for i in 4 to 27 generate
    MUXI1: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_CO1(i+4),
              i_D1      => s_CO1(i-4),
	      i_D2      => s_CO1(i+4),
              i_D3      => s_CO1(i-4),
              o_O       => s_C2(i));
  end generate G_NBit_BarrelShifter32;

  G_NBit_BarrelShifter33: for i in 0 to 3 generate
    MUXI2: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_CO1(i+4),
              i_D1      => '0',
	      i_D2      => s_CO1(i+4),
              i_D3      => '0',
              o_O       => s_C2(i));
  end generate G_NBit_BarrelShifter33;
  
  Mux3: mux2t1_32
  port MAP(i_S             => i_Shift(2),
           i_D0            => s_CO1,
           i_D1            => s_C2,
           o_O             => s_CO2);

  G_NBit_BarrelShifter41: for i in 24 to 31 generate
    MUXI: mux4t1 port map(
              i_S       => s_S,
              i_D0      => '1',
              i_D1      => s_CO2(i-8),
	      i_D2      => '0',
              i_D3      => s_CO2(i-8),
              o_O       => s_C3(i));
  end generate G_NBit_BarrelShifter41;

  G_NBit_BarrelShifter42: for i in 8 to 23 generate
    MUXI1: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_CO2(i+8),
              i_D1      => s_CO2(i-8),
	      i_D2      => s_CO2(i+8),
              i_D3      => s_CO2(i-8),
              o_O       => s_C3(i));
  end generate G_NBit_BarrelShifter42;

  G_NBit_BarrelShifter43: for i in 0 to 7 generate
    MUXI2: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_CO2(i+8),
              i_D1      => '0',
	      i_D2      => s_CO2(i+8),
              i_D3      => '0',
              o_O       => s_C3(i));
  end generate G_NBit_BarrelShifter43;
  
  Mux4: mux2t1_32
  port MAP(i_S             => i_Shift(3),
           i_D0            => s_CO2,
           i_D1            => s_C3,
           o_O             => s_CO3);

  G_NBit_BarrelShifter51: for i in 16 to 31 generate
    MUXI: mux4t1 port map(
              i_S       => s_S,
              i_D0      => '1',
              i_D1      => s_CO3(i-16),
	      i_D2      => '0',
              i_D3      => s_CO3(i-16),
              o_O       => s_C4(i));
  end generate G_NBit_BarrelShifter51;

  G_NBit_BarrelShifter52: for i in 0 to 15 generate
    MUXI2: mux4t1 port map(
              i_S       => s_S,
              i_D0      => s_CO3(i+16),
              i_D1      => '0',
	      i_D2      => s_CO3(i+16),
              i_D3      => '0',
              o_O       => s_C4(i));
  end generate G_NBit_BarrelShifter52;
  
  Mux5: mux2t1_32
  port MAP(i_S             => i_Shift(4),
           i_D0            => s_CO3,
           i_D1            => s_C4,
           o_O             => s_CO4);

  o_O <= s_CO4;
  
end structural;
