library IEEE;
use IEEE.std_logic_1164.all;

entity ALU_control is
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
end ALU_control;

architecture dataflow of ALU_control is
    signal s_Funct  :   std_logic_vector(6 downto 0); -- Multiplexed ALUOp/Funct depending on i_RType
    signal s_ShiftAmt:  std_logic_vector(4 downto 0); -- ShiftAmt field if R-type, 0 otherwise
begin

    s_Funct(6)  <= i_RType; -- i_RType concatenated as the msb of the
                            -- op/funct so the whole thing is unique.
    with i_RType select
        s_Funct(5 downto 0) <=  i_ALUOp when '0', 
                                i_Funct when '1', 
                                "000000" when others; 

    with i_RType select
        s_ShiftAmt  <=  i_ShiftAmt when '1',
                        "00000" when others;
    
    with s_Funct select
        o_OutSel    <=  "000" when "1100000", -- add
                        "000" when "0001000", -- addi
                        "000" when "0001001", -- addiu
                        "000" when "1100001", -- addu
                        "010" when "1100100", -- and
                        "010" when "0001100", -- andi
                        "001" when "0001111", -- lui
                        "000" when "0100011", -- lw
                        "011" when "1100111", -- nor
                        "100" when "1100110", -- xor
                        "100" when "0001110", -- xori
                        "011" when "1100101", -- or
                        "011" when "0001101", -- ori
                        "000" when "1101010", -- slt
                        "000" when "0001010", -- slti
                        "001" when "1000000", -- sll
                        "001" when "1000010", -- srl
                        "001" when "1000011", -- sra
                        "000" when "0101011", -- sw
                        "000" when "1100010", -- sub
                        "000" when "1100011", -- subu
                        "000" when "0000100", -- beq
                        "000" when "0000101", -- bne
                        "000" when others;
    
    with s_Funct select
        o_Sub   <=  '0' when "1100000", -- add
                    '0' when "0001000", -- addi
                    '0' when "0001001", -- addiu
                    '0' when "1100001", -- addu
                    '0' when "0100011", -- lw
                    '0' when "0101011", -- sw
                    '1' when "1101010", -- slt
                    '1' when "0001010", -- slti
                    '1' when "1100010", -- sub
                    '1' when "1100011", -- subu
                    '1' when "0000100", -- beq
                    '1' when "0000101", -- bne
                    '0' when others;

    with s_Funct select
        o_ShiftDir  <=  '0' when "0001111", -- lui
                        '0' when "1000000", -- sll
                        '1' when "1000010", -- srl
                        '1' when "1000011", -- sra
                        '0' when others;

    with s_Funct select
        o_ShiftType <=  '0' when "0001111", -- lui
                        '0' when "1000000", -- sll
                        '0' when "1000010", -- srl
                        '1' when "1000011", -- sra
                        '0' when others;
                        
    with s_Funct select
        o_ShiftAmt  <=  "10000" when "0001111", -- lui
                        s_ShiftAmt when others;

    with s_Funct select
        o_InvOut    <=  '1' when "1100111", -- nor
                        '0' when others;

end dataflow;