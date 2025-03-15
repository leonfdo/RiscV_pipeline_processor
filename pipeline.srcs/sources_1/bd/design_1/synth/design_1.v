//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (win64) Build 2405991 Thu Dec  6 23:38:27 MST 2018
//Date        : Mon Jan  1 19:38:48 2024
//Host        : DESKTOP-TA3S8JV running 64-bit major release  (build 9200)
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=1,numPkgbdBlks=0,bdsource=USER,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (FPGA_out_0,
    clk_in1_0,
    reset_0,
    rst_0,
    sw_0);
  output [3:0]FPGA_out_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1_0, CLK_DOMAIN design_1_clk_in1_0, FREQ_HZ 125000000, INSERT_VIP 0, PHASE 0.000" *) input clk_in1_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_0, INSERT_VIP 0, POLARITY ACTIVE_HIGH" *) input reset_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RST_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RST_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) input rst_0;
  input [1:0]sw_0;

  wire [3:0]Pipeline_wrapper_0_FPGA_out;
  wire clk_in1_0_1;
  wire clk_wiz_0_clk_out1;
  wire reset_0_1;
  wire rst_0_1;
  wire [1:0]sw_0_1;

  assign FPGA_out_0[3:0] = Pipeline_wrapper_0_FPGA_out;
  assign clk_in1_0_1 = clk_in1_0;
  assign reset_0_1 = reset_0;
  assign rst_0_1 = rst_0;
  assign sw_0_1 = sw_0[1:0];
  design_1_Pipeline_wrapper_0_0 Pipeline_wrapper_0
       (.FPGA_out(Pipeline_wrapper_0_FPGA_out),
        .clk(clk_wiz_0_clk_out1),
        .rst(rst_0_1),
        .sw(sw_0_1));
  design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_in1_0_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .reset(reset_0_1));
endmodule
