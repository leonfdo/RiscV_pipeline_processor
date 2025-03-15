`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2024 09:47:20 AM
// Design Name: 
// Module Name: Hazard_detect
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Hazard_detect(
    input logic memread,
    input logic [4:0]rs1_addr,rs2_addr,rd_addr,
    output logic stall 
    );
 
 initial begin
    stall=1'b0;
 end
   
  always@(*) begin
      if ((memread==1'b1) && ((rd_addr==rs1_addr)||(rd_addr==rs2_addr))) begin
        stall = 1'b1;
      end
      else begin
        stall = 1'b0;
      end
    end
 
endmodule
