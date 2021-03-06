-- -------------------------------------------------------------
-- 
-- File Name: hdlsrc\ESP8266_Config\wifi_setup_client.vhd
-- Created: 2017-09-27 10:37:28
-- 
-- Generated by MATLAB 8.6 and HDL Coder 3.7
-- 
-- -------------------------------------------------------------


-- -------------------------------------------------------------
-- 
-- Module: wifi_setup_client
-- Source Path: ESP8266_Config/wifi_setup_client 
-- Hierarchy Level: 1
-- 
-- -------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ESP8266_Config_pkg.ALL;

ENTITY wifi_setup_client IS
  PORT( clk                               :   IN    std_logic;
        reset                             :   IN    std_logic;
        enb                               :   IN    std_logic;
        data_stream_in_ack                :   IN    std_logic;
        cmd_over                          :   IN    std_logic;
        byte_to_tx                        :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        data_stream_out_stb               :   IN    std_logic;
        data_stream_out                   :   IN    std_logic_vector(7 DOWNTO 0);  -- uint8
        rec_cmd_en                        :   IN    std_logic;
        model_cmd                         :   IN    std_logic_vector(3 DOWNTO 0);  -- ufix4
        data_stream_send_stb              :   OUT   std_logic;
        data_stream_send                  :   OUT   std_logic_vector(7 DOWNTO 0);  -- uint8
        cmd_start                         :   OUT   std_logic;
        model_sel                         :   OUT   std_logic_vector(3 DOWNTO 0);  -- ufix4
        rec_data_en                       :   OUT   std_logic
        );
END wifi_setup_client;


ARCHITECTURE rtl OF wifi_setup_client IS

  -- Functions
  -- HDLCODER_TO_STDLOGIC 
  FUNCTION hdlcoder_to_stdlogic(arg: boolean) RETURN std_logic IS
  BEGIN
    IF arg THEN
      RETURN '1';
    ELSE
      RETURN '0';
    END IF;
  END FUNCTION;


  -- Signals
  SIGNAL byte_to_tx_unsigned              : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL data_stream_out_unsigned         : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL model_cmd_unsigned               : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL is_wifi_setup_client             : T_state_type_is_wifi_setup_client;  -- uint8
  SIGNAL cnt_wait                         : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL data_stream_send_tmp             : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL model_sel_tmp                    : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL cnt_halt                         : signed(31 DOWNTO 0);  -- int32
  SIGNAL data_stream_send_stb_reg         : std_logic;
  SIGNAL data_stream_send_reg             : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL cmd_start_reg                    : std_logic;
  SIGNAL model_sel_reg                    : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL rec_data_en_reg                  : std_logic;
  SIGNAL is_wifi_setup_client_next        : T_state_type_is_wifi_setup_client;  -- enum type state_type_is_wifi_setup_client (38 enums)
  SIGNAL cnt_wait_next                    : unsigned(31 DOWNTO 0);  -- uint32
  SIGNAL cnt_halt_next                    : signed(31 DOWNTO 0);  -- int32
  SIGNAL data_stream_send_stb_reg_next    : std_logic;
  SIGNAL data_stream_send_reg_next        : unsigned(7 DOWNTO 0);  -- uint8
  SIGNAL cmd_start_reg_next               : std_logic;
  SIGNAL model_sel_reg_next               : unsigned(3 DOWNTO 0);  -- ufix4
  SIGNAL rec_data_en_reg_next             : std_logic;

