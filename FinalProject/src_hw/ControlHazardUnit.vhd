library IEEE;
use IEEE.std_logic_1164.all;

entity ControlHazardUnit is
    port(
        i_ALUZero:      in std_logic;
        i_Jump:         in std_logic;
        i_JAL:          in std_logic;
        i_JumpReg:      in std_logic;
        i_Branch:       in std_logic;
        i_IDEX_Branch:  in std_logic;

        o_StallPC:      out std_logic;
        o_StallIFID:    out std_logic;
        o_StallIDEX:    out std_logic;

        o_FlushIFID:    out std_logic;
        o_FlushIDEX:    out std_logic
    );
end ControlHazardUnit;

architecture dataflow of ControlHazardUnit is
begin

    o_StallPC <= i_Branch or i_IDEX_Branch;
    o_StallIFID <= i_Branch or i_IDEX_Branch;
    o_StallIDEX <= i_IDEX_Branch;
    o_FlushIFID <= i_IDEX_Branch and i_ALUZero;
    o_FlushIDEX <= i_IDEX_Branch and i_ALUZero;

end dataflow;

