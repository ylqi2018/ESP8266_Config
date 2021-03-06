
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GPS_top is
	port(
		clk		:	in	STD_LOGIC;
		rst		:	in	STD_LOGIC;
	-- ##### inputs #####
		rx		:	in	STD_LOGIC;
	-- ##### outputs #####
		tx		:	out	STD_LOGIC
	);
end GPS_top;

architecture Behavioral of GPS_top is

-- ##### components #####
component GPS_Config is
	port(
		clk	:	in	STD_LOGIC;
		rst	:	in	STD_LOGIC;
		rx	:	in	STD_LOGIC;
		tx	:	out	STD_LOGIC	
	);
end component;

component GPS_REC is
    Port ( 
		clk 				: in STD_LOGIC;
		rst 				: in STD_LOGIC;
		data_in 			: in STD_LOGIC;
--		data_out			: out STD_LOGIC;
		data_out_en_GPS 	: out std_logic;
		data_lati_val_out 	: out std_logic_vector(31 downto 0);
		data_long_val_out 	: out std_logic_vector(31 downto 0);
		GPS_led_valid     	: out std_logic
	);
end component;

component ila_GPS_data IS
    PORT (
        clk : IN STD_LOGIC;
        probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END component;




signal	s_data_out_en_GPS	:	std_logic;
signal	s_data_lati_val_out	:	std_logic_vector(31 downto 0);
signal	s_data_long_val_out	:	std_logic_vector(31 downto 0);
signal	s_GPS_led_valid		:	std_logic;
	

begin

inst_GPS_Config: GPS_Config
	port map(
		clk	=> clk,		--:	in	STD_LOGIC;
		rst	=> rst,		--:	in	STD_LOGIC;
		rx	=> rx,	--rx,		--:	in	STD_LOGIC;	Actually, I will not use the data from here
		tx	=> tx		--:	out	STD_LOGIC	Configurate command send through this port
	);

inst_GPS_REC: GPS_REC
    Port map( 
		clk 				=> clk,					--: in STD_LOGIC;
		rst 				=> rst,					--: in STD_LOGIC;
		data_in 			=> rx,					--: in STD_LOGIC;
--		data_out			=> 						--: out STD_LOGIC;
		data_out_en_GPS 	=> s_data_out_en_GPS,	--: out std_logic;
		data_lati_val_out 	=> s_data_lati_val_out,	--: out std_logic_vector(31 downto 0);
		data_long_val_out 	=> s_data_long_val_out,	--: out std_logic_vector(31 downto 0);
		GPS_led_valid     	=> s_GPS_led_valid		--: out std_logic
	);

inst_ila_GPS_data: ila_GPS_data
    PORT map(
        clk         => clk,					--: IN STD_LOGIC;
        probe0(0)   => s_data_out_en_GPS,	--: IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe1      => s_data_lati_val_out,	--: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        probe2      => s_data_long_val_out	--: IN STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

end Behavioral;
