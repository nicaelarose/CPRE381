library IEEE;
use IEEE.std_logic_1164.all;

entity ex_mem_reg is
    port(
        i_clk:          in std_logic;
        i_rst:          in std_logic;

        i_JAL:          in std_logic;
        i_MemRead:      in std_logic;
        i_MemtoReg:     in std_logic;
        i_MemWrite:     in std_logic;
        i_RegWrite:     in std_logic;

        i_ALUZero:      in std_logic;
        i_ALUResult:    in std_logic_vector(31 downto 0);
        i_RFD2:         in std_logic_vector(31 downto 0);   -- RegFile Data2
        i_Instr:        in std_logic_vector(31 downto 0);
        
        o_JAL:          out std_logic;
        o_MemRead:      out std_logic;
        o_MemtoReg:     out std_logic;
        o_MemWrite:     out std_logic;
        o_RegWrite:     out std_logic;

        o_ALUZero:      out std_logic;
        o_ALUResult:    out std_logic_vector(31 downto 0);
        o_RFD2:         out std_logic_vector(31 downto 0);
        o_Instr:        out std_logic_vector(31 downto 0)
    );
end ex_mem_reg;

architecture structure of ex_mem_reg is

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
    signal s_RegControlUnused:  std_logic_vector(26 downto 0);
    signal s_RegALUZero_Unused: std_logic_vector(30 downto 0);
begin

    g_ClkInv: invg
        port map(
            i_A =>  i_clk,
            o_F =>  s_InvClk
        );

    g_RegControl: reg
        port map(
            i_D(0)              =>  i_JAL,
            i_D(1)              =>  i_MemRead,
            i_D(2)              =>  i_MemtoReg,
            i_D(3)              =>  i_MemWrite,
            i_D(4)              =>  i_RegWrite,
            i_D(31 downto 5)    =>  "000" & x"000000",

            i_WE                =>  s_InvClk,
            i_CLK               =>  i_clk,
            i_RST               =>  i_rst,

            o_Q(0)              =>  o_JAL,
            o_Q(1)              =>  o_MemRead,
            o_Q(2)              =>  o_MemtoReg,
            o_Q(3)              =>  o_MemWrite,
            o_Q(4)              =>  o_RegWrite,
            o_Q(31 downto 5)    =>  s_RegControlUnused
        );

    g_RegALUResult: reg
        port map(
            i_D     =>  i_ALUResult,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_ALUResult
        );

    g_RegRFD2: reg
        port map(
            i_D     =>  i_RFD2,
            i_WE    =>  s_InvClk,
            i_CLK   =>  i_clk,
            i_RST   =>  i_rst,
            o_Q     =>  o_RFD2
        );

    g_RegALUZero: reg
        port map(
            i_D(0)              =>  i_ALUZero,
            i_D(31 downto 1)    =>  "000" & x"0000000",  

            i_WE                =>  s_InvClk,
            i_CLK               =>  i_clk,
            i_RST               =>  i_rst,
            
            o_Q(0)              =>  o_ALUZero,
            o_Q(31 downto 1)    =>  s_RegALUZero_Unused
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
    
