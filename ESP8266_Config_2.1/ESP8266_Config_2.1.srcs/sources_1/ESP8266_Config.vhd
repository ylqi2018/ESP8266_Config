----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/26/2017 04:14:34 PM
-- Design Name: 
-- Module Name: ESP8266_Config - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use	IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity ESP8266_Config is
	port (
		clk		:	in	STD_LOGIC;
		rst		:	in	STD_LOGIC;
		rx		:	in	STD_LOGIC;
		tx		:	out	STD_LOGIC
	);
end ESP8266_Config;

architecture Behavioral of ESP8266_Config is
	
component uart
    generic (
        baud                : positive;
        clock_frequency     : positive
    );
    port (  
        clock               :   in  std_logic;
        reset               :   in  std_logic;    
        data_stream_in      :   in  std_logic_vector(7 downto 0);
        data_stream_in_stb  :   in  std_logic;
        data_stream_in_ack  :   out std_logic;
        data_stream_out     :   out std_logic_vector(7 downto 0);
        data_stream_out_stb :   out std_logic;
        tx                  :   out std_logic;
        rx                  :   in  std_logic
    );
end component;

component ila_uart
    PORT (
	    clk : IN STD_LOGIC;
	    
	    probe0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    probe2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	    probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
	    probe4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe5 : IN STD_LOGIC_VECTOR(0 DOWNTO 0)
    );
END component;
	
component WiFi_Receiver_mac
	port (
		clk					:	in	STD_LOGIC;
		rst					:	in	STD_LOGIC;
		enb					:	in	STD_LOGIC;
		data_stream_in_stb	:	in	STD_LOGIC;
		data_stream_in		:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);
		model_cmd			:	out	STD_LOGIC_VECTOR(7 DOWNTO 0);
		rec_cmd_en			:	out	STD_LOGIC				
	);
end component;
	
component WiFi_Setup_Client_St
	port (
		clk					:	in	STD_LOGIC;
		rst					:	in	STD_LOGIC;
		enb					:	in	STD_LOGIC;
		
		data_stream_in_ack	:	in	STD_LOGIC;
		cmd_over			:	in	STD_LOGIC;
		byte_to_tx			:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- uint8, when cmd_start=1, get cmd for upper
	-- ##### get received data from uart and used this to control state machine #####	
		data_stream_rec_stb	:	in	STD_LOGIC;
		data_stream_rec		:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);
	-- ##### send cmds to uart #####
		model_cmd			:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- control which cmd to send
		rec_cmd_en			:	in 	STD_LOGIC;	
		data_stream_send_stb:	out	STD_LOGIC;
		data_stream_send	:	out	STD_LOGIC_VECTOR(7 DOWNTO 0);
			
		cmd_start			:	out	STD_LOGIC;
		model_sel			:	out	STD_LOGIC_VECTOR(7 DOWNTO 0);
		rec_data_en			:	out	STD_LOGIC
		
	);
end component;
	
-- ##### Build an enumerated type for the state machine #####
	type config_states is (
		send_AT,
		wait_OK1,
		send_CWMODE,
		wait_OK2
	);
	
	signal	current_state	:	config_states	:=	send_AT;
	signal	next_state		:	config_states	:=	send_AT;
	
	signal	model_sel		:	STD_LOGIC_VECTOR(7 DOWNTO 0)	:= (others => '0');
		
-- signal related with uart
signal	s_data_stream_in		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	s_data_stream_in_stb	:	STD_LOGIC;
signal	s_data_stream_in_ack	:	STD_LOGIC;	
signal	s_data_stream_out		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	s_data_stream_out_stb	:	STD_LOGIC;	

signal	received_O				:	STD_LOGIC;
signal	received_K				:	STD_LOGIC;
signal	s_received_O				:	STD_LOGIC;
signal	s_received_K				:	STD_LOGIC;

type	CMDString	is	array(natural range<>) of character;
-- ##### config commands #####
	CONSTANT	N1			:	natural		:= 11;
	CONSTANT	ATCWMODE	:	CMDString(0 to N1-1)	:= "AT+CWMODE=3";
	CONSTANT	N2			:	natural		:= 23;
	CONSTANT	ATCWJAP		:	CMDString(0 to N2-1)	:= "AT+CWJAP=""UNT_DRONE"",""""";
	CONSTANT	N3			:	natural		:= 25;
	CONSTANT	ATSTAIP		:	CMDString(0 to N3-1)	:= "AT+CIPSTA=""192.168.43.90""";

signal	index			:	STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	char_index		:	natural	range 0 to N1-1;
signal	byte_to_tx   	:	STD_LOGIC_VECTOR(7 DOWNTO 0);
signal  send_byte       :   STD_LOGIC_VECTOR(7 DOWNTO 0);
signal  cmd_over        :   STD_LOGIC;
signal  length_cmd      :   STD_LOGIC_VECTOR(5 DOWNTO 0);
	
signal	s_enb			:	STD_LOGIC;
signal	s_model_cmd		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	s_rec_cmd_en	:	STD_LOGIC;

signal	cmd_start		:	STD_LOGIC;
--signal	model_sel		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	rec_cmd_en		:	STD_LOGIC;

signal  enb             :   STD_LOGIC;

-- ########################################################################## --
begin	
	