BEGIN
  byte_to_tx_unsigned <= unsigned(byte_to_tx);

  data_stream_out_unsigned <= unsigned(data_stream_out);

  model_cmd_unsigned <= unsigned(model_cmd);

  wifi_setup_client_1_process : PROCESS (clk, reset)
  BEGIN
    IF reset = '1' THEN
      is_wifi_setup_client <= IN_initial;
      data_stream_send_stb_reg <= '0';
      data_stream_send_reg <= to_unsigned(16#00#, 8);
      cmd_start_reg <= '0';
      rec_data_en_reg <= '0';
      model_sel_reg <= to_unsigned(16#0#, 4);
      cnt_wait <= to_unsigned(16#00000000#, 32);
      cnt_halt <= to_signed(16#00000000#, 32);
    ELSIF clk'EVENT AND clk = '1' THEN
      IF enb = '1' THEN
        is_wifi_setup_client <= is_wifi_setup_client_next;
        cnt_wait <= cnt_wait_next;
        cnt_halt <= cnt_halt_next;
        data_stream_send_stb_reg <= data_stream_send_stb_reg_next;
        data_stream_send_reg <= data_stream_send_reg_next;
        cmd_start_reg <= cmd_start_reg_next;
        model_sel_reg <= model_sel_reg_next;
        rec_data_en_reg <= rec_data_en_reg_next;
      END IF;
    END IF;
  END PROCESS wifi_setup_client_1_process;

  wifi_setup_client_1_output : PROCESS (is_wifi_setup_client, data_stream_in_ack, cmd_over, byte_to_tx_unsigned,
       data_stream_out_stb, data_stream_out_unsigned, rec_cmd_en,
       model_cmd_unsigned, cnt_wait, cnt_halt, data_stream_send_stb_reg,
       data_stream_send_reg, cmd_start_reg, model_sel_reg, rec_data_en_reg)
    VARIABLE add_temp : unsigned(32 DOWNTO 0);
    VARIABLE add_temp_0 : signed(32 DOWNTO 0);
    VARIABLE add_temp_1 : signed(32 DOWNTO 0);
    VARIABLE add_temp_2 : unsigned(32 DOWNTO 0);
    VARIABLE add_temp_3 : signed(32 DOWNTO 0);
    VARIABLE add_temp_4 : unsigned(4 DOWNTO 0);
    VARIABLE add_temp_5 : signed(32 DOWNTO 0);
    VARIABLE add_temp_6 : unsigned(32 DOWNTO 0);
    VARIABLE add_temp_7 : unsigned(32 DOWNTO 0);
    VARIABLE add_temp_8 : signed(32 DOWNTO 0);
    VARIABLE add_temp_9 : signed(32 DOWNTO 0);
    VARIABLE add_temp_10 : signed(32 DOWNTO 0);
  BEGIN
    cnt_halt_next <= cnt_halt;
    data_stream_send_stb_reg_next <= data_stream_send_stb_reg;
    data_stream_send_reg_next <= data_stream_send_reg;
    cmd_start_reg_next <= cmd_start_reg;
    model_sel_reg_next <= model_sel_reg;
    rec_data_en_reg_next <= rec_data_en_reg;
    is_wifi_setup_client_next <= is_wifi_setup_client;
    cnt_wait_next <= cnt_wait;
    CASE is_wifi_setup_client IS
      WHEN IN_Tran1_Enter =>
        IF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran1_Enter_1;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0A#, 8);
          --/n
        ELSIF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran1_Enter;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0D#, 8);
          --/r
        END IF;
      WHEN IN_Tran1_Enter_1 =>
        IF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_send_finish1;
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
        ELSIF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran1_Enter_1;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0A#, 8);
          --/n
        END IF;
      WHEN IN_Tran2_Enter =>
        IF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran2_Enter_1;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0A#, 8);
          --/n
        ELSIF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran2_Enter;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0D#, 8);
          --/r
        END IF;
      WHEN IN_Tran2_Enter_1 =>
        IF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_send_finish2;
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
          --After finish sending, I can still get
          -- response OK
          add_temp_5 := resize(cnt_halt, 33) + to_signed(1, 33);
          IF (add_temp_5(32) = '0') AND (add_temp_5(31) /= '0') THEN 
            cnt_halt_next <= X"7FFFFFFF";
          ELSIF (add_temp_5(32) = '1') AND (add_temp_5(31) /= '1') THEN 
            cnt_halt_next <= X"80000000";
          ELSE 
            cnt_halt_next <= add_temp_5(31 DOWNTO 0);
          END IF;
        ELSIF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran2_Enter_1;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0A#, 8);
          --/n
        END IF;
      WHEN IN_Tran3_Enter =>
        IF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran3_Enter;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0D#, 8);
          --/r
        ELSIF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran3_Enter_1;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0A#, 8);
          --/n
        END IF;
      WHEN IN_Tran3_Enter_1 =>
        IF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran3_Enter_1;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0A#, 8);
          --/n
        ELSIF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_send_finish3;
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
          model_sel_reg_next <= to_unsigned(16#0#, 4);
        END IF;
      WHEN IN_Tran_A =>
        IF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran_A;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#41#, 8);
          --A
        ELSIF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran_T;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#54#, 8);
          --T
        END IF;
      WHEN IN_Tran_Enter =>
        IF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran_Enter_1;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0A#, 8);
          --/n
        ELSIF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran_Enter;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0D#, 8);
          --/r
        END IF;
      WHEN IN_Tran_Enter_1 =>
        IF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_send_finish;
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
        ELSIF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran_Enter_1;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0A#, 8);
          --/n
        END IF;
      WHEN IN_Tran_T =>
        IF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran_Enter;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#0D#, 8);
          --/r
        ELSIF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_Tran_T;
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= to_unsigned(16#54#, 8);
          --T
        END IF;
      WHEN IN_device_OK =>
        is_wifi_setup_client_next <= IN_send_cmd1;
        cmd_start_reg_next <= '1';
        data_stream_send_stb_reg_next <= '0';
        data_stream_send_reg_next <= byte_to_tx_unsigned;
      WHEN IN_device_config_OK =>
        is_wifi_setup_client_next <= IN_send_data1;
        cmd_start_reg_next <= '1';
        data_stream_send_stb_reg_next <= '0';
        data_stream_send_reg_next <= byte_to_tx_unsigned;
        cnt_halt_next <= to_signed(16#00000000#, 32);
      WHEN IN_initial =>
        is_wifi_setup_client_next <= IN_Tran_A;
        data_stream_send_stb_reg_next <= '1';
        data_stream_send_reg_next <= to_unsigned(16#41#, 8);
        --A
      WHEN IN_model_reselect =>
        is_wifi_setup_client_next <= IN_wait_cnt1;
        add_temp := resize(cnt_wait, 33) + to_unsigned(1, 33);
        IF add_temp(32) /= '0' THEN 
          cnt_wait_next <= X"FFFFFFFF";
        ELSE 
          cnt_wait_next <= add_temp(31 DOWNTO 0);
        END IF;
      WHEN IN_model_sel_rst =>
        is_wifi_setup_client_next <= IN_send_cmd3;
        cmd_start_reg_next <= '1';
        data_stream_send_stb_reg_next <= '0';
        data_stream_send_reg_next <= byte_to_tx_unsigned;
        cnt_halt_next <= to_signed(16#00000000#, 32);
      WHEN IN_pre_rec_data =>
        IF ( NOT data_stream_out_stb) = '1' THEN 
          is_wifi_setup_client_next <= IN_pre_rec_data;
        ELSIF data_stream_out_stb = '1' THEN 
          is_wifi_setup_client_next <= IN_rec_data;
          add_temp_1 := resize(cnt_halt, 33) + to_signed(1, 33);
          IF (add_temp_1(32) = '0') AND (add_temp_1(31) /= '0') THEN 
            cnt_halt_next <= X"7FFFFFFF";
          ELSIF (add_temp_1(32) = '1') AND (add_temp_1(31) /= '1') THEN 
            cnt_halt_next <= X"80000000";
          ELSE 
            cnt_halt_next <= add_temp_1(31 DOWNTO 0);
          END IF;
        END IF;
      WHEN IN_rec_data =>
        IF cnt_halt < to_signed(8, 32) THEN 
          is_wifi_setup_client_next <= IN_rec_data;
          add_temp_0 := resize(cnt_halt, 33) + to_signed(1, 33);
          IF (add_temp_0(32) = '0') AND (add_temp_0(31) /= '0') THEN 
            cnt_halt_next <= X"7FFFFFFF";
          ELSIF (add_temp_0(32) = '1') AND (add_temp_0(31) /= '1') THEN 
            cnt_halt_next <= X"80000000";
          ELSE 
            cnt_halt_next <= add_temp_0(31 DOWNTO 0);
          END IF;
        ELSIF cnt_halt = to_signed(8, 32) THEN 
          is_wifi_setup_client_next <= IN_wait_port;
          rec_data_en_reg_next <= '0';
          cnt_halt_next <= to_signed(16#00000001#, 32);
        END IF;
      WHEN IN_restart =>
        is_wifi_setup_client_next <= IN_model_sel_rst;
        cnt_halt_next <= to_signed(16#00000000#, 32);
        model_sel_reg_next <= to_unsigned(16#9#, 4);
      WHEN IN_send_cmd1 =>
        is_wifi_setup_client_next <= IN_send_cmd2;
        cmd_start_reg_next <= '1';
        data_stream_send_stb_reg_next <= '1';
        data_stream_send_reg_next <= byte_to_tx_unsigned;
      WHEN IN_send_cmd2 =>
        IF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_send_cmd2;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
        ELSIF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_wait_cmd;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
        END IF;
      WHEN IN_send_cmd3 =>
        is_wifi_setup_client_next <= IN_send_cmd4;
        cmd_start_reg_next <= '1';
        data_stream_send_stb_reg_next <= '1';
        data_stream_send_reg_next <= byte_to_tx_unsigned;
      WHEN IN_send_cmd4 =>
        IF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_send_cmd4;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
        ELSIF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_wait_cmd1;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
        END IF;
      WHEN IN_send_cmd_over =>
        is_wifi_setup_client_next <= IN_Tran1_Enter;
        data_stream_send_stb_reg_next <= '1';
        data_stream_send_reg_next <= to_unsigned(16#0D#, 8);
        --/r
      WHEN IN_send_cmd_over1 =>
        is_wifi_setup_client_next <= IN_Tran3_Enter;
        data_stream_send_stb_reg_next <= '1';
        data_stream_send_reg_next <= to_unsigned(16#0D#, 8);
        --/r
      WHEN IN_send_data1 =>
        is_wifi_setup_client_next <= IN_send_data2;
        cmd_start_reg_next <= '1';
        data_stream_send_stb_reg_next <= '1';
        data_stream_send_reg_next <= byte_to_tx_unsigned;
      WHEN IN_send_data2 =>
        IF ( NOT data_stream_in_ack) = '1' THEN 
          is_wifi_setup_client_next <= IN_send_data2;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
        ELSIF data_stream_in_ack = '1' THEN 
          is_wifi_setup_client_next <= IN_wait_data;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
        END IF;
      WHEN IN_send_data_over =>
        is_wifi_setup_client_next <= IN_Tran2_Enter;
        data_stream_send_stb_reg_next <= '1';
        data_stream_send_reg_next <= to_unsigned(16#0D#, 8);
        --/r
      WHEN IN_send_finish =>
        IF ( NOT rec_cmd_en) = '1' THEN 
          is_wifi_setup_client_next <= IN_send_finish;
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
        ELSIF rec_cmd_en = '1' THEN 
          IF model_cmd_unsigned /= to_unsigned(16#1#, 4) THEN 
            is_wifi_setup_client_next <= IN_Tran_A;
            data_stream_send_stb_reg_next <= '1';
            data_stream_send_reg_next <= to_unsigned(16#41#, 8);
            --A
          ELSIF model_cmd_unsigned = to_unsigned(16#1#, 4) THEN 
            is_wifi_setup_client_next <= IN_wait_cnt1;
            add_temp_6 := resize(cnt_wait, 33) + to_unsigned(1, 33);
            IF add_temp_6(32) /= '0' THEN 
              cnt_wait_next <= X"FFFFFFFF";
            ELSE 
              cnt_wait_next <= add_temp_6(31 DOWNTO 0);
            END IF;
          END IF;
        END IF;
      WHEN IN_send_finish1 =>
        IF ( NOT rec_cmd_en) = '1' THEN 
          is_wifi_setup_client_next <= IN_send_finish1;
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
        ELSIF rec_cmd_en = '1' THEN 
          IF model_cmd_unsigned /= to_unsigned(16#1#, 4) THEN 
            --This cmd does not config sucessfully
            is_wifi_setup_client_next <= IN_send_cmd1;
            cmd_start_reg_next <= '1';
            data_stream_send_stb_reg_next <= '0';
            data_stream_send_reg_next <= byte_to_tx_unsigned;
          ELSIF model_cmd_unsigned = to_unsigned(16#1#, 4) THEN 
            is_wifi_setup_client_next <= IN_wait_cnt1;
            add_temp_7 := resize(cnt_wait, 33) + to_unsigned(1, 33);
            IF add_temp_7(32) /= '0' THEN 
              cnt_wait_next <= X"FFFFFFFF";
            ELSE 
              cnt_wait_next <= add_temp_7(31 DOWNTO 0);
            END IF;
          END IF;
        END IF;
      WHEN IN_send_finish2 =>
        IF (data_stream_out_stb AND hdlcoder_to_stdlogic(data_stream_out_unsigned = to_unsigned(16#43#, 8))) = '1' THEN 
          --rec of C
          is_wifi_setup_client_next <= IN_wait_client_rec_C;
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
          add_temp_8 := resize(cnt_halt, 33) + to_signed(1, 33);
          IF (add_temp_8(32) = '0') AND (add_temp_8(31) /= '0') THEN 
            cnt_halt_next <= X"7FFFFFFF";
          ELSIF (add_temp_8(32) = '1') AND (add_temp_8(31) /= '1') THEN 
            cnt_halt_next <= X"80000000";
          ELSE 
            cnt_halt_next <= add_temp_8(31 DOWNTO 0);
          END IF;
        ELSIF (( NOT data_stream_out_stb) OR hdlcoder_to_stdlogic(data_stream_out_unsigned /= to_unsigned(16#43#, 8))) = '1' THEN 
          -- not rec C
          IF cnt_halt <= to_signed(1000000000, 32) THEN 
            --10sec
            is_wifi_setup_client_next <= IN_send_finish2;
            data_stream_send_stb_reg_next <= '0';
            data_stream_send_reg_next <= to_unsigned(16#00#, 8);
            --After finish sending, I can still get
            -- response OK
            add_temp_10 := resize(cnt_halt, 33) + to_signed(1, 33);
            IF (add_temp_10(32) = '0') AND (add_temp_10(31) /= '0') THEN 
              cnt_halt_next <= X"7FFFFFFF";
            ELSIF (add_temp_10(32) = '1') AND (add_temp_10(31) /= '1') THEN 
              cnt_halt_next <= X"80000000";
            ELSE 
              cnt_halt_next <= add_temp_10(31 DOWNTO 0);
            END IF;
          ELSIF cnt_halt > to_signed(1000000000, 32) THEN 
            --10sec
            is_wifi_setup_client_next <= IN_restart;
            cnt_halt_next <= to_signed(16#00000000#, 32);
          END IF;
        END IF;
      WHEN IN_send_finish3 =>
        is_wifi_setup_client_next <= IN_initial;
        data_stream_send_stb_reg_next <= '0';
        data_stream_send_reg_next <= to_unsigned(16#00#, 8);
        cmd_start_reg_next <= '0';
        rec_data_en_reg_next <= '0';
        model_sel_reg_next <= to_unsigned(16#0#, 4);
        cnt_wait_next <= to_unsigned(16#00000000#, 32);
        cnt_halt_next <= to_signed(16#00000000#, 32);
      WHEN IN_wait_client_rec_C =>
        IF (data_stream_out_stb AND hdlcoder_to_stdlogic(data_stream_out_unsigned = to_unsigned(16#52#, 8))) = '1' THEN 
          --rec of R
          is_wifi_setup_client_next <= IN_wait_client_rec_R;
          rec_data_en_reg_next <= '1';
          cnt_halt_next <= to_signed(16#00000000#, 32);
        ELSIF (( NOT data_stream_out_stb) OR hdlcoder_to_stdlogic(data_stream_out_unsigned /= to_unsigned(16#52#, 8))) = '1' THEN 
          IF cnt_halt <= to_signed(1000000000, 32) THEN 
            --10sec
            is_wifi_setup_client_next <= IN_wait_client_rec_C;
            data_stream_send_stb_reg_next <= '0';
            data_stream_send_reg_next <= to_unsigned(16#00#, 8);
            add_temp_9 := resize(cnt_halt, 33) + to_signed(1, 33);
            IF (add_temp_9(32) = '0') AND (add_temp_9(31) /= '0') THEN 
              cnt_halt_next <= X"7FFFFFFF";
            ELSIF (add_temp_9(32) = '1') AND (add_temp_9(31) /= '1') THEN 
              cnt_halt_next <= X"80000000";
            ELSE 
              cnt_halt_next <= add_temp_9(31 DOWNTO 0);
            END IF;
          ELSIF cnt_halt > to_signed(1000000000, 32) THEN 
            --10sec
            is_wifi_setup_client_next <= IN_restart;
            cnt_halt_next <= to_signed(16#00000000#, 32);
          END IF;
        END IF;
      WHEN IN_wait_client_rec_R =>
        is_wifi_setup_client_next <= IN_pre_rec_data;
      WHEN IN_wait_cmd =>
        IF cmd_over = '1' THEN 
          is_wifi_setup_client_next <= IN_send_cmd_over;
          cmd_start_reg_next <= '0';
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
        ELSIF ( NOT cmd_over) = '1' THEN 
          is_wifi_setup_client_next <= IN_send_cmd1;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
        END IF;
      WHEN IN_wait_cmd1 =>
        IF ( NOT cmd_over) = '1' THEN 
          is_wifi_setup_client_next <= IN_send_cmd3;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
          cnt_halt_next <= to_signed(16#00000000#, 32);
        ELSIF cmd_over = '1' THEN 
          is_wifi_setup_client_next <= IN_send_cmd_over1;
          cmd_start_reg_next <= '0';
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
        END IF;
      WHEN IN_wait_cnt1 =>
        IF cnt_wait < to_unsigned(10000000, 32) THEN 
          --0.05s
          is_wifi_setup_client_next <= IN_wait_cnt1;
          add_temp_2 := resize(cnt_wait, 33) + to_unsigned(1, 33);
          IF add_temp_2(32) /= '0' THEN 
            cnt_wait_next <= X"FFFFFFFF";
          ELSE 
            cnt_wait_next <= add_temp_2(31 DOWNTO 0);
          END IF;
        ELSIF cnt_wait >= to_unsigned(10000000, 32) THEN 
          IF model_sel_reg /= to_unsigned(16#6#, 4) THEN 
            is_wifi_setup_client_next <= IN_device_OK;
            add_temp_4 := resize(model_sel_reg, 5) + to_unsigned(16#01#, 5);
            IF add_temp_4(4) /= '0' THEN 
              model_sel_reg_next <= "1111";
            ELSE 
              model_sel_reg_next <= add_temp_4(3 DOWNTO 0);
            END IF;
            cnt_wait_next <= to_unsigned(16#00000000#, 32);
          ELSIF model_sel_reg = to_unsigned(16#6#, 4) THEN 
            is_wifi_setup_client_next <= IN_device_config_OK;
            model_sel_reg_next <= to_unsigned(16#7#, 4);
            --begin sending data
          END IF;
        END IF;
      WHEN IN_wait_data =>
        IF cmd_over = '1' THEN 
          is_wifi_setup_client_next <= IN_send_data_over;
          cmd_start_reg_next <= '0';
          data_stream_send_stb_reg_next <= '0';
          data_stream_send_reg_next <= to_unsigned(16#00#, 8);
        ELSIF ( NOT cmd_over) = '1' THEN 
          is_wifi_setup_client_next <= IN_send_data2;
          cmd_start_reg_next <= '1';
          data_stream_send_stb_reg_next <= '1';
          data_stream_send_reg_next <= byte_to_tx_unsigned;
        END IF;
      WHEN OTHERS => 
        IF cnt_halt <= to_signed(10000000, 32) THEN 
          --0.1s
          is_wifi_setup_client_next <= IN_wait_port;
          rec_data_en_reg_next <= '0';
          add_temp_3 := resize(cnt_halt, 33) + to_signed(1, 33);
          IF (add_temp_3(32) = '0') AND (add_temp_3(31) /= '0') THEN 
            cnt_halt_next <= X"7FFFFFFF";
          ELSIF (add_temp_3(32) = '1') AND (add_temp_3(31) /= '1') THEN 
            cnt_halt_next <= X"80000000";
          ELSE 
            cnt_halt_next <= add_temp_3(31 DOWNTO 0);
          END IF;
        ELSIF cnt_halt > to_signed(10000000, 32) THEN 
          is_wifi_setup_client_next <= IN_model_reselect;
          cnt_halt_next <= to_signed(16#00000000#, 32);
          model_sel_reg_next <= to_unsigned(16#5#, 4);
        END IF;
    END CASE;
  END PROCESS wifi_setup_client_1_output;

  data_stream_send_stb <= data_stream_send_stb_reg_next;
  data_stream_send_tmp <= data_stream_send_reg_next;
  cmd_start <= cmd_start_reg_next;
  model_sel_tmp <= model_sel_reg_next;
  rec_data_en <= rec_data_en_reg_next;

  data_stream_send <= std_logic_vector(data_stream_send_tmp);

  model_sel <= std_logic_vector(model_sel_tmp);

END rtl;

