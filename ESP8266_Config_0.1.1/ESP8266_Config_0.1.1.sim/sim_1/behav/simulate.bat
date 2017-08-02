@echo off
set xv_path=D:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xsim tb_ESP8266_ClientConfig_behav -key {Behavioral:sim_1:Functional:tb_ESP8266_ClientConfig} -tclbatch tb_ESP8266_ClientConfig.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