inst_uart: uart
    generic map(
        baud                => 115200,		--: positive;
        clock_frequency     => 100000000 	--: positive
    )
    port map(  
        clock               => clk,						--:   in  std_logic;
        reset               => rst,						--:   in  std_logic;    
        data_stream_in      => send_byte,				--:   in  std_logic_vector(7 downto 0);
        data_stream_in_stb  => s_data_stream_in_stb,	--:   in  std_logic;
        data_stream_in_ack  => s_data_stream_in_ack,	--:   out std_logic;
        data_stream_out     => s_data_stream_out,		--:   out std_logic_vector(7 downto 0);
        data_stream_out_stb => s_data_stream_out_stb,	--:   out std_logic;
        tx                  => tx,						--:   out std_logic; ##### connect to port
        rx                  => rx						--:   in  std_logic ##### cpnnect to port
    );
    
inst_ILA: ila_uart
    PORT map(
        clk     => clk,         --: IN STD_LOGIC;
        
        probe0  	=> s_model_cmd,   --: IN STD_LOGIC_VECTOR(7 DOWNTO 0); 				output of WiFi_Receiver_mac
        probe1(0) 	=> s_data_stream_out_stb,	--: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe2 		=> s_data_stream_out,		--: IN STD_LOGIC_VECTOR(7 DOWNTO 0);	output of uart
        probe3(0) 	=> s_data_stream_in_stb,	--: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe4 		=> send_byte,				--: IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        probe5(0)	=> s_rec_cmd_en				--: IN STD_LOGIC_VECTOR(0 DOWNTO 0);	output of WiFi_Receiver_mac							
        
    );

s_enb <= '1';
    
inst_WiFi_Receiver_mac: WiFi_Receiver_mac
	port map(
		clk					=> clk,						--:	in	STD_LOGIC;
		rst					=> rst,						--:	in	STD_LOGIC;
		enb					=> s_enb,					--:	in	STD_LOGIC;
		data_stream_in_stb	=> s_data_stream_out_stb,	--:	in	STD_LOGIC;
		data_stream_in		=> s_data_stream_out,		--:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);
		model_cmd			=> s_model_cmd,				--:	out	STD_LOGIC_VECTOR(7 DOWNTO 0);
		rec_cmd_en			=> s_rec_cmd_en				--:	out	STD_LOGIC				
	);

enb <= '1';

isnt_WiFi_Setup_Client_St: WiFi_Setup_Client_St
	port map(
		clk					=> clk	,--	:	in	STD_LOGIC;
		rst					=> rst	,--	:	in	STD_LOGIC;
		enb					=> enb	,-- :	in	STD_LOGIC;
		
		data_stream_in_ack	=> s_data_stream_in_ack, --:	in	STD_LOGIC;
		cmd_over			=> cmd_over, 	--:	in	STD_LOGIC;
		byte_to_tx			=> byte_to_tx,	--:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- uint8, when cmd_start=1, get cmd for upper
	-- ##### get received data from uart and used this to control state machine #####	
		data_stream_rec_stb	=> s_data_stream_in_stb, --:	in	STD_LOGIC;
		data_stream_rec		=> s_data_stream_in, --:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);
	-- ##### send cmds to uart #####
		model_cmd			=> s_model_cmd,	--:	in	STD_LOGIC_VECTOR(7 DOWNTO 0);	-- control which cmd to send
		rec_cmd_en			=> s_rec_cmd_en,	--:	in 	STD_LOGIC;	
		data_stream_send_stb=> s_data_stream_in_stb, --:	out	STD_LOGIC;
		data_stream_send	=> s_data_stream_in,	--:	out	STD_LOGIC_VECTOR(7 DOWNTO 0);
			
		cmd_start			=> cmd_start, --:	out	STD_LOGIC;
		model_sel			=> model_sel,	--:	out	STD_LOGIC_VECTOR(7 DOWNTO 0);
		rec_data_en			=> rec_data_en	--:	out	STD_LOGIC
		
	);
-- ###################################################################
    
cmd_send_proc: process(clk, rst)
	begin
		if(rst = '1') then
			index	<= (others => '0');
		elsif(clk'event and clk = '1') then
			char_index <= conv_integer(index);
			if(cmd_start = '1') then
				case model_sel is
					when x"01" => 	-- send ATCWMODE
						length_cmd	<= conv_std_logic_vector(N1, 6);
						byte_to_tx	<= std_logic_vector(to_unsigned(character'pos(ATCWMODE(char_index)), 8));

					when x"02" => 	-- send ATCWJAP
						length_cmd	<= conv_std_logic_vector(N2, 6);
						byte_to_tx	<= std_logic_vector(to_unsigned(character'pos(ATCWJAP(char_index)), 8));
					
					when x"03" => 	-- send ATCWJAP
						length_cmd	<= conv_std_logic_vector(N3, 6);
						byte_to_tx	<= std_logic_vector(to_unsigned(character'pos(ATSTAIP(char_index)), 8));
														
					when others =>
						length_cmd	<= conv_std_logic_vector(N3, 6);
						byte_to_tx	<= (others => '0');
				end case;
					
				if(s_data_stream_in_ack = '1') then		-- when s_data_stream_in_ack='1', means that finish sending one byte
					if(index < length_cmd-1) then
						index <= index + 1;
						cmd_over <= '0';
					else
						index <= (others => '0');
						cmd_over <= '1';
					end if;
				end if;
			end if;			
		end if;
	end process cmd_send_proc;
    
end Behavioral;
