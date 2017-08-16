-- -------------------------------------------------------------
-- 
-- File Name: D:\Vivado_Program_Files\20170711_ESP8266\ESP8266_Config_2.1.1\ESP8266_Config_2.1.1.srcs\sources_1\Receive_St\receive_OK\WiFi_Receiver_mac.vhd
-- Created: 2017-08-16 12:58:05
-- 
-- Generated by MATLAB 8.6 and HDL Coder 3.7
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: WiFi_Receiver_mac
-- Source Path: receive_OK/WiFi_Receiver_mac
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.receive_OK_pkg.ALL;

ENTITY WiFi_Receiver_mac IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        data_stream_rec_stb               :   IN    std_logic;
        data_stream_rec                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        model_cmd                         :   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
        rec_cmd_en                        :   OUT   std_logic
        );
END WiFi_Receiver_mac;


ARCHITECTURE rtl OF WiFi_Receiver_mac IS

  -- Signals
  SIGNAL data_stream_rec_unsigned         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL is_WiFi_Receiver_mac             : T_state_type_is_WiFi_Receiver_mac;  -- uint8
  SIGNAL model_cmd_tmp                    : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL time_cnt                         : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL model_cmd_reg                    : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL rec_cmd_en_reg                   : std_logic;
  SIGNAL is_WiFi_Receiver_mac_next        : T_state_type_is_WiFi_Receiver_mac;  -- enum type state_type_is_WiFi_Receiver_mac (21 enums)
  SIGNAL time_cnt_next                    : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL model_cmd_reg_next               : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL rec_cmd_en_reg_next              : std_logic;

