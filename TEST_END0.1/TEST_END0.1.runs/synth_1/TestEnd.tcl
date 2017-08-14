# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir D:/Vivado_Program_Files/20170711_ESP8266/TEST_END0.1/TEST_END0.1.cache/wt [current_project]
set_property parent.project_path D:/Vivado_Program_Files/20170711_ESP8266/TEST_END0.1/TEST_END0.1.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
set_property vhdl_version vhdl_2k [current_fileset]
add_files -quiet D:/Vivado_Program_Files/20170711_ESP8266/TEST_END0.1/TEST_END0.1.runs/ila_uart_synth_1/ila_uart.dcp
set_property used_in_implementation false [get_files D:/Vivado_Program_Files/20170711_ESP8266/TEST_END0.1/TEST_END0.1.runs/ila_uart_synth_1/ila_uart.dcp]
read_vhdl -library xil_defaultlib {
  D:/Vivado_Program_Files/20170711_ESP8266/TEST_END0.1/TEST_END0.1.srcs/sources_1/uart.vhd
  D:/Vivado_Program_Files/20170711_ESP8266/TEST_END0.1/TEST_END0.1.srcs/sources_1/TestEnd.vhd
}
read_xdc D:/Vivado_Program_Files/20170711_ESP8266/TEST_END0.1/TEST_END0.1.srcs/constrs_1/Basys3_Master.xdc
set_property used_in_implementation false [get_files D:/Vivado_Program_Files/20170711_ESP8266/TEST_END0.1/TEST_END0.1.srcs/constrs_1/Basys3_Master.xdc]

synth_design -top TestEnd -part xc7a35tcpg236-1
write_checkpoint -noxdef TestEnd.dcp
catch { report_utilization -file TestEnd_utilization_synth.rpt -pb TestEnd_utilization_synth.pb }