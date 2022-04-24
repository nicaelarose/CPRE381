library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder is
	port(
		i_Cin	: in std_logic;
		i_A	: in std_logic;
		i_B	: in std_logic;
		o_Cout	: out std_logic;
		o_S	: out std_logic
	);
end fulladder;

architecture structural of fulladder is
       	
       	component org2 is
       		port(
       			i_A	: in std_logic;
       			i_B	: in std_logic;
       			o_F	: out std_logic
       		);
       	end component;
       	
       	component halfadder is
       		port(
			i_A	: in std_logic;
			i_B	: in std_logic;
			o_C	: out std_logic;
			o_S	: out std_logic
		);
	end component;
	
	-- signal to carry the sum bit from the first half-adder
	signal s_S0 : std_logic;
	
	-- signal to carry the carry bit from the first half-adder
	signal s_C0 : std_logic;
	
	-- signal to carry the carry bit from the 2nd half-adder
	signal s_C1 : std_logic;
       	
begin
	
	g_HA0: halfadder
		port MAP(
			i_A 	=> i_A,
			i_B	=> i_B,
			o_C	=> s_C0,
			o_S	=> s_S0
		);
		
	g_HA1: halfadder
		port MAP(
			i_A	=> i_Cin,
			i_B	=> s_S0,
			o_C	=> s_C1,
			o_S	=> o_S
		);
		
	g_COR: org2
		port MAP(
			i_A	=> s_C0,
			i_B	=> s_C1,
			o_F	=> o_Cout
		);
		
end structural;
