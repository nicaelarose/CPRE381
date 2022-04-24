-------------------------------------------------------------------------
-- Nicaela Rose
-- Department of Software Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_dmem.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for the
-- edge-triggered flip-flop with parallel access and reset.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 11/25/19 by H3:Changed name to avoid name conflict with Quartus
--          primitives.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_dmem is
  generic(gCLK_HPER   : time := 50 ns);
end tb_dmem;

architecture behavior of tb_dmem is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;


  component mem
	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);
    port 
	(
		clk		: in std_logic;
		addr	: in std_logic_vector((ADDR_WIDTH-1) downto 0);
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
  end component;

  -- Temporary signals to connect to the dff component.
  signal s_clk, s_we: std_logic;
  signal s_data, s_q : std_logic_vector((31) downto 0);
  signal s_addr : std_logic_vector((9) downto 0);
begin

  dmem: mem
  port map(s_clk, s_addr, s_data, s_we, s_q);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_clk <= '0';
    wait for gCLK_HPER;
    s_clk <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
	
	s_addr	<=	"0000000000";
	s_data	<=	x"00000001";
	s_we	<=	'0';
	wait for cCLK_PER; 	-- Read 0, don't write
	s_addr	<=	"0000000001";
	wait for cCLK_PER; 	-- Read 1, don't write
	s_addr	<=	"0000000010";
	wait for cCLK_PER; 	-- Read 2, don't write
	s_addr	<=	"0000000011";
	wait for cCLK_PER; 	-- Read 3, don't write
	s_addr	<=	"0000000100";
	wait for cCLK_PER; 	-- Read 4, don't write
	s_addr	<=	"0000000101";
	wait for cCLK_PER; 	-- Read 5, don't write
	s_addr	<=	"0000000110";
	wait for cCLK_PER; 	-- Read 6, don't write
	s_addr	<=	"0000000111";
	wait for cCLK_PER; 	-- Read 7, don't write
	s_addr	<=	"0000001000";
	wait for cCLK_PER; 	-- Read 8, don't write
	s_addr	<=	"0000001001";
	wait for cCLK_PER; 	-- Read 9, don't write
	
	s_we	<= '0';
	s_addr	<=	"0000000000";
	wait for cCLK_PER; 	-- Read 0, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100000000";
	wait for cCLK_PER; 	-- Write to 0x100
	
	s_we	<= '0';
	s_addr	<=	"0000000001";
	wait for cCLK_PER; 	-- Read 1, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100000001";
	wait for cCLK_PER; 	-- Write to 0x101
	
	s_we	<= '0';
	s_addr	<=	"0000000010";
	wait for cCLK_PER; 	-- Read 2, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100000010";
	wait for cCLK_PER; 	-- Write to 0x102
	
	s_we	<= '0';
	s_addr	<=	"0000000011";
	wait for cCLK_PER; 	-- Read 3, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100000011";
	wait for cCLK_PER; 	-- Write to 0x103
	
	s_we	<= '0';
	s_addr	<=	"0000000100";
	wait for cCLK_PER; 	-- Read 4, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100000100";
	wait for cCLK_PER; 	-- Write to 0x104
	
	s_we	<= '0';
	s_addr	<=	"0000000101";
	wait for cCLK_PER; 	-- Read 5, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100000101";
	wait for cCLK_PER; 	-- Write to 0x105
	
	s_we	<= '0';
	s_addr	<=	"0000000110";
	wait for cCLK_PER; 	-- Read 6, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100000110";
	wait for cCLK_PER; 	-- Write to 0x106
	
	s_we	<= '0';
	s_addr	<=	"0000000111";
	wait for cCLK_PER; 	-- Read 7, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100000111";
	wait for cCLK_PER; 	-- Write to 0x107
	
	s_we	<= '0';
	s_addr	<=	"0000001000";
	wait for cCLK_PER; 	-- Read 8, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100001000";
	wait for cCLK_PER; 	-- Write to 0x108
	
	s_we	<= '0';
	s_addr	<=	"0000001001";
	wait for cCLK_PER; 	-- Read 9, don't write
	s_we	<= '1';
	s_data	<= s_q;
	s_addr <= "0100001001";
	wait for cCLK_PER; 	-- Write to 0x109
	
	s_addr	<=	"0000000000";
	s_data	<=	x"00000001";
	s_we	<=	'0';
	wait for cCLK_PER; 	-- Read 0x100, don't write
	s_addr	<=	"0100000001";
	wait for cCLK_PER; 	-- Read 0x101, don't write
	s_addr	<=	"0100000010";
	wait for cCLK_PER; 	-- Read x102, don't write
	s_addr	<=	"0100000011";
	wait for cCLK_PER; 	-- Read x103, don't write
	s_addr	<=	"0100000100";
	wait for cCLK_PER; 	-- Read x104, don't write
	s_addr	<=	"0100000101";
	wait for cCLK_PER; 	-- Read x105, don't write
	s_addr	<=	"0100000110";
	wait for cCLK_PER; 	-- Read x106, don't write
	s_addr	<=	"0100000111";
	wait for cCLK_PER; 	-- Read x107, don't write
	s_addr	<=	"0100001000";
	wait for cCLK_PER; 	-- Read x108, don't write
	s_addr	<=	"0100001001";
	wait for cCLK_PER; 	-- Read x109, don't write
	
	
    wait;
  end process;
  
end behavior;
