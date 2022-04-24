library IEEE;
use IEEE.std_logic_1164.all;

entity reg is

    generic(N : integer := 32);
    port(
        i_D   : in std_logic_vector(N - 1 downto 0);   -- Data input
        i_WE  : in std_logic; -- Write enable input
        i_CLK : in std_logic; -- Clock input
        i_RST : in std_logic; -- Reset input
        o_Q   : out std_logic_vector(N - 1 downto 0)    -- Data output
    );

end reg;

architecture structural of reg is

    component dffg is
        port(i_CLK        : in std_logic;     -- Clock input
       	    i_RST        : in std_logic;     -- Reset input
            i_WE         : in std_logic;     -- Write enable input
            i_D          : in std_logic;     -- Data value input
            o_Q          : out std_logic);   -- Data value output
    end component;

begin

    G_NBit_dff: for i in 0 to N-1 generate
    	dff_N: dffg port map(
            i_D		=>	i_D(i),
            i_RST	=>	i_RST,
            i_CLK	=>	i_CLK,
            i_WE	=>	i_WE,
            o_Q		=>	o_Q(i)
        );
    end generate G_NBit_dff;
    
end structural;
