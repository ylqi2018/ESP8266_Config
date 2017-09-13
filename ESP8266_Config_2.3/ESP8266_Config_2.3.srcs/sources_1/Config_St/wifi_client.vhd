
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity wifi_client is
	port (
		clk					:	in	STD_LOGIC;
		rst					:	in	STD_LOGIC;
		rx					:	in	STD_LOGIC;	
		tx					:	out	STD_LOGIC
	);
end wifi_client;

architecture Behavioral of wifi_client is

-- ##### Components #####
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


	component ESP8266_Config
	port( 
		clk                               :   IN    std_logic;
		reset                             :   IN    std_logic;
		clk_enable                        :   IN    std_logic;
		data_stream_in_ack                :   IN    std_logic;
		cmd_over                          :   IN    std_logic;
		byte_to_tx                        :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
		data_stream_out_stb               :   IN    std_logic;
		data_stream_out                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
		rec_cmd_en                        :   IN    std_logic;
		model_cmd                         :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
		ce_out                            :   OUT   std_logic;
		data_stream_send_stb              :   OUT   std_logic;
		data_stream_send                  :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
		cmd_start                         :   OUT   std_logic;
		model_sel                         :   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
		rec_data_en                       :   OUT   std_logic
	);
	end component;

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

signal	s_clk_enable				:	STD_LOGIC;
signal	s_data_stream_send_stb    	:	STD_LOGIC;
signal	s_data_stream_send        	:	STD_LOGIC_VECTOR(7 DOWNTO 0);  -- uint8
signal	s_data_stream_in_ack		:	STD_LOGIC;
signal	s_data_stream_out     		:   STD_LOGIC_VECTOR(7 downto 0);
signal	s_data_stream_out_stb 		:   STD_LOGIC;

signal	s_model_cmd					:	STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ufix4
signal  s_rec_cmd_en                :   std_logic;	

type tstring	is array(natural range<>) of character;

-- ##### Actural Command ##### @20170907
constant N1 			: natural := 11;
constant AT_CWMODE 		: tstring(0 to N1-1) := "AT+CWMODE=3";
constant N2 			: natural := 23;
constant AT_CWJAP_Joint : tstring(0 to N2-1) := "AT+CWJAP=""UNT_DRONE"",""""";
constant N3 			: natural := 25;
constant AT_STATIC_IP 	: tstring(0 to N3-1) := "AT+CIPSTA=""192.168.43.90""";


-- ##### Test Command #####	@20170907
--constant N1 			: natural := 11;
--constant AT_CWMODE 		: tstring(0 to N1-1) := "AT+CWMODE=3";
--constant N2 			: natural := 2;
--constant AT_CWJAP_Joint : tstring(0 to N2-1) := "AT";
--constant N3 			: natural := 6;
--constant AT_STATIC_IP 	: tstring(0 to N3-1) := "AT+RST";


--constant N1 			: natural := 6;
--constant AT_CWMODE 		: tstring(0 to N1-1) := "AT+RST";
--constant N2 			: natural := 2;
--constant AT_CWJAP_Joint : tstring(0 to N2-1) := "AT";
--constant N3 			: natural := 11;
--constant AT_STATIC_IP 	: tstring(0 to N3-1) := "AT+CWMODE=3";

--constant N1 			: natural := 11;
--constant AT_CWMODE 		: tstring(0 to N1-1) := "AT+CWMODE=3";
--constant N2 			: natural := 11;
--constant AT_CWJAP_Joint : tstring(0 to N2-1) := "AT+CWMODE=3";
--constant N3 			: natural := 11;
--constant AT_STATIC_IP 	: tstring(0 to N3-1) := "AT+CWMODE=3";
-- ##### End test part #####


signal	cnt_cmd			: STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	s_cmd_over		: STD_LOGIC;
signal 	char_index		: natural range 0 to N3-1;

signal  length_sig      : std_logic_vector(5 downto 0);

signal	s_model_sel		: std_logic_vector(3 DOWNTO 0);  -- ufix4
signal	s_cmd_start		: std_logic;	
signal	byte_to_tx		: std_logic_vector(7 DOWNTO 0);



-- ########################################################################## --
begin
	
