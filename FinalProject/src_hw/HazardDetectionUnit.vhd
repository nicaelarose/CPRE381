library IEEE;
use IEEE.std_logic_1164.all;

entity HazardDetectionUnit is
  port(i_IdExMemRead      : in std_logic;
       i_IfIdRs           : in std_logic_vector(4 downto 0);
       i_IfIdRt           : in std_logic_vector(4 downto 0);
       i_IdExRt           : in std_logic_vector(4 downto 0);
       o_PCValueUpdate    : out std_logic);

end HazardDetectionUnit;

architecture dataflow of HazardDetectionUnit is
  begin

  --o_PCValueUpdate used as signal for mux going into the program counter
  o_PCValueUpdate <= '1' when (i_IdExMemRead = '1') and ((i_IdExRt = i_IfIdRs) or (i_IdExRt = i_IfIdRt)) else --don't update
    	             '0'; --update

end dataflow;

