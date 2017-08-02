----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/23/2017 01:32:03 PM
-- Design Name: 
-- Module Name: tb_ESP8266_ClientConfig - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_ESP8266_ClientConfig is
--  Port ( );
end tb_ESP8266_ClientConfig;

architecture Behavioral of tb_ESP8266_ClientConfig is

-- ##### COMPONENT #####
    COMPONENT ESP8266_ClientConfig IS
    PORT (
        clk		:	in	STD_LOGIC;
        rst		:	in	STD_LOGIC;
        rx		:	in	STD_LOGIC;
        tx		:	out	STD_LOGIC
    );
    END COMPONENT;

-- signals
signal  clk     :   STD_LOGIC;
signal  rst     :   STD_LOGIC;
signal  rx      :   STD_LOGIC := '0';
signal  tx      :   STD_LOGIC;

-- constant
constant    clk_period  :   time    := 10 ns;
    
begin

clk_proc: process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
rst_proc: process
    begin
        rst <= '1';
        wait for 10*clk_period;
        rst <= '0';
        wait;
    end process;

inst_ESP8266_ClientConfig: ESP8266_ClientConfig
    PORT MAP(
        clk       => clk,   -- :    in    STD_LOGIC;
        rst       => rst,   -- :    in    STD_LOGIC;
        rx        => rx,    --:    in    STD_LOGIC;
        tx        => tx     --:    out    STD_LOGIC
    );

end Behavioral;
