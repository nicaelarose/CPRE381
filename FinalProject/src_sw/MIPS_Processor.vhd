library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
    generic(
        N: integer := 32;
        DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
    );

    port(
        iRST        :   in std_logic;
        iCLK        :   in std_logic;
        iInstLd     :   in std_logic;
        iInstAddr   :   in std_logic_vector(N-1 downto 0);
        iInstExt    :   in std_logic_vector(N-1 downto 0);
        oALUOut     :   out std_logic_vector(N-1 downto 0)
    );
end MIPS_Processor;

architecture structural of MIPS_Processor is

    -- Required data memory signals
    signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
    signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
    signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
    signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
    
    -- Required register file signals 
    signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
    signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
    signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

    -- Required instruction memory signals
    signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
    signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
    signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

    -- Required halt signal -- for simulation
    signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

    -- Required overflow signal -- for overflow exception detection
    signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

    component mem is
        port 
        (
            clk		: in std_logic;
            addr	        : in std_logic_vector((ADDR_WIDTH-1) downto 0);
            data	        : in std_logic_vector((DATA_WIDTH-1) downto 0);
            we		: in std_logic := '1';
            q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
        );
    end component;

    component Control is
        port(i_Opcode    :   in std_logic_vector(5 downto 0);
            i_Funct     :   in std_logic_vector(5 downto 0);
            o_RegDest   :   out std_logic_vector(1 downto 0);
            o_JAL       :   out std_logic;
            o_JumpReg   :   out std_logic;
            o_Jump      :   out std_logic;
            o_Branch    :   out std_logic;
            o_MemRead   :   out std_logic;
            o_MemtoReg  :   out std_logic;
            o_ALUOp     :   out std_logic_vector(6 downto 0);
            o_MemWrite  :   out std_logic;
            o_ALUSrc    :   out std_logic_vector(1 downto 0);
            o_RegWrite  :   out std_logic);
    end component;

    component ALU_control is
        port(
            i_RType     :   in std_logic; -- 1 if instruction is R-Type, 0 otherwise
            i_ALUOp     :   in std_logic_vector(5 downto 0); -- Funct input from main control unit
            i_Funct     :   in std_logic_vector(5 downto 0); -- Funct input from bits 5-0 of instr
            i_ShiftAmt  :   in std_logic_vector(4 downto 0);
            o_OutSel    :   out std_logic_vector(2 downto 0); -- Selects which subcomponent of the alu to output. mappings found in ALU_control_output_select.txt
            o_Sub       :   out std_logic; 
            o_ShiftDir  :   out std_logic;
            o_ShiftType :   out std_logic;
            o_ShiftAmt  :   out std_logic_vector(4 downto 0);
            o_InvOut    :   out std_logic
        );
    end component;

    component ALU is
        port(
            i_A         :   in std_logic_vector(N-1 downto 0);
            i_B         :   in std_logic_vector(N-1 downto 0);
            i_OutSel    :   in std_logic_vector(2 downto 0);
            i_Sub       :   in std_logic; 
            i_ShiftDir  :   in std_logic;
            i_ShiftType :   in std_logic;
            i_ShiftAmt  :   in std_logic_vector(4 downto 0);
            i_InvOut    :   in std_logic;
            o_Output    :   out std_logic_vector(N-1 downto 0);
            o_Zero      :   out std_logic;
            o_Ovfl	: out std_logic
        );
    end component;

    component regfile is
        port(
            i_CLK   : in std_logic;                    -- Clock input
            i_RST   : in std_logic;                    -- Reset input
            i_WSel  : in std_logic_vector(4 downto 0); -- Write select input
            i_WE    : in std_logic;
            i_RD    : in std_logic_vector(31 downto 0);                      -- Data input
            i_RSSel : in std_logic_vector(4 downto 0); -- Read select for rs
            o_RS    : out std_logic_vector(31 downto 0);                     -- Read port output rs
            i_RTSel : in std_logic_vector(4 downto 0); -- Read select for rt
            o_RT    : out std_logic_vector(31 downto 0)                       -- Read port output rt
        );
    end component;

    component mux2t1 is
        port(
            i_S     :    in std_logic;
            i_D0    :    in std_logic;
            i_D1    :    in std_logic;
            o_O     :    out std_logic
        );
    end component;

    component mux2t1_5 is
        port(i_S          : in std_logic;
            i_D0         : in std_logic_vector(4 downto 0);
            i_D1         : in std_logic_vector(4 downto 0);
            o_O          : out std_logic_vector(4 downto 0));
    end component;

    component mux2t1_32 is
        port(i_S          : in std_logic;
            i_D0         : in std_logic_vector(31 downto 0);
            i_D1         : in std_logic_vector(31 downto 0);
            o_O          : out std_logic_vector(31 downto 0));
    end component;
    
    component mux3t1_5 is
        port(i_S          : in std_logic_vector(1 downto 0);
           i_D0         : in std_logic_vector(4 downto 0);
           i_D1         : in std_logic_vector(4 downto 0);
           i_D2         : in std_logic_vector(4 downto 0);
           o_O          : out std_logic_vector(4 downto 0));
    end component;
    
    component mux3t1_32 is
        port(i_S          : in std_logic_vector(1 downto 0);
           i_D0         : in std_logic_vector(31 downto 0);
           i_D1         : in std_logic_vector(31 downto 0);
           i_D2         : in std_logic_vector(31 downto 0);
           o_O          : out std_logic_vector(31 downto 0));
    end component;

    component Adder is
        port(
            i_A	: in std_logic_vector(N-1 downto 0);
            i_B	: in std_logic_vector(N-1 downto 0);
            i_Cin	: in std_logic;
            o_S	: out std_logic_vector(N-1 downto 0);
            o_Cout	: out std_logic;
            o_Ovfl	: out std_logic
        );
    end component;

    component andg2 is
        port(i_A          : in std_logic;
            i_B          : in std_logic;
            o_F          : out std_logic);
    end component;

    component SignExt is
        port(
            i_Immed         :   in std_logic_vector(15 downto 0);
            o_SignExtImmed  :   out std_logic_vector(31 downto 0)
        );
    end component;
    
    component SignExt8 is
        port(
            i_Immed         :   in std_logic_vector(7 downto 0);
            o_SignExtImmed  :   out std_logic_vector(31 downto 0)
        );
    end component;

    component reg is
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

    component if_id_reg is
        port(
            i_CLK:  in std_logic;
            i_RST:  in std_logic;
            i_PC:   in std_logic_vector(31 downto 0);
            i_IM:   in std_logic_vector(31 downto 0);
            o_PC:   out std_logic_vector(31 downto 0);
            o_IM:   out std_logic_vector(31 downto 0)
        );
    end component;

    component id_ex_reg is
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
    end component;

    component ex_mem_reg is
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
    end component;

    component mem_wb_reg is
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
    end component;

    signal s_ClockInv   :   std_logic; -- Inverse of the clock signal
                                       -- so that things can be triggered on the
                                       -- falling edge

    -- Program Counter signals
    signal s_PC_Next    : std_logic_vector(31 downto 0);

    -- Main control signals
    signal s_RegDst     :   std_logic_vector(1 downto 0);
    signal s_JumpReg    :   std_logic;
    signal s_JAL        :   std_logic;
    signal s_Jump       :   std_logic;
    signal s_Branch     :   std_logic;
    signal s_MemRead    :   std_logic;
    signal s_MemtoReg   :   std_logic;
    signal s_ALUOp      :   std_logic_vector(6 downto 0);
    signal s_MemWrite   :   std_logic;
    signal s_ALUSrc     :   std_logic_vector(1 downto 0);
    signal s_RegWrite   :   std_logic;

    -- ALU control signals
    signal s_ALU_OutSel     :   std_logic_vector(2 downto 0);
    signal s_ALU_Sub        :   std_logic;
    signal s_ALU_ShiftDir   :   std_logic;
    signal s_ALU_ShiftType  :   std_logic;
    signal s_ALU_ShiftAmt   :   std_logic_vector(4 downto 0);
    signal s_ALU_InvOut     :   std_logic;

    -- RegFile i/o signals
    signal s_RF_RData1  :   std_logic_vector(31 downto 0);
    signal s_RF_RData2  :   std_logic_vector(31 downto 0);

    signal s_SignExtImmed   :   std_logic_vector(31 downto 0);
    signal s_SignExtREPL    :   std_logic_vector(31 downto 0);

    -- ALU i/o signals
    signal s_ALU_B          :   std_logic_vector(31 downto 0);
    signal s_ALU_Result     :   std_logic_vector(31 downto 0);
    signal s_ALU_Zero       :   std_logic;

    signal s_PCPlus4    :   std_logic_vector(31 downto 0);
    signal s_JumpAddr   :   std_logic_vector(31 downto 0);
    signal s_BranchAddr :   std_logic_vector(31 downto 0);
    signal s_BranchMuxS :   std_logic;
    signal s_NotJumpAddr:   std_logic_vector(31 downto 0);

    -- Pipeline register signals
    -- s_REGNAME_SignalName is SignalName at the output of REGNAME
    signal s_IFID_PCPlus4       :   std_logic_vector(31 downto 0);
    signal s_IFID_Instruction   :   std_logic_vector(31 downto 0);

    signal s_IDEX_RegDst        :   std_logic_vector(1 downto 0);
    signal s_IDEX_JumpReg       :   std_logic;
    signal s_IDEX_JAL           :   std_logic;
    signal s_IDEX_Jump          :   std_logic;
    signal s_IDEX_Branch        :   std_logic;
    signal s_IDEX_MemRead       :   std_logic;
    signal s_IDEX_MemtoReg      :   std_logic;
    signal s_IDEX_ALUOp         :   std_logic_vector(6 downto 0);
    signal s_IDEX_MemWrite      :   std_logic;
    signal s_IDEX_ALUSrc        :   std_logic_vector(1 downto 0);
    signal s_IDEX_RegWrite      :   std_logic;
    signal s_IDEX_RFD1          :   std_logic_vector(31 downto 0);
    signal s_IDEX_RFD2          :   std_logic_vector(31 downto 0);
    signal s_IDEX_SignExtImmed  :   std_logic_vector(31 downto 0);
    signal s_IDEX_SignExtREPL   :   std_logic_vector(31 downto 0);
    signal s_IDEX_Instr         :   std_logic_vector(31 downto 0);
    signal s_IDEX_PCPlus4       :   std_logic_vector(31 downto 0);
    signal s_IDEX_JumpAddr      :   std_logic_vector(31 downto 0);

    signal s_EXMEM_JAL          :   std_logic;
    signal s_EXMEM_MemRead      :   std_logic;
    signal s_EXMEM_MemtoReg     :   std_logic;
    signal s_EXMEM_MemWrite     :   std_logic;
    signal s_EXMEM_RegWrite     :   std_logic;
    signal s_EXMEM_ALUZero      :   std_logic;
    signal s_EXMEM_ALUResult    :   std_logic_vector(31 downto 0);
    signal s_EXMEM_RFD2         :   std_logic_vector(31 downto 0);
    signal s_EXMEM_Instr        :   std_logic_vector(31 downto 0);

    signal s_MEMWB_JAL          :   std_logic;
    signal s_MEMWB_MemtoReg     :   std_logic;
    signal s_MEMWB_RegWrite     :   std_logic;
    signal s_MEMWB_MemReadData  :   std_logic_vector(31 downto 0);
    signal s_MEMWB_ALUResult    :   std_logic_vector(31 downto 0);
    signal s_MEMWB_Instr        :   std_logic_vector(31 downto 0);

