library IEEE;
use IEEE.std_logic_1164.all;

entity pl_reg_upd is 
	port(
		i_clk:          in std_logic;
       		i_rst:          in std_logic;
		
		i_stall:	in std_logic;	-- prevents writing of new values
		i_IF_flush:	in std_logic;	-- removes stored values entirely

		
		
		
		


	);
end pl_reg_upd;


architecture tb of pl_reg_upd is


	component if_id is
		port(
 		        i_clk:  in std_logic;
  	      		i_rst:  in std_logic;
        		i_PC:   in std_logic_vector(31 downto 0);
		        i_IM:   in std_logic_vector(31 downto 0);
		        o_PC:   out std_logic_vector(31 downto 0);
   		        o_IM:   out std_logic_vector(31 downto 0)
   		 );
	end component
	

	component id_ex is
		port(
			a
		); 
	end component

	

    component ex_mem is
	port(
        i_clk:          in std_logic;
        i_rst:          in std_logic;

        i_JAL:          in std_logic;
        i_MemRead:      in std_logic;
        i_MemtoReg:     in std_logic;
        i_MemWrite:     in std_logic;
        i_RegWrite:     in std_logic;

        i_ALUZero:      in std_logic;
        i_ALUResult:    in std_logic_vector(31 downto 0);
        i_RFD2:         in std_logic_vector(31 downto 0);   -- RegFile Data2
        i_Funct:        in std_logic_vector(5 downto 0);    -- Instr[5:0]
        
        o_JAL:          out std_logic;
        o_MemRead:      out std_logic;
        o_MemtoReg:     out std_logic;
        o_MemWrite:     out std_logic;
        o_RegWrite:     out std_logic;

        o_ALUZero:      out std_logic;
        o_ALUResult:    out std_logic_vector(31 downto 0);
        o_RFD2:         out std_logic_vector(31 downto 0);
        o_Funct:        out std_logic_vector(5 downto 0)
	);
	end component

	component mem_wb is
		port(
			a
		); 
	end component
begin



end tb;

