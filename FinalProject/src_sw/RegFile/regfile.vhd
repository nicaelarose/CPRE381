library IEEE;
use IEEE.std_logic_1164.all;

entity regfile is
    generic(N: integer := 32);
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

end regfile;

architecture structural of regfile is

    component reg is
        port(
            i_D   : in std_logic_vector(N - 1 downto 0);   -- Data input
            i_WE  : in std_logic; -- Write enable input
            i_CLK : in std_logic; -- Clock input
            i_RST : in std_logic; -- Reset input
            o_Q   : out std_logic_vector(N - 1 downto 0)    -- Data output
        );
    end component;

    component Mux32t1_32 is
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
    end component;

    component decoder is
        port(
            i_Sel	:	in std_logic_vector(4 downto 0);
            o_Dec	:	out std_logic_vector(31 downto 0)
        );
    end component;

    signal s_RDDec  :   std_logic_vector(31 downto 0); -- Holds decoded rd write select
    
    -- 32 RegData signals because manually making 32 individual registers
    -- was easier than tearing my hair out trying to figure out vhdl's array
    -- BS just so I could use a generate
    signal s_RegData0   :   std_logic_vector(31 downto 0);
    signal s_RegData1   :   std_logic_vector(31 downto 0);
    signal s_RegData2   :   std_logic_vector(31 downto 0);
    signal s_RegData3   :   std_logic_vector(31 downto 0);
    signal s_RegData4   :   std_logic_vector(31 downto 0);
    signal s_RegData5   :   std_logic_vector(31 downto 0);
    signal s_RegData6   :   std_logic_vector(31 downto 0);
    signal s_RegData7   :   std_logic_vector(31 downto 0);
    signal s_RegData8   :   std_logic_vector(31 downto 0);
    signal s_RegData9   :   std_logic_vector(31 downto 0);
    signal s_RegData10  :   std_logic_vector(31 downto 0);
    signal s_RegData11  :   std_logic_vector(31 downto 0);
    signal s_RegData12  :   std_logic_vector(31 downto 0);
    signal s_RegData13  :   std_logic_vector(31 downto 0);
    signal s_RegData14  :   std_logic_vector(31 downto 0);
    signal s_RegData15  :   std_logic_vector(31 downto 0);
    signal s_RegData16  :   std_logic_vector(31 downto 0);
    signal s_RegData17  :   std_logic_vector(31 downto 0);
    signal s_RegData18  :   std_logic_vector(31 downto 0);
    signal s_RegData19  :   std_logic_vector(31 downto 0);
    signal s_RegData20  :   std_logic_vector(31 downto 0);
    signal s_RegData21  :   std_logic_vector(31 downto 0);
    signal s_RegData22  :   std_logic_vector(31 downto 0);
    signal s_RegData23  :   std_logic_vector(31 downto 0);
    signal s_RegData24  :   std_logic_vector(31 downto 0);
    signal s_RegData25  :   std_logic_vector(31 downto 0);
    signal s_RegData26  :   std_logic_vector(31 downto 0);
    signal s_RegData27  :   std_logic_vector(31 downto 0);
    signal s_RegData28  :   std_logic_vector(31 downto 0);
    signal s_RegData29  :   std_logic_vector(31 downto 0);
    signal s_RegData30  :   std_logic_vector(31 downto 0);
    signal s_RegData31  :   std_logic_vector(31 downto 0);

    signal s_WE   :   std_logic_vector(31 downto 0);
    
