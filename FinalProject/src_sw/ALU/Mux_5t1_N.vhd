library IEEE;
use IEEE.std_logic_1164.all;

entity Mux_5t1_N is
    generic(N: integer := 32);
    port(
        i_A     :   in std_logic_vector(N-1 downto 0);
        i_B     :   in std_logic_vector(N-1 downto 0);
        i_C     :   in std_logic_vector(N-1 downto 0);
        i_D     :   in std_logic_vector(N-1 downto 0);
        i_E     :   in std_logic_vector(N-1 downto 0);
        i_Sel   :   in std_logic_vector(2 downto 0);
        o_Out   :   out std_logic_vector(N-1 downto 0)
    );
end Mux_5t1_N;

architecture dataflow of Mux_5t1_N is
begin
    with i_Sel select
        o_Out   <=  i_A when "000",
                    i_B when "001",
                    i_C when "010",
                    i_D when "011",
                    i_E when "100",
                    x"00000000" when others;
end dataflow;
