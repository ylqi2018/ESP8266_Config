-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\wifi_server\wifi_server.vhd
-- Created: 2017-10-04 12:01:33
-- 
-- Generated by MATLAB 8.6 and HDL Coder 3.7
-- 
-- 
-- -------------------------------------------------------------
-- Rate and Clocking Details
-- -------------------------------------------------------------
-- Model base rate: 0
-- Target subsystem base rate: 0
-- 
-- 
-- Clock Enable  Sample Time
-- -------------------------------------------------------------
-- ce_out        0
-- -------------------------------------------------------------
-- 
-- 
-- Output Signal                 Clock Enable  Sample Time
-- -------------------------------------------------------------
-- data_stream_send_stb          ce_out        0
-- data_stream_send              ce_out        0
-- cmd_start                     ce_out        0
-- model_sel                     ce_out        0
-- rec_data_en                   ce_out        0
-- -------------------------------------------------------------
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: wifi_server
-- Source Path: wifi_server
-- Hierarchy Level: 0
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY wifi_server IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        clk_enable                        :   IN    std_logic;
        data_stream_in_ack                :   IN    std_logic;
        cmd_over                          :   IN    std_logic;
        byte_to_tx                        :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        data_stream_rec_stb               :   IN    std_logic;
        data_stream_rec                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        model_cmd                         :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        rec_cmd_en                        :   IN    std_logic;
        ce_out                            :   OUT   std_logic;
        data_stream_send_stb              :   OUT   std_logic;
        data_stream_send                  :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        cmd_start                         :   OUT   std_logic;
        model_sel                         :   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
        rec_data_en                       :   OUT   std_logic
        );
END wifi_server;


ARCHITECTURE rtl OF wifi_server IS

  -- Component Declarations
  COMPONENT wifi_setup_server_mac
    PORT( clk                             :   IN    std_logic;
          reset                           :   IN    std_logic;
          enb                             :   IN    std_logic;
          data_stream_in_ack              :   IN    std_logic;
          cmd_over                        :   IN    std_logic;
          byte_to_tx                      :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          data_stream_rec_stb             :   IN    std_logic;
          data_stream_rec                 :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
          model_cmd                       :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
          rec_cmd_en                      :   IN    std_logic;
          data_stream_send_stb            :   OUT   std_logic;
          data_stream_send                :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
          cmd_start                       :   OUT   std_logic;
          model_sel                       :   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
          rec_data_en                     :   OUT   std_logic
          );
  END COMPONENT;

  -- Component Configuration Statements
  FOR ALL : wifi_setup_server_mac
    USE ENTITY work.wifi_setup_server_mac(rtl);

  -- Signals
  SIGNAL data_stream_send_tmp             : std_logic_vector(7 DOWNTO 0);  -- ufix8
  SIGNAL model_sel_tmp                    : std_logic_vector(3 DOWNTO 0);  -- ufix4

BEGIN
  u_wifi_setup_server_mac : wifi_setup_server_mac
    PORT MAP( clk => clk,
              reset => reset,
              enb => clk_enable,
              data_stream_in_ack => data_stream_in_ack,
              cmd_over => cmd_over,
              byte_to_tx => byte_to_tx,  -- uint8
              data_stream_rec_stb => data_stream_rec_stb,
              data_stream_rec => data_stream_rec,  -- uint8
              model_cmd => model_cmd,  -- ufix4
              rec_cmd_en => rec_cmd_en,
              data_stream_send_stb => data_stream_send_stb,
              data_stream_send => data_stream_send_tmp,  -- uint8
              cmd_start => cmd_start,
              model_sel => model_sel_tmp,  -- ufix4
              rec_data_en => rec_data_en
              );

  ce_out <= clk_enable;

  data_stream_send <= data_stream_send_tmp;

  model_sel <= model_sel_tmp;

END rtl;
