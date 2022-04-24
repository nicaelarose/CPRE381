library IEEE;
use IEEE.std_logic_1164.all;

entity Mux32t1_32 is
    port(
		i_Sel	:	in std_logic_vector(4 downto 0);
		i_D0	:	in std_logic_vector(31 downto 0);
        i_D1	:	in std_logic_vector(31 downto 0);
        i_D2	:	in std_logic_vector(31 downto 0);
        i_D3	:	in std_logic_vector(31 downto 0);
        i_D4	:	in std_logic_vector(31 downto 0);
        i_D5	:	in std_logic_vector(31 downto 0);
        i_D6	:	in std_logic_vector(31 downto 0);
        i_D7	:	in std_logic_vector(31 downto 0);
        i_D8	:	in std_logic_vector(31 downto 0);
        i_D9	:	in std_logic_vector(31 downto 0);
        i_D10	:	in std_logic_vector(31 downto 0);
        i_D11	:	in std_logic_vector(31 downto 0);
        i_D12	:	in std_logic_vector(31 downto 0);
        i_D13	:	in std_logic_vector(31 downto 0);
        i_D14	:	in std_logic_vector(31 downto 0);
        i_D15	:	in std_logic_vector(31 downto 0);
        i_D16	:	in std_logic_vector(31 downto 0);
        i_D17	:	in std_logic_vector(31 downto 0);
        i_D18	:	in std_logic_vector(31 downto 0);
        i_D19	:	in std_logic_vector(31 downto 0);
        i_D20	:	in std_logic_vector(31 downto 0);
        i_D21	:	in std_logic_vector(31 downto 0);
        i_D22	:	in std_logic_vector(31 downto 0);
        i_D23	:	in std_logic_vector(31 downto 0);
        i_D24	:	in std_logic_vector(31 downto 0);
        i_D25	:	in std_logic_vector(31 downto 0);
        i_D26	:	in std_logic_vector(31 downto 0);
        i_D27	:	in std_logic_vector(31 downto 0);
        i_D28	:	in std_logic_vector(31 downto 0);
        i_D29	:	in std_logic_vector(31 downto 0);
        i_D30	:	in std_logic_vector(31 downto 0);
        i_D31	:	in std_logic_vector(31 downto 0);
		o_Out	:	out std_logic_vector(31 downto 0)
	);
end Mux32t1_32;

architecture structural of Mux32t1_32 is

    component Mux32to1 is
        port(
		    i_Sel	:	in std_logic_vector(4 downto 0);
		    i_D0	:	in std_logic;
		    i_D1	:	in std_logic;
		    i_D2	:	in std_logic;
		    i_D3	:	in std_logic;
		    i_D4	:	in std_logic;
		    i_D5	:	in std_logic;
		    i_D6	:	in std_logic;
		    i_D7	:	in std_logic;
		    i_D8	:	in std_logic;
		    i_D9	:	in std_logic;
		    i_D10	:	in std_logic;
		    i_D11	:	in std_logic;
		    i_D12	:	in std_logic;
		    i_D13	:	in std_logic;
		    i_D14	:	in std_logic;
		    i_D15	:	in std_logic;
		    i_D16	:	in std_logic;
		    i_D17	:	in std_logic;
		    i_D18	:	in std_logic;
		    i_D19	:	in std_logic;
		    i_D20	:	in std_logic;
		    i_D21	:	in std_logic;
		    i_D22	:	in std_logic;
		    i_D23	:	in std_logic;
		    i_D24	:	in std_logic;
		    i_D25	:	in std_logic;
		    i_D26	:	in std_logic;
		    i_D27	:	in std_logic;
		    i_D28	:	in std_logic;
		    i_D29	:	in std_logic;
		    i_D30	:	in std_logic;
		    i_D31	:	in std_logic;
		    o_Out	:	out std_logic
	    );
    end component;
    
begin
    
    G_32Bit_Mux: for i in 0 to 31 generate
        Mux_I: Mux32to1 port map(
            i_Sel   =>  i_Sel,
            i_D0    =>  i_D0(i),
            i_D1    =>  i_D1(i),
            i_D2    =>  i_D2(i),
            i_D3    =>  i_D3(i),
            i_D4    =>  i_D4(i),
            i_D5    =>  i_D5(i),
            i_D6    =>  i_D6(i),
            i_D7    =>  i_D7(i),
            i_D8    =>  i_D8(i),
            i_D9    =>  i_D9(i),
            i_D10   =>  i_D10(i),
            i_D11   =>  i_D11(i),
            i_D12   =>  i_D12(i),
            i_D13   =>  i_D13(i),
            i_D14   =>  i_D14(i),
            i_D15   =>  i_D15(i),
            i_D16   =>  i_D16(i),
            i_D17   =>  i_D17(i),
            i_D18   =>  i_D18(i),
            i_D19   =>  i_D19(i),
            i_D20   =>  i_D20(i),
            i_D21   =>  i_D21(i),
            i_D22   =>  i_D22(i),
            i_D23   =>  i_D23(i),
            i_D24   =>  i_D24(i),
            i_D25   =>  i_D25(i),
            i_D26   =>  i_D26(i),
            i_D27   =>  i_D27(i),
            i_D28   =>  i_D28(i),
            i_D29   =>  i_D29(i),
            i_D30   =>  i_D30(i),
            i_D31   =>  i_D31(i),
            o_Out   =>  o_out(i)
        );
    end generate;
    
end structural;
