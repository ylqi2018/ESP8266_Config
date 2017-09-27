@echo off
set xv_path=D:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xsim tb_WiFi_Receiver_mac_behav -key {Behavioral:sim_1:Functional:tb_WiFi_Receiver_mac} -tclbatch tb_WiFi_Receiver_mac.tcl -view D:/Vivado_Program_Files/20170711_ESP8266/ESP8266_Config_2.1/tb_WiFi_Receiver_mac_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
