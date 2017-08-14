----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/14/2017 11:30:01 AM
-- Design Name: 
-- Module Name: TestEnd - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestEnd is
    port(
        clk                 :   in      std_logic;
        rst                 :   in      std_logic;
        rx                  :   in      std_logic;
        tx                  :   out     std_logic;
        led                 :   out     std_logic        
    );
end TestEnd;

architecture Behavioral of TestEnd is

-- ########################################################################## --
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
    probe0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END component;


signal  s_data_stream_send      :   std_logic_vector(7 downto 0);
signal  s_data_stream_send_stb  :   std_logic;
signal  s_data_stream_in_ack    :   std_logic;
signal  s_data_stream_out       :   std_logic_vector(7 downto 0);
signal  s_data_stream_out_stb   :   std_logic;

--signal  data_stream_rec_unsigned   :   unsigned(7 downto 0);

begin

    process(clk)
    begin
        if(clk'event and clk = '1') then
            if(rst = '1') then
                led     <= '0';
            elsif(s_data_stream_out_stb = '1') then
                led     <= '1';
            end if;
        end if;            
    end process;


s_data_stream_send      <= X"";
s_data_stream_send_stb  <= '1';

inst_uart: uart
    generic map(
        baud                => 115200,      --: positive;
        clock_frequency     => 100000000    --: positive
    )
    port map(  
        clock               => clk,                     --:   in  std_logic;
        reset               => rst,                     --:   in  std_logic;    
        data_stream_in      => s_data_stream_send,      --:   in  std_logic_vector(7 downto 0);
        data_stream_in_stb  => s_data_stream_send_stb,  --:   in  std_logic;
        data_stream_in_ack  => s_data_stream_in_ack,    --:   out std_logic;
        data_stream_out     => s_data_stream_out,       --:   out std_logic_vector(7 downto 0);
        data_stream_out_stb => s_data_stream_out_stb,   --:   out std_logic;
        tx                  => tx,                      --:   out std_logic;
        rx                  => rx                       --:   in  std_logic
    );
    
inst_ila_uart: ila_uart
    PORT map(
        clk         => clk,                     --: IN STD_LOGIC;
        probe0(0)   => s_data_stream_out_stb,   -- : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        probe1      => s_data_stream_out        -- : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
    );

end Behavioral;
