//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Mon Jan  1 19:38:48 2024
//Host        : DESKTOP-TA3S8JV running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (FPGA_out_0,
    clk_in1_0,
    reset_0,
    rst_0,
    sw_0);
  output [3:0]FPGA_out_0;
  input clk_in1_0;
  input reset_0;
  input rst_0;
  input [1:0]sw_0;

  wire [3:0]FPGA_out_0;
  wire clk_in1_0;
  wire reset_0;
  wire rst_0;
  wire [1:0]sw_0;

  design_1 design_1_i
       (.FPGA_out_0(FPGA_out_0),
        .clk_in1_0(clk_in1_0),
        .reset_0(reset_0),
        .rst_0(rst_0),
        .sw_0(sw_0));
endmodule
