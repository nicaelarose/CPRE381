library IEEE;
use IEEE.std_logic_1164.all;

entity halfadder is
	port(
		i_A	: in std_logic;
		i_B	: in std_logic;
		o_C	: out std_logic;
		o_S	: out std_logic
	);
end halfadder;

architecture structural of halfadder is

	component andg2 is
		port(
			i_A	: in std_logic;
       			i_B	: in std_logic;
       			o_F	: out std_logic
       		);
       	end component;
       	
       	component xorg2 is
       		port(
       			i_A	: in std_logic;
       			i_B	: in std_logic;
       			o_F	: out std_logic
       		);
       	end component;
       	
begin
	
	g_xor: xorg2
		port MAP(
			i_A	=> i_A,
			i_B	=> i_B,
			o_F	=> o_S
		);
	
	g_and: andg2
		port MAP(
			i_A	=> i_A,
			i_B	=> i_B,
			o_F	=> o_C
		);
end structural;
