
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;	-- Using arithmetic functions with Signed or Unsigned values


entity GPS_Config is
	port(
		clk	:	in	STD_LOGIC;
		rst	:	in	STD_LOGIC;
		rx	:	in	STD_LOGIC;
		tx	:	out	STD_LOGIC	
	);
end GPS_Config;

architecture Behavioral of GPS_Config is

-- ##### Components #####
component uart is
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

-- ##### type define #####
type tstring is array(natural range<>) of character;
	
-- ##### config cmds #####
CONSTANT N1	:	natural	:= 49;
CONSTANT OUTPUT_SET		:	tstring(0 to N1-1) := "$PMTK314,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29";
CONSTANT N2	:	natural	:= 15;
CONSTANT UPDATE_RATE	:	tstring(0 to N2-1) := "$PMTK220,100*2F";
CONSTANT N3 :	natural	:= 18;
CONSTANT BAUDRATE		:	tstring(0 to N3-1) := "$PMTK251,115200*1F";

-- ##### signals #####
signal	s_data_stream_in	:	std_logic_vector(7 downto 0);
signal	s_data_stream_in_stb:	std_logic;
signal	s_data_stream_in_ack:	std_logic;

signal	index		:	STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	model_sel	:	STD_LOGIC_VECTOR(2 DOWNTO 0);
signal	length_sig	:	STD_LOGIC_VECTOR(6 DOWNTO 0)	:= (others => '0');
signal	byte_to_tx	:	STD_LOGIC_VECTOR(7 DOWNTO 0);
signal	char_index	:	integer	range 0 to N1-1;


-- ################################################################ --
begin
-- ##### instantiate ##### --
inst_uart: uart
generic map(
	baud                => 115200,					--: positive;
	clock_frequency     => 100000000				--: positive
	)
port map(
	clock               => clk,						--:   in  std_logic;
	reset               => rst,						--:   in  std_logic;    
	data_stream_in      => s_data_stream_in,		--:   in  std_logic_vector(7 downto 0);
	data_stream_in_stb  => s_data_stream_in_stb,	--:   in  std_logic;
	data_stream_in_ack  => s_data_stream_in_ack,	--:   out std_logic;
	data_stream_out     => 					--:   out std_logic_vector(7 downto 0);
	data_stream_out_stb => 					--:   out std_logic;
	tx                  => tx,						--:   out std_logic;
	rx                  => 					--:   in  std_logic
	);

-- ##### send cmd process #####
send_proc: process(clk, rst)
	begin
		if(rst = '1') then
			index	<= (others => '0');
		elsif(clk'event and clk = '1') then
			case model_sel is 
				when "000" => 
					send_byte <= x"24";
					
				when "001" => 
					length_sig	<= conv_std_logic_vector(N1, 7);
					byte_to_tx	<= std_logic_vector(to_unsigned(character'pos(OUTPUT_SET(char_index)),8));
						
				when "010" => 
					length_sig	<= conv_std_logic_vector(N2,7);
					byte_to_tx	<= std_logic_vector(to_unsigned(character'pos(UPDATA_RATE(char_index)),8));	
						
				when "011" => 
					length_sig	<= conv_std_logic_vector(N3,7);
                    byte_to_tx	<= std_logic_vector(to_unsigned(character'pos(BAUDRATE(char_index)),8));   
                    	
				when others =>
					length_sig	<= conv_std_logic_vector(N1,7);
					byte_to_tx	<= (others=>'0');
			end case;
			
			char_index	<= conv_integer(index);
					
			if(index < length_sig) then		-- index <= N-1
				send_byte <= byte_to_tx;
				s_data_stream_in_stb <= '1';
				if(s_data_stream_in_ack = '1') then
					s_data_stream_in_stb <= '0';
					index <= index + 1;
				end if;
				cmd_over <= '0';
			elsif(index = length_sig) then	-- index = N
				send_byte <= x"0D";
				s_data_stream_in_stb <= '1';
				if(s_data_stream_in_ack = '1') then
					s_data_stream_in_stb <= '0';
					index	<= index + 1;
				end if;
				cmd_over <= '0';
			elsif(index = length_sig+1) then
				send_byte <= x"0A";
				s_data_stream_in_stb <= '0';
				if(s_data_stream_in_ack = '1') then
					s_data_stream_in_stb <= '0';
					index <= (others => '0');
					char_index <= '0';
					if(model_sel <= 3) then
						model_sel <= model_sel + 1;
					else
						model_sel <= model_sel;
					end if;
				end if;
				cmd_over <= '0';
			end if;				
		end if;	-- end clk
	end process send_proc;
  
end Behavioral;