begin
    
    g_Decoder_WSel: decoder
        port map(
            i_Sel   =>  i_WSel,
            o_Dec   =>  s_RDDec
        );

    s_RegData0    <=  x"00000000";
    s_WE(0)   <= i_WE and s_RDDec(0);
    s_WE(1)   <= i_WE and s_RDDec(1);
    s_WE(2)   <= i_WE and s_RDDec(2);
    s_WE(3)   <= i_WE and s_RDDec(3);
    s_WE(4)   <= i_WE and s_RDDec(4);
    s_WE(5)   <= i_WE and s_RDDec(5);
    s_WE(6)   <= i_WE and s_RDDec(6);
    s_WE(7)   <= i_WE and s_RDDec(7);
    s_WE(8)   <= i_WE and s_RDDec(8);
    s_WE(9)   <= i_WE and s_RDDec(9);
    s_WE(10)  <= i_WE and s_RDDec(10);
    s_WE(11)  <= i_WE and s_RDDec(11);
    s_WE(12)  <= i_WE and s_RDDec(12);
    s_WE(13)  <= i_WE and s_RDDec(13);
    s_WE(14)  <= i_WE and s_RDDec(14);
    s_WE(15)  <= i_WE and s_RDDec(15);
    s_WE(16)  <= i_WE and s_RDDec(16);
    s_WE(17)  <= i_WE and s_RDDec(17);
    s_WE(18)  <= i_WE and s_RDDec(18);
    s_WE(19)  <= i_WE and s_RDDec(19);
    s_WE(20)  <= i_WE and s_RDDec(20);
    s_WE(21)  <= i_WE and s_RDDec(21);
    s_WE(22)  <= i_WE and s_RDDec(22);
    s_WE(23)  <= i_WE and s_RDDec(23);
    s_WE(24)  <= i_WE and s_RDDec(24);
    s_WE(25)  <= i_WE and s_RDDec(25);
    s_WE(26)  <= i_WE and s_RDDec(26);
    s_WE(27)  <= i_WE and s_RDDec(27);
    s_WE(28)  <= i_WE and s_RDDec(28);
    s_WE(29)  <= i_WE and s_RDDec(29);
    s_WE(30)  <= i_WE and s_RDDec(30);
    s_WE(31)  <= i_WE and s_RDDec(31);
      
    -- Registers ------------------------------------------------

    Reg_1: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(1),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData1
        );

    Reg_2: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(2),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData2
        );

    Reg_3: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(3),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData3
        );
        
    Reg_4: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(4),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData4
        );

    Reg_5: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(5),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData5
        );

    Reg_6: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(6),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData6
        );

    Reg_7: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(7),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData7
        );

    Reg_8: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(8),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData8
        );

    Reg_9: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(9),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData9
        );

    Reg_10: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(10),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData10
        );

    Reg_11: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(11),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData11
        );
        
    Reg_12: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(12),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData12
        );

    Reg_13: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(13),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData13
        );

    Reg_14: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(14),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData14
        );

    Reg_15: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(15),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData15
        );

    Reg_16: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(16),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData16
        );

    Reg_17: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(17),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData17
        );

    Reg_18: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(18),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData18
        );

    Reg_19: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(19),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData19
        );
        
    Reg_20: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(20),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData20
        );

    Reg_21: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(21),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData21
        );

    Reg_22: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(22),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData22
        );

    Reg_23: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(23),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData23
        );

    Reg_24: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(24),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData24
        );

    Reg_25: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(25),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData25
        );

    Reg_26: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(26),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData26
        );

    Reg_27: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(27),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData27
        );
        
    Reg_28: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(28),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData28
        );

    Reg_29: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(29),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData29
        );

    Reg_30: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(30),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData30
        );

    Reg_31: reg 
        port map(
            i_CLK   =>  i_CLK,
            i_WE    =>  s_WE(31),
            i_RST   =>  i_RST,
            i_D     =>  i_RD,
            o_Q     =>  s_RegData31
        );

    -- End Registers --------------------------------------------

    g_Mux_RS: Mux32t1_32
        port map(
            i_Sel   =>  i_RSSel,
            i_D0    =>  s_RegData0,
            i_D1    =>  s_RegData1,
            i_D2    =>  s_RegData2,
            i_D3    =>  s_RegData3,
            i_D4    =>  s_RegData4,
            i_D5    =>  s_RegData5,
            i_D6    =>  s_RegData6,
            i_D7    =>  s_RegData7,
            i_D8    =>  s_RegData8,
            i_D9    =>  s_RegData9,
            i_D10   =>  s_RegData10,
            i_D11   =>  s_RegData11,
            i_D12   =>  s_RegData12,
            i_D13   =>  s_RegData13,
            i_D14   =>  s_RegData14,
            i_D15   =>  s_RegData15,
            i_D16   =>  s_RegData16,
            i_D17   =>  s_RegData17,
            i_D18   =>  s_RegData18,
            i_D19   =>  s_RegData19,
            i_D20   =>  s_RegData20,
            i_D21   =>  s_RegData21,
            i_D22   =>  s_RegData22,
            i_D23   =>  s_RegData23,
            i_D24   =>  s_RegData24,
            i_D25   =>  s_RegData25,
            i_D26   =>  s_RegData26,
            i_D27   =>  s_RegData27,
            i_D28   =>  s_RegData28,
            i_D29   =>  s_RegData29,
            i_D30   =>  s_RegData30,
            i_D31   =>  s_RegData31,
            o_Out   =>  o_RS
        );

    g_Mux_RT: Mux32t1_32
        port map(
            i_Sel   =>  i_RTSel,
            i_D0    =>  s_RegData0,
            i_D1    =>  s_RegData1,
            i_D2    =>  s_RegData2,
            i_D3    =>  s_RegData3,
            i_D4    =>  s_RegData4,
            i_D5    =>  s_RegData5,
            i_D6    =>  s_RegData6,
            i_D7    =>  s_RegData7,
            i_D8    =>  s_RegData8,
            i_D9    =>  s_RegData9,
            i_D10   =>  s_RegData10,
            i_D11   =>  s_RegData11,
            i_D12   =>  s_RegData12,
            i_D13   =>  s_RegData13,
            i_D14   =>  s_RegData14,
            i_D15   =>  s_RegData15,
            i_D16   =>  s_RegData16,
            i_D17   =>  s_RegData17,
            i_D18   =>  s_RegData18,
            i_D19   =>  s_RegData19,
            i_D20   =>  s_RegData20,
            i_D21   =>  s_RegData21,
            i_D22   =>  s_RegData22,
            i_D23   =>  s_RegData23,
            i_D24   =>  s_RegData24,
            i_D25   =>  s_RegData25,
            i_D26   =>  s_RegData26,
            i_D27   =>  s_RegData27,
            i_D28   =>  s_RegData28,
            i_D29   =>  s_RegData29,
            i_D30   =>  s_RegData30,
            i_D31   =>  s_RegData31,
            o_Out   =>  o_RT
        );
    
end structural;
