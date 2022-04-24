library IEEE;
use IEEE.std_logic_1164.all;

entity Adder is
	generic(N : integer := 32);
	port(
		i_A	: in std_logic_vector(N-1 downto 0);
		i_B	: in std_logic_vector(N-1 downto 0);
		i_Cin	: in std_logic;
		o_S	: out std_logic_vector(N-1 downto 0);
		o_Cout	: out std_logic;
		o_Ovfl	: out std_logic
	);
end Adder;

architecture structural of Adder is

	component fulladder is
		port(
			i_Cin	: in std_logic;
			i_A	: in std_logic;
			i_B	: in std_logic;
			o_Cout	: out std_logic;
			o_S	: out std_logic
		);
	end component;
	
	
	signal s_carry : std_logic_vector(N-1 downto 0);
	
begin

	G_NBit_Adder: for i in 1 to N-2 generate
		Adder_0: fulladder port map(
			i_Cin	=> i_Cin,
			i_A	=> i_A(0),
			i_B	=> i_B(0),
			o_Cout	=> s_carry(0),
			o_S	=> o_S(0)
		);
		
		Adder_I: fulladder port map(
			i_Cin	=> s_carry(i-1),
			i_A 	=> i_A(i),
			i_B	=> i_B(i),
			o_Cout	=> s_carry(i),
			o_S	=> o_S(i)
		);
		
		Adder_1: fulladder port map(
			i_Cin	=> s_carry(N-2),
			i_A	=> i_A(N-1),
			i_B	=> i_B(N-1),
			o_Cout	=> s_carry(N-1),
			o_S	=> o_S(N-1)
		);
	end generate G_NBit_Adder;

	o_Cout <= s_carry(N-1);
	o_Ovfl <= s_carry(N-1) xor s_carry(N-2);
		
end structural;
