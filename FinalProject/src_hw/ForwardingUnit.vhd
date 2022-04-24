library IEEE;
use IEEE.std_logic_1164.all;

entity ForwardingUnit is
  port(i_ExMemRd          : in std_logic_vector(4 downto 0);
       i_IdExRs           : in std_logic_vector(4 downto 0);
       i_IdExRt           : in std_logic_vector(4 downto 0);
       i_ExMemRegWrite    : in std_logic;
       i_MemWBRegWrite    : in std_logic;
       i_MemWbRd          : in std_logic_vector(4 downto 0);
       o_ForwardA         : out std_logic_vector(1 downto 0);
       o_ForwardB         : out std_logic_vector(1 downto 0));

end ForwardingUnit;

architecture dataflow of ForwardingUnit is
  begin

  o_ForwardA <= "10" when (i_ExMemRegWrite = '1') and (i_ExMemRd /= "00000") and (i_ExMemRd = i_IdExRs) else --Ex hazard
                "01" when (i_MemWBRegWrite = '1') and (i_MemWbRd /= "00000") and not((i_ExMemRegWrite = '1') and (i_ExMemRd /= "00000") and (i_ExMemRd /=  i_IdExRs)) and  (i_MemWbRd = i_IdExRs) else --Mem hazard
                "00";

  o_ForwardB <= "10" when (i_ExMemRegWrite = '1') and (i_ExMemRd /= "00000") and (i_ExMemRd = i_IdExRt) else --Ex hazard
		"01" when (i_MemWBRegWrite = '1') and (i_MemWbRd /= "00000") and not((i_ExMemRegWrite = '1') and (i_ExMemRd /= "00000") and (i_ExMemRd /=  i_IdExRt)) and  (i_MemWbRd = i_IdExRt) else --Mem hazard
		"00";

end dataflow;

