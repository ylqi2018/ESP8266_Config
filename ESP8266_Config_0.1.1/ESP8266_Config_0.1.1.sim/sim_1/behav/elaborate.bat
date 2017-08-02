@echo off
set xv_path=D:\\Xilinx\\Vivado\\2015.4\\bin
call %xv_path%/xelab  -wto 86baede9cc0048e787d92db000cc0a3d -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_ESP8266_ClientConfig_behav xil_defaultlib.tb_ESP8266_ClientConfig -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
