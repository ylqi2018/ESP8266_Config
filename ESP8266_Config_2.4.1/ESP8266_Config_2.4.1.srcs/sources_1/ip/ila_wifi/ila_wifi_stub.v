// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
// Date        : Wed Sep 27 10:49:58 2017
// Host        : MS-20160829GDVC running 64-bit Service Pack 1  (build 7601)
// Command     : write_verilog -force -mode synth_stub
//               D:/Vivado_Program_Files/20170711_ESP8266/ESP8266_Config_2.4.1/ESP8266_Config_2.4.1.srcs/sources_1/ip/ila_wifi/ila_wifi_stub.v
// Design      : ila_wifi
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "ila,Vivado 2015.4" *)
module ila_wifi(clk, probe0, probe1, probe2, probe3, probe4, probe5)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[0:0],probe1[63:0],probe2[31:0],probe3[31:0],probe4[0:0],probe5[7:0]" */;
  input clk;
  input [0:0]probe0;
  input [63:0]probe1;
  input [31:0]probe2;
  input [31:0]probe3;
  input [0:0]probe4;
  input [7:0]probe5;
endmodule
