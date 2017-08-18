----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/16/2017 04:00:32 PM
-- Design Name: 
-- Module Name: TOP - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
	port (
		clk		:	in	STD_LOGIC;
		rst		:	in	STD_LOGIC;
		tx		:	out	STD_LOGIC;	
		rx		:	in	STD_LOGIC
	);
end TOP;

architecture Behavioral of TOP is

-- #################### Components #####################
	component receive_OK
	port ( 
		clk                               :   IN    std_logic;
		reset                             :   IN    std_logic;
		clk_enable                        :   IN    std_logic;
		data_stream_rec_stb               :   IN    std_logic;
		data_stream_rec                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
		ce_out                            :   OUT   std_logic;
		model_cmd                         :   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
		rec_cmd_en                        :   OUT   std_logic
	);
	end component;

	component Config_Client
	port ( 
		clk                               :   IN    std_logic;
		reset                             :   IN    std_logic;
		clk_enable                        :   IN    std_logic;
		data_stream_in_ack                :   IN    std_logic;
		rec_cmd_en                        :   IN    std_logic;
		model_cmd                         :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
		ce_out                            :   OUT   std_logic;
		cmd_start                         :   OUT   std_logic;
		model_sel                         :   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
		data_stream_send_stb              :   OUT   std_logic;
		data_stream_send                  :   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
	);
	end component;		

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
	
    component ila_top
    PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe2 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe4 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END component;	
	
-- #################### Signals #####################
signal	s_clk_enable				:	STD_LOGIC;
signal	s_data_stream_send_stb    	:	STD_LOGIC;
signal	s_data_stream_send        	:	STD_LOGIC_VECTOR(7 DOWNTO 0);  -- uint8
signal	s_data_stream_in_ack		:	STD_LOGIC;
signal	s_data_stream_out     		:   STD_LOGIC_VECTOR(7 downto 0);
signal	s_data_stream_out_stb 		:   STD_LOGIC;
signal	s_ce_out					:   STD_LOGIC;
signal	s_ce_out1					:   STD_LOGIC;
signal	s_model_cmd					:	STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ufix4
signal	s_model_sel					:	STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ufix4
signal	s_cmd_start					:	std_logic;
signal  s_rec_cmd_en                :   std_logic;



begin
	
s_clk_enable	<= '1';

inst_uart: uart
	generic map(
	    baud                => 115200,		--: positive;
	    clock_frequency     => 100000000	--: positive
	)                
	port map(                   
	    clock               => clk,			--:   in  std_logic;
	    reset               => rst,			--:   in  std_logic;    
	    data_stream_in      => s_data_stream_send,		--:   in  std_logic_vector(7 downto 0);
	    data_stream_in_stb  => s_data_stream_send_stb,	--:   in  std_logic;
	    data_stream_in_ack  => s_data_stream_in_ack,	--:   out std_logic;
	    data_stream_out     => s_data_stream_out,		--:   out std_logic_vector(7 downto 0);
	    data_stream_out_stb => s_data_stream_out_stb,	--:   out std_logic;
	    tx                  => tx,						-- connect to the port of TOP :   out std_logic;
	    rx                  => rx						--:   in  std_logic
	);
	
inst_Config_Client: Config_Client
	port map( 
		clk                               => clk,					--:   IN    std_logic;
		reset                             => rst,					--:   IN    std_logic;
		clk_enable                        => s_clk_enable,			--:   IN    std_logic;
		data_stream_in_ack                => s_data_stream_in_ack,	--:   IN    std_logic;
		rec_cmd_en                        => s_rec_cmd_en,			--:   IN    std_logic;
		model_cmd                         => s_model_cmd,			--:   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
		ce_out                            => s_ce_out,				--:   OUT   std_logic;
		cmd_start                         => s_cmd_start,			--:   OUT   std_logic;
		model_sel                         => s_model_sel,			--:   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
		data_stream_send_stb              => s_data_stream_send_stb,	--:   OUT   std_logic;
		data_stream_send                  => s_data_stream_send			--:   OUT   std_logic_vector(7 DOWNTO 0)  -- uint8
	);	

inst_receive_OK: receive_OK
	port map( 
		clk                               => clk,					--:   IN    std_logic;
		reset                             => rst,					--:   IN    std_logic;
		clk_enable                        => s_clk_enable,			--:   IN    std_logic;
		data_stream_rec_stb               => s_data_stream_out_stb,	--:   IN    std_logic;
		data_stream_rec                   => s_data_stream_out,	 	--:   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
		ce_out                            => s_ce_out1,				--:   OUT   std_logic;
		model_cmd                         => s_model_cmd,			--:   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
		rec_cmd_en                        => s_rec_cmd_en			--:   OUT   std_logic
	);	
	
inst_ila_top: ila_top
    PORT map(
        clk 		=> clk	,	--: IN STD_LOGIC;
        probe0(0)	=> s_data_stream_in_ack	,	--: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe1(0)	=> s_data_stream_send_stb ,	--: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe2 		=> s_data_stream_send	,	--: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        probe3(0)	=> s_data_stream_out_stb	,	--: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe4 		=> s_data_stream_out		--: IN STD_LOGIC_VECTOR(7 DOWNTO 0)
    );

end Behavioral;
