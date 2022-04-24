library IEEE;
use IEEE.std_logic_1164.all;

entity AdderSubtractor is
    generic(N: integer := 32);
    port(
        i_A     :   in std_logic_vector(N-1 downto 0);
        i_B     :   in std_logic_vector(N-1 downto 0);
        i_Sub   :   in std_logic;
        o_S     :   out std_logic_vector(N-1 downto 0);
        o_Cout  :   out std_logic;
		o_Ovfl	:	out std_logic
    );
end AdderSubtractor;

architecture structural of AdderSubtractor is

    component Adder is
		port(
			i_A	: in std_logic_vector(N-1 downto 0);
			i_B	: in std_logic_vector(N-1 downto 0);
			i_Cin	: in std_logic;
			o_S	: out std_logic_vector(N-1 downto 0);
			o_Cout	: out std_logic;
			o_Ovfl	:	out std_logic
		);
	end component;
	
	component onescomp_N is
		port(
			i_A	: in std_logic_vector(N-1 downto 0);
			o_F	: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component mux2t1_32 is
		port(
			i_S          : in std_logic;
			i_D0         : in std_logic_vector(N-1 downto 0);
			i_D1         : in std_logic_vector(N-1 downto 0);
			o_O          : out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	-- signal to hold not B
	signal s_NB : std_logic_vector(N-1 downto 0);
	
	-- signal to hold the output of the mux
	signal s_BMux : std_logic_vector(N-1 downto 0);
	
begin

	g_InvB: onescomp_N
		port map(
			i_A	=> i_B,
			o_F	=> s_NB
		);
	
	g_MuxB: mux2t1_32
		port map(
			i_S	=> i_Sub,
			i_D0	=> i_B,
			i_D1	=> s_NB,
			o_O	=> s_BMux
		);
		
	g_Adder: Adder
		port map(
			i_A	=> i_A,
			i_B	=> s_BMux,
			i_Cin	=> i_Sub,
			o_S 	=> o_S,
			o_Cout	=> o_Cout,
			o_Ovfl	=> o_Ovfl
		);
		
end structural;
