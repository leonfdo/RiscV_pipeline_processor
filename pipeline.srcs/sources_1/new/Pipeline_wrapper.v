`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/01/2024 07:27:20 PM
// Design Name: 
// Module Name: Pipeline_wrapper
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


module Pipeline_wrapper(
    input wire clk,rst,
    input wire [1:0]sw,
    output wire [3:0]FPGA_out
    );
    
datapath datapath_blk(
    .clk(clk),
    .rst(rst),
    .sw(sw),
    .FPGA_out(FPGA_out)
);

  
endmodule
