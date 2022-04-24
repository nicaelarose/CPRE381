library IEEE;
use IEEE.std_logic_1164.all;

entity mem_wb_reg is
    port(
        i_clk:          in std_logic;
        i_rst:          in std_logic;

        i_JAL:          in std_logic;
        i_MemtoReg:     in std_logic;
        i_RegWrite:     in std_logic;

        i_MemReadData:  in std_logic_vector(31 downto 0);
        i_ALUResult:    in std_logic_vector(31 downto 0);
        i_Instr:        in std_logic_vector(31 downto 0);
        
        o_JAL:          out std_logic;
        o_MemtoReg:     out std_logic;
        o_RegWrite:     out std_logic;

        o_MemReadData:  out std_logic_vector(31 downto 0);
        o_ALUResult:    out std_logic_vector(31 downto 0);
        o_Instr:        out std_logic_vector(31 downto 0)
    );
end mem_wb_reg;

architecture structure of mem_wb_reg is

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
    signal s_RegControlUnused:  std_logic_vector(28 downto 0);

begin

    g_ClkInv: invg
        port map(
            i_A =>  i_clk,
            o_F =>  s_InvClk
        );

    g_RegControl: reg
        port map(
            i_D(0)              =>  i_JAL,
            i_D(1)              =>  i_MemtoReg,
            i_D(2)              =>  i_RegWrite,
            i_D(31 downto 3)    =>  '0' & x"0000000",

            i_WE                =>  s_InvClk,
            i_CLK               =>  i_clk,
            i_RST               =>  i_rst,

            o_Q(0)              =>  o_JAL,
            o_Q(1)              =>  o_MemtoReg,
            o_Q(2)              =>  o_RegWrite,
            o_Q(31 downto 3)    =>  s_RegControlUnused
        );

    g_RegALUResult: reg
        port map(
            i_D     =>  i_ALUResult,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_ALUResult
        );

    g_RegMemReadData: reg
        port map(
            i_D     =>  i_MemReadData,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_MemReadData
        );

    g_RegInstr: reg
        port map(
            i_D     =>  i_Instr,

            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            
            o_Q     =>  o_Instr
        );

end structure;
    
