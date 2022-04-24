library IEEE;
use IEEE.std_logic_1164.all;

entity OrG_N is
    generic(N: integer := 32);
    port(
        i_A     :   in std_logic_vector(N-1 downto 0);
        i_B     :   in std_logic_vector(N-1 downto 0);
        o_Out   :   out std_logic_vector(N-1 downto 0)
    );
end OrG_N;

architecture structural of OrG_N is

    component org2 is
        port(i_A          : in std_logic;
            i_B          : in std_logic;
            o_F          : out std_logic);
    end component;

begin

    G_NBit_Or: for i in 0 to N-1 generate
        Or_I: org2 port map(
            i_A     =>  i_A(i),
            i_B     =>  i_B(i),
            o_F     =>  o_Out(i)
        );
    end generate G_NBit_Or;

end structural;