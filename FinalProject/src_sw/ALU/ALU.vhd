library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_misc.nor_reduce;

entity ALU is
    generic(N: integer := 32);
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
        o_Ovfl      :   out std_logic
    );
end ALU;

architecture structural of ALU is
    component NbitBarrelShifter is
        port(i_Shift     : in std_logic_vector(4 downto 0);
            i_S         : in std_logic_vector(1 downto 0);--bit 0 is right or left, bit 1 is signed or unsigned
            i_In        : in std_logic_vector(31 downto 0);
            o_O         : out std_logic_vector(31 downto 0));
            
    end component;

    component AdderSubtractor is
        port(
            i_A     :   in std_logic_vector(N-1 downto 0);
            i_B     :   in std_logic_vector(N-1 downto 0);
            i_Sub   :   in std_logic;
            o_S     :   out std_logic_vector(N-1 downto 0);
            o_Cout  :   out std_logic;
            o_Ovfl  :   out std_logic
        );
    end component;

    component OrG_N is
        port(
            i_A     :   in std_logic_vector(N-1 downto 0);
            i_B     :   in std_logic_vector(N-1 downto 0);
            o_Out   :   out std_logic_vector(N-1 downto 0)
        );
    end component;

    component AndG_N is
        port(
            i_A     :   in std_logic_vector(N-1 downto 0);
            i_B     :   in std_logic_vector(N-1 downto 0);
            o_Out   :   out std_logic_vector(N-1 downto 0)
        );
    end component;

    component XorG_N is
        port(
            i_A     :   in std_logic_vector(N-1 downto 0);
            i_B     :   in std_logic_vector(N-1 downto 0);
            o_Out   :   out std_logic_vector(N-1 downto 0)
        );
    end component;

    component Mux_5t1_N is
        port(
            i_A     :   in std_logic_vector(N-1 downto 0);
            i_B     :   in std_logic_vector(N-1 downto 0);
            i_C     :   in std_logic_vector(N-1 downto 0);
            i_D     :   in std_logic_vector(N-1 downto 0);
            i_E     :   in std_logic_vector(N-1 downto 0);
            i_Sel   :   in std_logic_vector(2 downto 0);
            o_Out   :   out std_logic_vector(N-1 downto 0)
        );
    end component;

    component onescomp_N is
		port(
			i_A	: in std_logic_vector(N-1 downto 0);
			o_F	: out std_logic_vector(N-1 downto 0)
		);
	end component;

    component mux2t1_32 is
		port(
			i_S          : in std_logic;
			i_D0         : in std_logic_vector(N-1 downto 0);
			i_D1         : in std_logic_vector(N-1 downto 0);
			o_O          : out std_logic_vector(N-1 downto 0)
		);
	end component;

    signal s_Shift  : std_logic_vector(N-1 downto 0); -- Carries the output of the shifter
    signal s_AddSub : std_logic_vector(N-1 downto 0); -- Carries the sum output of the adder/subtractor
    signal s_OR     : std_logic_vector(N-1 downto 0); -- Carries the output of the OR gates
    signal s_AND    : std_logic_vector(N-1 downto 0); -- Carries the output of the AND gates
    signal s_XOR    : std_logic_vector(N-1 downto 0); -- Carries the output of the XOR gates
    signal s_Mux    : std_logic_vector(N-1 downto 0); -- Carries the output of the 5-to-1 mux
    signal s_MuxInv : std_logic_vector(N-1 downto 0); -- Carries the inverse of the mux output
    signal s_Result : std_logic_vector(N-1 downto 0); -- Carries final result

begin

    g_Shifter: NbitBarrelShifter
        port map(
            i_Shift =>  i_ShiftAmt,
            i_S(0)  =>  i_ShiftDir,
            i_S(1)  =>  i_ShiftType,
            i_In    =>  i_B,
            o_O     =>  s_Shift
        );

    g_AddSub: AdderSubtractor
        port map(
            i_A     =>  i_A,
            i_B     =>  i_B,
            i_Sub   =>  i_Sub,
            o_S     =>  s_AddSub,
            o_Ovfl  =>  o_Ovfl
        );

    g_OR: OrG_N
        port map(
            i_A     =>  i_A,
            i_B     =>  i_B,
            o_Out   =>  s_OR
        );

    g_AND: AndG_N
        port map(
            i_A     =>  i_A,
            i_B     =>  i_B,
            o_Out   =>  s_AND
        );

    g_XOR: XorG_N
        port map(
            i_A     =>  i_A,
            i_B     =>  i_B,
            o_Out   =>  s_XOR
        );

    g_Mux: Mux_5t1_N
        port map(
            i_A     =>  s_AddSub,
            i_B     =>  s_Shift,
            i_C     =>  s_AND,
            i_D     =>  s_OR,
            i_E     =>  s_XOR,
            i_Sel   =>  i_OutSel,
            o_Out   =>  s_Mux
        );

    g_OnesCompN: onescomp_N
        port map(
            i_A =>  s_Mux,
            o_F =>  s_MuxInv
        );

    g_Mux_InvOut: mux2t1_32
        port map(
            i_S     =>  i_InvOut,
            i_D0    =>  s_Mux,
            i_D1    =>  s_MuxInv,
            o_O     =>  s_Result
        );

    o_Output    <=  s_Result;
    o_Zero      <=  nor_reduce(s_Result);   -- use nor_reduce function from std_logic_misc to nor 
                                            -- all of the bits of the result to determine if its zero

end structural;
