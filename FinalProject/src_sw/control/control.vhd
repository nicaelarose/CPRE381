library IEEE;
use IEEE.std_logic_1164.all;

entity Control is
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
end Control;

architecture dataflow of Control is
begin
    with i_Opcode select
        o_RegDest   <=  "01" when "000000",    -- Only R-Type instructions get the register to write to from rd
                        "10" when "000011",    -- Jump and Link, 2 should be 31
                        "00" when others;      -- All others get it from rt or don't write to registers

    with i_Opcode select
        o_JAL       <=  '1' when "000011",    -- 1 for JAL opcode
                        '0' when others;

    with i_Funct select
        o_JumpReg   <=  '1' when "001000",    -- 1 for jr funct
                        '0' when others;

    with i_Opcode select
        o_Jump      <=  '1' when "000010",    -- Enable for j and jal (jr not yet implemented)
                        '1' when "000011",
                        '0' when others;      -- Disable for non-jump instructions
    with i_Opcode select
        o_Branch    <=  '1' when "000100",    -- Enable for beq and bne
                        '1' when "000101",
                        '0' when others;      -- Disable for non-branch instrs
   with i_Opcode select
        o_MemRead   <=  '1' when "100011",    -- Enable only for lw
                        '0' when others;
   with i_Opcode select
        o_MemtoReg  <=  '1' when "100011",    -- Enable only for lw
                        '0' when others;
   with i_Opcode select
        o_ALUOp(6)  <=  '1' when "000000",    -- Set o_ALUOp to the opcode prepended with a bit
                        '0' when others;      -- indicating whether or not the instruction is R-Type

        o_ALUOp(5 downto 0) <=  i_Opcode;

   with i_Opcode select
        o_MemWrite  <=  '1' when "101011",    -- Enable only for sw
                        '0' when others;
        with i_Opcode select
        o_ALUSrc    <=  "00" when "000000",    -- ALU input comes from registers on R-Type instrs
                        "10" when "011111",
                        "01" when others;      -- I-Type uses SignExtImmed, and J-Type doesn't use the main ALU
     with i_Opcode select
        o_RegWrite  <=  '0' when "101011",    -- Disable for sw
                        '0' when "000100",    -- beq
                        '0' when "000101",    -- bne
                        '0' when "000010",    -- j
                        '0' when "000000",    -- jr
                        '1' when others;      -- Enable for all others
end dataflow;