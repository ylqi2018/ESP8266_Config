vlib work
vlib msim

vlib msim/xil_defaultlib

vmap xil_defaultlib msim/xil_defaultlib

vcom -work xil_defaultlib -64 -93 \
"../../../../ESP8266_Config_2.1.2.srcs/sources_1/ip/ila_top/sim/ila_top.vhd" \


