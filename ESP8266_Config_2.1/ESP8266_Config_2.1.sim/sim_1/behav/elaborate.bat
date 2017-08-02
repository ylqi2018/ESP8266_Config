@echo off
set xv_path=D:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto 5e805ce88e264a0b9d064afe4c103146 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_WiFi_Receiver_mac_behav xil_defaultlib.tb_WiFi_Receiver_mac -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
