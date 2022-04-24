library IEEE;
use IEEE.std_logic_1164.all;

entity id_ex_reg is
    port(
        i_clk:          in std_logic;
        i_rst:          in std_logic;

        i_RegDst:       in std_logic_vector(1 downto 0);
        i_JumpReg:      in std_logic;
        i_JAL:          in std_logic;
        i_Jump:         in std_logic;
        i_Branch:       in std_logic;
        i_MemRead:      in std_logic;
        i_MemtoReg:     in std_logic;
        i_ALUOp:        in std_logic_vector(6 downto 0);
        i_MemWrite:     in std_logic;
        i_ALUSrc:       in std_logic_vector(1 downto 0);
        i_RegWrite:     in std_logic;

        i_RFD1:         in std_logic_vector(31 downto 0);   -- RegFile Data1
        i_RFD2:         in std_logic_vector(31 downto 0);   -- RegFile Data2
        i_SignExtImmed: in std_logic_vector(31 downto 0);
        i_SignExtREPL:  in std_logic_vector(31 downto 0);
        i_Instr:        in std_logic_vector(31 downto 0);
        i_PCPlus4:      in std_logic_vector(31 downto 0);
        i_JumpAddr:     in std_logic_vector(31 downto 0);
        
        o_RegDst:       out std_logic_vector(1 downto 0);
        o_JumpReg:      out std_logic;
        o_JAL:          out std_logic;
        o_Jump:         out std_logic;
        o_Branch:       out std_logic;
        o_MemRead:      out std_logic;
        o_MemtoReg:     out std_logic;
        o_ALUOp:        out std_logic_vector(6 downto 0);
        o_MemWrite:     out std_logic;
        o_ALUSrc:       out std_logic_vector(1 downto 0);
        o_RegWrite:     out std_logic;

        o_RFD1:         out std_logic_vector(31 downto 0);
        o_RFD2:         out std_logic_vector(31 downto 0);
        o_SignExtImmed: out std_logic_vector(31 downto 0);
        o_SignExtREPL:  out std_logic_vector(31 downto 0);
        o_RT:           out std_logic_vector(4 downto 0);
        o_Immed:        out std_logic_vector(15 downto 0);
        o_Instr:        out std_logic_vector(31 downto 0);
        o_PCPlus4:      out std_logic_vector(31 downto 0);
        o_JumpAddr:     out std_logic_vector(31 downto 0)
    );
end id_ex_reg;

architecture structure of id_ex_reg is

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
    signal s_RegControlUnused:  std_logic_vector(12 downto 0); -- vhdl is dumb
begin

    g_ClkInv: invg
        port map(
            i_A =>  i_clk,
            o_F =>  s_InvClk
        );

    g_RegControl: reg
        port map(
            i_D(1 downto 0)     =>  i_RegDst,
            i_D(2)              =>  i_JumpReg,
            i_D(3)              =>  i_JAL,
            i_D(4)              =>  i_Jump,
            i_D(5)              =>  i_Branch,
            i_D(6)              =>  i_MemRead,
            i_D(7)              =>  i_MemtoReg,
            i_D(14 downto 8)    =>  i_ALUOp,
            i_D(15)             =>  i_MemWrite,
            i_D(17 downto 16)   =>  i_ALUSrc,
            i_D(18)             =>  i_RegWrite,
            i_D(31 downto 19)   =>  "0000000000000",

            i_WE                =>  s_InvClk,
            i_CLK               =>  i_clk,
            i_RST               =>  i_rst,

            o_Q(1 downto 0)     =>  o_RegDst,
            o_Q(2)              =>  o_JumpReg,
            o_Q(3)              =>  o_JAL,
            o_Q(4)              =>  o_Jump,
            o_Q(5)              =>  o_Branch,
            o_Q(6)              =>  o_MemRead,
            o_Q(7)              =>  o_MemtoReg,
            o_Q(14 downto 8)    =>  o_ALUOp,
            o_Q(15)             =>  o_MemWrite,
            o_Q(17 downto 16)   =>  o_ALUSrc,
            o_Q(18)             =>  o_RegWrite,
            o_Q(31 downto 19)   =>  s_RegControlUnused
        );

    g_RegRFD1: reg
        port map(
            i_D     =>  i_RFD1,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_RFD1
        );

    g_RegRFD2: reg
        port map(
            i_D     =>  i_RFD2,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_RFD2
        );

    g_RegSignExtImmed: reg
        port map(
            i_D     =>  i_SignExtImmed,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_SignExtImmed
        );

    g_RegInstr: reg
        port map(
            i_D     =>  i_Instr,

            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,

            o_Q     =>  o_Instr
        );

    g_RegPCPlus4: reg
        port map(
            i_D     =>  i_PCPlus4,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_PCPlus4
        );

    g_RegJumpAddr: reg
        port map(
            i_D     =>  i_JumpAddr,
            i_WE    => s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_JumpAddr
        );
        
    g_RegSignExtREPL: reg
        port map(
            i_D     =>  i_SignExtREPL,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_SignExtREPL
        );
            
end structure;
    
