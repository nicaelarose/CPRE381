library IEEE;
use IEEE.std_logic_1164.all;

entity if_id_reg is
    port(
        i_clk:  in std_logic;
        i_rst:  in std_logic;
        i_PC:   in std_logic_vector(31 downto 0);
        i_IM:   in std_logic_vector(31 downto 0);
        o_PC:   out std_logic_vector(31 downto 0);
        o_IM:   out std_logic_vector(31 downto 0)
    );
end if_id_reg;

architecture structure of if_id_reg is

    component reg is
        generic(N : integer := 32);
        port(
            i_D   : in std_logic_vector(N - 1 downto 0);   -- Data input
            i_WE  : in std_logic; -- Write enable input
            i_CLK : in std_logic; -- Clock input
            i_RST : in std_logic; -- Reset input
            o_Q   : out std_logic_vector(N - 1 downto 0)    -- Data output
        );
    end component;

    component invg is
        port(i_A          : in std_logic;
             o_F          : out std_logic);
    end component;

    signal s_InvClk:    std_logic; -- inverted clock signal to read on clock
                                   -- high and write on clock low

begin

    g_ClkInv: invg
        port map(
            i_A =>  i_clk,
            o_F =>  s_InvClk
        );

    g_RegPCPlus4: reg
        port map(
            i_D     =>  i_PC,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_PC
        );

    g_RegIM: reg
        port map(
            i_D     =>  i_IM,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_IM
        );

end structure;
    