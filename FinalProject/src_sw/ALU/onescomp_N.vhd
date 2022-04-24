library IEEE;
use IEEE.std_logic_1164.all;

entity onescomp_N is
	generic(N : integer := 32);
	port(
		i_A	: in std_logic_vector(N-1 downto 0);
		o_F	: out std_logic_vector(N-1 downto 0)
	);
end onescomp_N;

architecture structural of onescomp_N is

	component invg is
		port(
			i_A	: in std_logic;
			o_F	: out std_logic
		);
	end component;

begin
	G_NBit_OnesComp: for i in 0 to N-1 generate
		OnesCompI: invg port map(
			i_A	=> i_A(i),
			o_F	=> o_F(i)
		);
	end generate G_NBit_OnesComp;
end structural;