send_cmd: process(rst, clk)
	begin
		if(rst = '1') then
			cnt_cmd		<= (others => '0');
			s_cmd_over	<= '0';
			char_index	<= 0;
		elsif(clk'event and clk = '1') then
			char_index	<= conv_integer(cnt_cmd);
			if(s_cmd_start = '1') then
				case s_model_sel is
					when "0001" =>
						length_sig	<=	conv_std_logic_vector(N1, 6);
						byte_to_tx	<=	std_logic_vector(to_unsigned(character'pos(AT_CWMODE(char_index)), 8));
							
					when "0010" =>
						length_sig	<=	conv_std_logic_vector(N2, 6);
						byte_to_tx	<=	std_logic_vector(to_unsigned(character'pos(AT_CWJAP_Joint(char_index)), 8));
							
					when "0011" =>
						length_sig	<=	conv_std_logic_vector(N3, 6);
						byte_to_tx	<=	std_logic_vector(to_unsigned(character'pos(AT_STATIC_IP(char_index)), 8));
				
					when others =>
						length_sig	<=	conv_std_logic_vector(N1, 6);
						byte_to_tx	<=	(others => '0');
				end case;
				if(s_data_stream_in_ack = '1') then
					if(cnt_cmd < length_sig-1) then
						cnt_cmd		<= cnt_cmd + 1;
						s_cmd_over	<= '0';
					else
						cnt_cmd		<= (others => '0');
						s_cmd_over	<= '1';
					end if;
				end if;	-- end of if(data_stream_in_ack = '1') then
			end if;	-- end of cmd_start = '1';
		end if;	-- end of clk'event and clk = '1'	
	end process send_cmd;	

s_clk_enable	<= '1';

-- ##### instance of uart #####
inst_uart: uart
	generic map(
	    baud                => 115200,		--: positive;
	    clock_frequency     => 100000000	--: positive
	)                
	port map(                   
	    clock               => clk,						--:   in  std_logic;
	    reset               => rst,						--:   in  std_logic;    
	    data_stream_in      => s_data_stream_send,		--:   in  std_logic_vector(7 downto 0);
	    data_stream_in_stb  => s_data_stream_send_stb,	--:   in  std_logic;
	    data_stream_in_ack  => s_data_stream_in_ack,	--:   out std_logic;
	    data_stream_out     => s_data_stream_out,		--:   out std_logic_vector(7 downto 0);
	    data_stream_out_stb => s_data_stream_out_stb,	--:   out std_logic;
	    tx                  => tx,						-- connect to the port of TOP :   out std_logic;
	    rx                  => rx						--:   in  std_logic
	);

-- ##### instance of receiver #####
inst_receive_OK: receive_OK
	port map( 
		clk                               => clk,					--:   IN    std_logic;
		reset                             => rst,					--:   IN    std_logic;
		clk_enable                        => s_clk_enable,			--:   IN    std_logic;
		data_stream_rec_stb               => s_data_stream_out_stb,	--:   IN    std_logic;
		data_stream_rec                   => s_data_stream_out,	 	--:   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
		ce_out                            => open,				--:   OUT   std_logic;
		model_cmd                         => s_model_cmd,			--:   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
		rec_cmd_en                        => s_rec_cmd_en			--:   OUT   std_logic
	);


-- ##### instance #####
inst_ESP8266_Config: ESP8266_Config
	PORT map( 
		clk                 	=> clk,								--:   IN    std_logic;
		reset               	=> rst,								--:   IN    std_logic;
		clk_enable          	=> s_clk_enable,					--:   IN    std_logic;
		data_stream_in_ack  	=> s_data_stream_in_ack,			--:   IN    std_logic;
		cmd_over            	=> s_cmd_over,						--:   IN    std_logic;
		byte_to_tx          	=> byte_to_tx,						--:   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
		data_stream_out_stb 	=> s_data_stream_out_stb,			--:   IN    std_logic;
		data_stream_out     	=> s_data_stream_out,				--:   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
		rec_cmd_en          	=> s_rec_cmd_en,					--:   IN    std_logic;
		model_cmd           	=> s_model_cmd,						--:   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
		ce_out              	=> open,							--:   OUT   std_logic;
		data_stream_send_stb	=> s_data_stream_send_stb,			--:   OUT   std_logic;
		data_stream_send    	=> s_data_stream_send,				--:   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
		cmd_start           	=> s_cmd_start,						--:   OUT   std_logic;
		model_sel           	=> s_model_sel,						--:   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
		rec_data_en         	=> open								--:   OUT   std_logic
	);

end Behavioral;