BEGIN
  data_stream_rec_unsigned <= unsigned(data_stream_rec);

  WiFi_Receiver_mac_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      is_WiFi_Receiver_mac <= IN_initial;
      model_cmd_reg <= to_unsigned(16#0#, 4);
      rec_cmd_en_reg <= '0';
      time_cnt <= to_unsigned(16#00000000#, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        is_WiFi_Receiver_mac <= is_WiFi_Receiver_mac_next;
        time_cnt <= time_cnt_next;
        model_cmd_reg <= model_cmd_reg_next;
        rec_cmd_en_reg <= rec_cmd_en_reg_next;
      END IF;
    END IF;
  END PROCESS WiFi_Receiver_mac_1_process;

  WiFi_Receiver_mac_1_output : PROCESS (is_WiFi_Receiver_mac, data_stream_rec_stb, data_stream_rec_unsigned, time_cnt,
       model_cmd_reg, rec_cmd_en_reg)
    VARIABLE guard1 : std_logic;
    VARIABLE guard2 : std_logic;
    VARIABLE guard3 : std_logic;
    VARIABLE guard4 : std_logic;
    VARIABLE guard5 : std_logic;
    VARIABLE guard6 : std_logic;
    VARIABLE guard7 : std_logic;
    VARIABLE guard8 : std_logic;
    VARIABLE guard9 : std_logic;
    VARIABLE time_cnt_temp : unsigned(31 DOWNTO 0);
    VARIABLE add_temp : unsigned(32 DOWNTO 0);
  BEGIN
    time_cnt_temp := time_cnt;
    model_cmd_reg_next <= model_cmd_reg;
    rec_cmd_en_reg_next <= rec_cmd_en_reg;
    is_WiFi_Receiver_mac_next <= is_WiFi_Receiver_mac;
    guard1 := '0';
    guard2 := '0';
    guard3 := '0';
    guard4 := '0';
    guard5 := '0';
    guard6 := '0';
    guard7 := '0';
    guard8 := '0';
    guard9 := '0';
    CASE is_WiFi_Receiver_mac IS
      WHEN IN_detect_cmd =>
        is_WiFi_Receiver_mac_next <= IN_wait_cmd;
        model_cmd_reg_next <= to_unsigned(16#0#, 4);
        rec_cmd_en_reg_next <= '0';
      WHEN IN_initial =>
        is_WiFi_Receiver_mac_next <= IN_wait_cmd;
        model_cmd_reg_next <= to_unsigned(16#0#, 4);
        rec_cmd_en_reg_next <= '0';
      WHEN IN_receive_Carriage_Return =>
        is_WiFi_Receiver_mac_next <= IN_received_OK;
        model_cmd_reg_next <= to_unsigned(16#1#, 4);
        rec_cmd_en_reg_next <= '1';
      WHEN IN_receive_Carriage_Return1 =>
        is_WiFi_Receiver_mac_next <= IN_received_ERROR;
        model_cmd_reg_next <= to_unsigned(16#2#, 4);
        rec_cmd_en_reg_next <= '1';
      WHEN IN_receive_Carriage_Return2 =>
        is_WiFi_Receiver_mac_next <= IN_received_FAIL;
        model_cmd_reg_next <= to_unsigned(16#3#, 4);
        rec_cmd_en_reg_next <= '1';
      WHEN IN_received_A =>
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#49#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_I;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#49#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSE 
            guard2 := '1';
          END IF;
        ELSE 
          guard2 := '1';
        END IF;
      WHEN IN_received_E =>
        IF ( NOT data_stream_rec_stb) = '1' THEN 
          is_WiFi_Receiver_mac_next <= IN_received_E;
        ELSIF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#52#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_R;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#52#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          END IF;
        END IF;
      WHEN IN_received_ERROR =>
        is_WiFi_Receiver_mac_next <= IN_detect_cmd;
      WHEN IN_received_F =>
        IF ( NOT data_stream_rec_stb) = '1' THEN 
          is_WiFi_Receiver_mac_next <= IN_received_F;
        ELSIF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#41#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_A;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#41#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          END IF;
        END IF;
      WHEN IN_received_FAIL =>
        is_WiFi_Receiver_mac_next <= IN_detect_cmd;
      WHEN IN_received_I =>
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#4C#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_L;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#4C#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSE 
            guard3 := '1';
          END IF;
        ELSE 
          guard3 := '1';
        END IF;
      WHEN IN_received_K =>
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#0D#, 8) THEN 
            --Carrage Return
            is_WiFi_Receiver_mac_next <= IN_receive_Carriage_Return;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#0D#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSE 
            guard4 := '1';
          END IF;
        ELSE 
          guard4 := '1';
        END IF;
      WHEN IN_received_L =>
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#0D#, 8) THEN 
            --Carrage Return
            is_WiFi_Receiver_mac_next <= IN_receive_Carriage_Return2;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#0D#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSE 
            guard5 := '1';
          END IF;
        ELSE 
          guard5 := '1';
        END IF;
      WHEN IN_received_O =>
        IF ( NOT data_stream_rec_stb) = '1' THEN 
          is_WiFi_Receiver_mac_next <= IN_received_O;
        ELSIF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#4B#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_K;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#4B#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          END IF;
        END IF;
      WHEN IN_received_O1 =>
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#52#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_R2;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#52#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSE 
            guard6 := '1';
          END IF;
        ELSE 
          guard6 := '1';
        END IF;
      WHEN IN_received_OK =>
        is_WiFi_Receiver_mac_next <= IN_detect_cmd;
      WHEN IN_received_R =>
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#52#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_R1;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#52#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSE 
            guard7 := '1';
          END IF;
        ELSE 
          guard7 := '1';
        END IF;
      WHEN IN_received_R1 =>
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#4F#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_O1;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#4F#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSE 
            guard8 := '1';
          END IF;
        ELSE 
          guard8 := '1';
        END IF;
      WHEN IN_received_R2 =>
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#0D#, 8) THEN 
            --Carrage Return
            is_WiFi_Receiver_mac_next <= IN_receive_Carriage_Return1;
          ELSIF data_stream_rec_unsigned /= to_unsigned(16#0D#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSE 
            guard9 := '1';
          END IF;
        ELSE 
          guard9 := '1';
        END IF;
      WHEN IN_time_out =>
        is_WiFi_Receiver_mac_next <= IN_wait_cmd;
        model_cmd_reg_next <= to_unsigned(16#0#, 4);
        rec_cmd_en_reg_next <= '0';
      WHEN OTHERS => 
        IF data_stream_rec_stb = '1' THEN 
          IF data_stream_rec_unsigned = to_unsigned(16#4F#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_O;
          ELSIF ((data_stream_rec_unsigned /= to_unsigned(16#4F#, 8)) AND (data_stream_rec_unsigned /= to_unsigned(16#45#, 8))) AND (data_stream_rec_unsigned /= to_unsigned(16#46#, 8)) THEN 
            is_WiFi_Receiver_mac_next <= IN_wait_cmd;
            model_cmd_reg_next <= to_unsigned(16#0#, 4);
            rec_cmd_en_reg_next <= '0';
          ELSIF data_stream_rec_unsigned = to_unsigned(16#45#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_E;
          ELSIF data_stream_rec_unsigned = to_unsigned(16#46#, 8) THEN 
            is_WiFi_Receiver_mac_next <= IN_received_F;
          ELSE 
            guard1 := '1';
          END IF;
        ELSE 
          guard1 := '1';
        END IF;
    END CASE;
    IF guard9 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        is_WiFi_Receiver_mac_next <= IN_received_R2;
      END IF;
    END IF;
    IF guard8 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        is_WiFi_Receiver_mac_next <= IN_received_R1;
      END IF;
    END IF;
    IF guard7 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        is_WiFi_Receiver_mac_next <= IN_received_R;
      END IF;
    END IF;
    IF guard6 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        is_WiFi_Receiver_mac_next <= IN_received_O1;
      END IF;
    END IF;
    IF guard5 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        is_WiFi_Receiver_mac_next <= IN_received_L;
      END IF;
    END IF;
    IF guard4 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        is_WiFi_Receiver_mac_next <= IN_received_K;
      END IF;
    END IF;
    IF guard3 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        is_WiFi_Receiver_mac_next <= IN_received_I;
      END IF;
    END IF;
    IF guard2 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        is_WiFi_Receiver_mac_next <= IN_received_A;
      END IF;
    END IF;
    IF guard1 = '1' THEN 
      IF ( NOT data_stream_rec_stb) = '1' THEN 
        add_temp := resize(time_cnt, 33) + to_unsigned(1, 33);
        IF add_temp(32) /= '0' THEN 
          time_cnt_temp := X"FFFFFFFF";
        ELSE 
          time_cnt_temp := add_temp(31 DOWNTO 0);
        END IF;
        IF time_cnt_temp > to_unsigned(60000000, 32) THEN 
          is_WiFi_Receiver_mac_next <= IN_time_out;
          time_cnt_temp := to_unsigned(16#00000000#, 32);
          model_cmd_reg_next <= to_unsigned(16#2#, 4);
          rec_cmd_en_reg_next <= '1';
        ELSIF time_cnt_temp <= to_unsigned(60000000, 32) THEN 
          is_WiFi_Receiver_mac_next <= IN_wait_cmd;
          model_cmd_reg_next <= to_unsigned(16#0#, 4);
          rec_cmd_en_reg_next <= '0';
        END IF;
      END IF;
    END IF;
    time_cnt_next <= time_cnt_temp;
  END PROCESS WiFi_Receiver_mac_1_output;

  model_cmd_tmp <= model_cmd_reg_next;
  rec_cmd_en <= rec_cmd_en_reg_next;

  model_cmd <= std_logic_vector(model_cmd_tmp);

END rtl;
