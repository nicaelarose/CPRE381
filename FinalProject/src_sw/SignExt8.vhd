library IEEE;
use IEEE.std_logic_1164.all;

entity SignExt8 is
    port(
        i_Immed         :   in std_logic_vector(7 downto 0);
        o_SignExtImmed  :   out std_logic_vector(31 downto 0)
    );
end SignExt8;

architecture dataflow of SignExt8 is
begin
    o_SignExtImmed(31)    <=  i_Immed(7);
    o_SignExtImmed(30)    <=  i_Immed(7);
    o_SignExtImmed(29)    <=  i_Immed(7);
    o_SignExtImmed(28)    <=  i_Immed(7);
    o_SignExtImmed(27)    <=  i_Immed(7);
    o_SignExtImmed(26)    <=  i_Immed(7);
    o_SignExtImmed(25)    <=  i_Immed(7);
    o_SignExtImmed(24)    <=  i_Immed(7);
    o_SignExtImmed(23)    <=  i_Immed(7);
    o_SignExtImmed(22)    <=  i_Immed(7);
    o_SignExtImmed(21)    <=  i_Immed(7);
    o_SignExtImmed(20)    <=  i_Immed(7);
    o_SignExtImmed(19)    <=  i_Immed(7);
    o_SignExtImmed(18)    <=  i_Immed(7);
    o_SignExtImmed(17)    <=  i_Immed(7);
    o_SignExtImmed(16)    <=  i_Immed(7);
    o_SignExtImmed(15)    <=  i_Immed(7);
    o_SignExtImmed(14)    <=  i_Immed(7);
    o_SignExtImmed(13)    <=  i_Immed(7);
    o_SignExtImmed(12)    <=  i_Immed(7);
    o_SignExtImmed(11)    <=  i_Immed(7);
    o_SignExtImmed(10)    <=  i_Immed(7);
    o_SignExtImmed(9)     <=  i_Immed(7);
    o_SignExtImmed(8)     <=  i_Immed(7);
    o_SignExtImmed(7 downto 0)     <=  i_Immed;
end dataflow;
