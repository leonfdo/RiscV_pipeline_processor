`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/29/2023 12:10:45 PM
// Design Name: 
// Module Name: testbench
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


module testbench();

//localparam width=32;
//localparam pc_width=5;

//logic [pc_width-1:0]pc_in;
logic clk=1'b0;
logic rst;
logic [1:0]sw;
logic [3:0]FPGA_out;
always #10 clk=~clk;

datapath dut(
    .sw(sw),
    .clk(clk),
    .rst(rst),
    .FPGA_out(FPGA_out)
);

initial begin
    rst=0;
    #15;
   
    rst=1;
    sw[1:0]=2'b01;
    #20;
    

    #20;
    

    #20;

    #20;

    #20;

    
   #20;

    
   #20;
   #20;
   #960;
  $finish;    
end
endmodule
