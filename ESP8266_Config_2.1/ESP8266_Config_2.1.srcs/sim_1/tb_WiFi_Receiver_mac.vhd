----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/31/2017 12:11:02 PM
-- Design Name: 
-- Module Name: tb_WiFi_Receiver_mac - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use STD.TEXTIO.ALL;
use	IEEE.STD_LOGIC_TEXTIO.ALL;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_WiFi_Receiver_mac is

end tb_WiFi_Receiver_mac;

architecture Behavioral of tb_WiFi_Receiver_mac is

----------------------------------------------------------------------
-- Delcare the component under test
----------------------------------------------------------------------
	component WiFi_Receiver_mac
	port (
		clk					:	in	STD_LOGIC;
		rst					:	in	STD_LOGIC;
		enb					:	in	STD_LOGIC;
		data_stream_in_stb	:	in	STD_LOGIC;
		data_stream_in		:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);
		model_cmd			:	out	STD_LOGIC_VECTOR(3 DOWNTO 0);
		rec_cmd_en			:	out	STD_LOGIC				
	);
	end component;

CONSTANT	clock_period	:	time	:= 10 ns;

-- ########## Input signals ##########
signal	clk					:	STD_LOGIC;
signal	rst					:	STD_LOGIC;
signal	enb					:	STD_LOGIC;
signal	data_stream_in_stb	:	STD_LOGIC;
signal	data_stream_in		:	STD_LOGIC_VECTOR(7 DOWNTO 0);

-- ########## Input signals ##########
signal	model_cmd			:	STD_LOGIC_VECTOR(3 DOWNTO 0);
signal	rec_cmd_en			:	STD_LOGIC;	

----------------------------------------------------------------------
-- Testbench Internal signals
----------------------------------------------------------------------
file	file_input	:	text;
file	file_output	:	text;


begin

enb <= '1';

clk_proc: process
	begin
		clk <= '0';
		wait for clock_period/2;
		clk <= '1';
		wait for clock_period/2;
	end process clk_proc;
	
rst_proc: process
	begin
		rst <= '1';
		wait for 10*clock_period;
		rst <= '0';
		wait;
	end process rst_proc;

----------------------------------------------------------------------
-- Instantiate and Map UUT
----------------------------------------------------------------------
inst_WiFi_Receiver_mac: WiFi_Receiver_mac
	port map(
		clk					=>	clk					,--:	in	STD_LOGIC;
		rst					=>	rst					,--:	in	STD_LOGIC;
		enb					=>	enb					,--:	in	STD_LOGIC;
		data_stream_in_stb	=>	data_stream_in_stb	,--:	in	STD_LOGIC;
		data_stream_in		=>	data_stream_in		,--:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);
		model_cmd			=>	model_cmd			,--:	out	STD_LOGIC_VECTOR(7 DOWNTO 0);
		rec_cmd_en			=>	rec_cmd_en			 --:	out	STD_LOGIC				
	);

----------------------------------------------------------------------
-- This procedure reads the file input vectors.txt which is located
-- in simulation project area.
-- In will read the data in and send it to the component too perform the operations.
-- The result is written to the output_result.txt file
-- located in the same directory
----------------------------------------------------------------------
textio_proc: process
		variable	inLine			:	line;
		variable	outLine			:	line;
		variable	stream_in		:	character;
		variable	stream_in_stb	:	STD_LOGIC;
		variable	v_space			:	character;
	begin
	   wait for 150ns;
		file_open(file_input, "D:\Vivado_Program_Files\20170711_ESP8266\ESP8266_Config_2.1\ESP8266_Config_2.1.srcs\sim_1\inputs.txt", read_mode);
		file_open(file_output, "outputs.txt", write_mode);
			
		while not endfile(file_input) loop
			readline(file_input, inLine);
			read(inLine, stream_in_stb);
			read(inLine, v_space);		-- read in the space character
			read(inLine, stream_in);
			
		-- pass the variable to a signal to allow the UUT to use it
			data_stream_in_stb	<= stream_in_stb;
			data_stream_in		<= conv_std_logic_vector(character'pos(stream_in), 8);			
			wait for clock_period;	
--			data_stream_in_stb	<= stream_in_stb;
--			data_stream_in		<= conv_std_logic_vector(character'pos(stream_in), 8);		
--			wait for 10*clock_period;	
		end loop;
		
		file_close(file_input);
		file_close(file_output);		
		
		wait;
	end process;



end Behavioral;