begin

    with s_Inst(31 downto 26) select
        s_Halt <= '1' when "010100",
                  '0' when others;

    g_ClockInverter: invg
        port map(
            i_A =>  iCLK,
            o_F =>  s_ClockInv
        );

    g_ProgCounter: reg
        port map(
            i_D     =>  s_PC_Next,
            i_WE    =>  s_ClockInv,
            i_CLK   =>  iCLK,
            i_RST   =>  iRST,
            o_Q     =>  s_NextInstAddr
        );

    with iInstLd select
        s_IMemAddr <= s_NextInstAddr when '0',
                      iInstAddr when others;

    IMem: mem
        port map(
            clk     =>  iCLK,
            addr    =>  s_IMemAddr(11 downto 2),
            we      =>  iInstLd,
            q       =>  s_Inst,
            data    =>  iInstExt
        );

    g_Adder_PC: Adder
        port map(
            i_A     =>  s_NextInstAddr,
            i_B     =>  x"00000004",
            i_Cin   =>  '0',
            o_S     =>  s_PCPlus4
        );

    g_IFID_Reg: if_id_reg
        port map(
            i_CLK   =>  iCLK,
            i_RST   =>  iRST,
            i_PC    =>  s_PCPlus4,
            i_IM    =>  s_Inst,
            o_PC    =>  s_IFID_PCPlus4,
            o_IM    =>  s_IFID_Instruction
        );

    s_JumpAddr  <=  s_IFID_PCPlus4(31 downto 28) & s_IFID_Instruction(25 downto 0) & "00";

    g_Control: Control
        port map(
            i_Opcode    =>  s_IFID_Instruction(31 downto 26),
            i_Funct     =>  s_IFID_Instruction(5 downto 0),
            o_RegDest   =>  s_RegDst,
            o_JAL       =>  s_JAL,
            o_JumpReg   =>  s_JumpReg,
            o_Jump      =>  s_Jump,
            o_Branch    =>  s_Branch,
            o_MemRead   =>  s_MemRead,
            o_MemtoReg  =>  s_MemtoReg,
            o_ALUOp     =>  s_ALUOp,
            o_MemWrite  =>  s_MemWrite,
            o_ALUSrc    =>  s_ALUSrc,
            o_RegWrite  =>  s_RegWrite
        );

    g_Adder_Branch: Adder
        port map(
            i_A                 =>  s_IFID_PCPlus4,
            i_B(31 downto 2)    =>  s_SignExtImmed(29 downto 0),
            i_B(1 downto 0)     =>  "00",
            i_Cin               =>  '0',
            o_S                 =>  s_BranchAddr
        );

    g_Mux_RegDst: mux3t1_5
        port map(
            i_S     =>  s_RegDst,
            i_D0    =>  s_MEMWB_Instr(20 downto 16),
            i_D1    =>  s_MEMWB_Instr(15 downto 11),
            i_D2    =>  "11111",
            o_O     =>  s_RegWrAddr
        );
    
    s_RegWr <= s_MEMWB_RegWrite;

    g_RegFile: regfile
        port map(
            i_CLK   =>  iCLK,
            i_WSel  =>  s_RegWrAddr,
            i_RSSel =>  s_Inst(25 downto 21),
            i_RTSel =>  s_Inst(20 downto 16),
            i_RD    =>  s_RegWrData,
            o_RS    =>  s_RF_RData1,
            o_RT    =>  s_RF_RData2,
            i_WE    =>  s_RegWr,
            i_RST   =>  iRST
        );

    g_SignExt: SignExt
        port map(
            i_Immed =>  s_Inst(15 downto 0),
            o_SignExtImmed  =>  s_SignExtImmed
        );
        
    g_SignExtREPLQB: SignExt8
        port map(
            i_Immed =>  s_Inst(7 downto 0),
            o_SignExtImmed  =>  s_SignExtREPL
        );

    g_IDEX_Reg: id_ex_reg
        port map(
            i_CLK           =>  iCLK,
            i_RST           =>  iRST,

            i_RegDst        =>  s_RegDst,
            i_JumpReg       =>  s_JumpReg,
            i_JAL           =>  s_JAL,
            i_Jump          =>  s_Jump,
            i_Branch        =>  s_Branch,
            i_MemRead       =>  s_MemRead,
            i_MemtoReg      =>  s_MemtoReg,
            i_ALUOp         =>  s_ALUOp,
            i_MemWrite      =>  s_MemWrite,
            i_ALUSrc        =>  s_ALUSrc,
            i_RegWrite      =>  s_RegWrite,

            i_RFD1          =>  s_RF_RData1,
            i_RFD2          =>  s_RF_RData2,
            i_SignExtImmed  =>  s_SignExtImmed,
            i_SignExtREPL   =>  s_SignExtREPL,
            i_Instr         =>  s_IFID_Instruction,
            i_PCPlus4       =>  s_IFID_PCPlus4,
            i_JumpAddr      =>  s_JumpAddr,

            o_RegDst        =>  s_IDEX_RegDst,
            o_JumpReg       =>  s_IDEX_JumpReg,
            o_JAL           =>  s_IDEX_JAL,
            o_Jump          =>  s_IDEX_Jump,
            o_Branch        =>  s_IDEX_Branch,
            o_MemRead       =>  s_IDEX_MemRead,
            o_MemtoReg      =>  s_IDEX_MemtoReg,
            o_ALUOp         =>  s_IDEX_ALUOp,
            o_MemWrite      =>  s_IDEX_MemWrite,
            o_ALUSrc        =>  s_IDEX_ALUSrc,
            o_RegWrite      =>  s_IDEX_RegWrite,

            o_RFD1          =>  s_IDEX_RFD1,
            o_RFD2          =>  s_IDEX_RFD2,
            o_SignExtImmed  =>  s_IDEX_SignExtImmed,
            o_SignExtREPL   =>  s_IDEX_SignExtRepl,
            o_Instr         =>  s_IDEX_Instr,
            o_PCPlus4       =>  s_IDEX_PCPlus4,
            o_JumpAddr      =>  s_IDEX_JumpAddr
        );

    g_ALU_Control: ALU_control
        port map(
            i_RType     =>  s_IDEX_ALUOp(6),
            i_ALUOp     =>  s_IDEX_ALUOp(5 downto 0),
            i_Funct     =>  s_IDEX_Instr(5 downto 0),
            i_ShiftAmt  =>  s_IDEX_Instr(10 downto 6),
            o_OutSel    =>  s_ALU_OutSel,
            o_Sub       =>  s_ALU_Sub,
            o_ShiftDir  =>  s_ALU_ShiftDir,
            o_ShiftType =>  s_ALU_ShiftType,
            o_ShiftAmt  =>  s_ALU_ShiftAmt,
            o_InvOut    =>  s_ALU_InvOut
        );

    g_Mux_ALUSrc: mux3t1_32
        port map(
            i_S     =>  s_IDEX_ALUSrc,
            i_D0    =>  s_IDEX_RFD2,
            i_D1    =>  s_IDEX_SignExtImmed,
            i_D2    =>  s_IDEX_SignExtREPL,
            o_O     =>  s_ALU_B
        );
    
    g_ALU: ALU
        port map(
            i_A         =>  s_IDEX_RFD1,
            i_B         =>  s_ALU_B,
            i_OutSel    =>  s_ALU_OutSel,
            i_Sub       =>  s_ALU_Sub,
            i_ShiftDir  =>  s_ALU_ShiftDir,
            i_ShiftType =>  s_ALU_ShiftType,
            i_ShiftAmt  =>  s_ALU_ShiftAmt,
            i_InvOut    =>  s_ALU_InvOut,
            o_Output    =>  s_ALU_Result,
            o_Zero      =>  s_ALU_Zero,
            o_Ovfl      =>  s_Ovfl
        );

    oALUOut <= s_ALU_Result;

    g_AND_Branch: andg2
        port map(
            i_A =>  s_IDEX_Branch,
            i_B =>  s_ALU_Zero,
            o_F =>  s_BranchMuxS
        );

    g_Mux_Branch: mux2t1_32
        port map(
            i_S     =>  s_BranchMuxS,
            i_D0    =>  s_IDEX_PCPlus4,
            i_D1    =>  s_BranchAddr,
            o_O     =>  s_NotJumpAddr
        );

    g_Mux_Jump: mux2t1_32
        port map(
            i_S     =>  s_IDEX_Jump,
            i_D0    =>  s_NotJumpAddr,
            i_D1    =>  s_IDEX_JumpAddr,
            o_O     =>  s_PC_Next
        );

    g_EXMEM_Reg: ex_mem_reg
        port map(
            i_CLK       =>  iCLK,
            i_RST       =>  iRST,

            i_JAL       =>  s_IDEX_JAL,
            i_MemRead   =>  s_IDEX_MemRead,
            i_MemtoReg  =>  s_IDEX_MemtoReg,
            i_MemWrite  =>  s_IDEX_MemWrite,
            i_RegWrite  =>  s_IDEX_RegWrite,

            i_ALUZero   =>  s_ALU_Zero,
            i_ALUResult =>  s_ALU_Result,
            i_RFD2      =>  s_IDEX_RFD2,
            i_Instr     =>  s_IDEX_Instr,

            o_JAL       =>  s_EXMEM_JAL,
            o_MemRead   =>  s_EXMEM_MemRead,
            o_MemtoReg  =>  s_EXMEM_MemtoReg,
            o_MemWrite  =>  s_EXMEM_MemWrite,
            o_RegWrite  =>  s_EXMEM_RegWrite,

            o_ALUZero   =>  s_EXMEM_ALUZero,
            o_ALUResult =>  s_EXMEM_ALUResult,
            o_RFD2      =>  s_EXMEM_RFD2,
            o_Instr     =>  s_EXMEM_Instr
        );

    s_DMemWr <= s_EXMEM_MemWrite;
    s_DMemAddr <= s_EXMEM_ALUResult;
    s_DMemData <= s_EXMEM_RFD2;

    DMem: mem
        port map(
            clk     =>  iCLK,
            addr    =>  s_DMemAddr(11 downto 2),
            we      =>  s_DMemWr,
            data    =>  s_DMemData,
            q       =>  s_DMemOut
        );

    g_MEMWB_Reg: mem_wb_reg
        port map(
            i_CLK           =>  iCLK,
            i_RST           =>  iRST,
            
            i_JAL           =>  s_EXMEM_JAL,
            i_MemtoReg      =>  s_EXMEM_MemtoReg,
            i_RegWrite      =>  s_EXMEM_RegWrite,

            i_MemReadData   =>  s_DMemOut,
            i_ALUResult     =>  s_EXMEM_ALUResult,
            i_Instr         =>  s_EXMEM_Instr,

            o_JAL           =>  s_MEMWB_JAL,
            o_MemtoReg      =>  s_MEMWB_MemtoReg,
            o_RegWrite      =>  s_MEMWB_RegWrite,

            o_MemReadData   =>  s_MEMWB_MemReadData,
            o_ALUResult     =>  s_MEMWB_ALUResult,
            o_Instr         =>  s_MEMWB_Instr
        );

    g_Mux_MemtoReg: mux2t1_32
        port map(
            i_S     =>  s_MEMWB_MemtoReg,
            i_D0    =>  s_MEMWB_ALUResult,
            i_D1    =>  s_MEMWB_MemReadData,
            o_O     =>  s_RegWrData
        );

end structural;
