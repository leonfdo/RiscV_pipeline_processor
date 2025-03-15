`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/30/2023 12:59:45 AM
// Design Name: 
// Module Name: Data_mem
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

module Data_mem #(parameter width=32, addr_space=5)(
    input logic [1:0]sw, 
    input logic clk,
    input logic [width-1:0]data_addr,
    input logic signed [width-1:0] data_in,
    input logic memwrt,
    input logic memread,
    input logic [2:0]space_sig,
    output logic signed [width-1:0] data_out,
    output logic [3:0]FPGA_mem_out
);
    logic signed [width-1:0]data[((2**addr_space)-1):0];
    logic [width-1:0] data_out_intermediate;

    initial begin
        $readmemh("ins.dat",data);
    end

    //4*4 of 8 bytes = 4*8 bytes
    logic [width-1:0] Mem_cache [8-1:0];
    //Tag_bits Set_Row
    logic [2:0] Tag_bits_0_0;
    logic [2:0] Tag_bits_0_1;
    logic [2:0] Tag_bits_1_0;
    logic [2:0] Tag_bits_1_1;
    //DirtyBits Set_Row to say mem value changed
    logic Dirty_bits_0_0 = 0;
    logic Dirty_bits_0_1 = 0;
    logic Dirty_bits_1_0 = 0;
    logic Dirty_bits_1_1 = 0;
    //For cache miss
    logic cache_miss_0 = 1'b0;
    logic cache_miss_1 = 1'b0;
    
    //To indicate the line with last values entered
    //FIFO
    logic Flag_bits_0 = 1'b0;                                //Setting flag bits to set 0
    logic Flag_bits_1 = 1'b0;                                //Setting flag bits to set 1
   
    always_comb begin
        if (memread) begin
            if (data_addr[3]) begin
                //Check in set 1
                if (Tag_bits_1_1 == data_addr[6:4] && !Dirty_bits_1_1) begin
                    //The required data is in row1
                    data_out_intermediate = (data_addr[2]) ? Mem_cache[7] : Mem_cache[6];
                    cache_miss_1 = 1'b0; 
                end else if (Tag_bits_1_0 == data_addr[6:4] && !Dirty_bits_1_0) begin
                    //The required data is in row0
                    data_out_intermediate = (data_addr[2]) ? Mem_cache[5] : Mem_cache[4];  
                    cache_miss_1 = 1'b0; 
                end else begin
                    //Cache miss
                    data_out_intermediate = data[data_addr[31:2]];
                    cache_miss_1 = 1'b1;                     
                    //Cache is written in sync with clk
                end 

            end else begin
                //Check in Set0
                if (Tag_bits_0_1 == data_addr[6:4] && !Dirty_bits_0_1) begin
                    //The required data is in row1
                    data_out_intermediate = (data_addr[2]) ? Mem_cache[3] : Mem_cache[2];
                    cache_miss_0 = 1'b0;
                end else if (Tag_bits_0_0 == data_addr[6:4] && !Dirty_bits_0_0) begin
                    //The required data is in row0
                    data_out_intermediate = (data_addr[2]) ? Mem_cache[1] : Mem_cache[0];
                    cache_miss_0 = 1'b0;
                end else begin
                  //Cache miss
                  data_out_intermediate = data[data_addr[31:2]];
                  cache_miss_0 = 1'b1;
                  //Cache is written in sync with clk
                end
            end
        end
    end

    always@(*) begin
        if(memread) begin
            unique case(space_sig)
                //lb (000)
                //Word alligned
                3'b000:begin
                    case (data_addr[1:0])
                        2'b00:data_out = {{24{data_out_intermediate[7]}},data_out_intermediate[7:0]};
                        2'b01:data_out = {{24{data_out_intermediate[15]}},data_out_intermediate[15:8]};                        
                        2'b10:data_out = {{24{data_out_intermediate[23]}},data_out_intermediate[23:16]};
                        2'b11:data_out = {{24{data_out_intermediate[31]}},data_out_intermediate[31:24]};                       
                        default:data_out = {{24{data_out_intermediate[7]}},data_out_intermediate[7:0]};
                    endcase
                end
                //Word alligned
                //lbu (100)
                3'b100:begin
                    case (data_addr[1:0])
                        2'b00:data_out = {{24{1'b0}},data_out_intermediate[7:0]};
                        2'b01:data_out = {{24{1'b0}},data_out_intermediate[15:8]};                        
                        2'b10:data_out = {{24{1'b0}},data_out_intermediate[23:16]};
                        2'b11:data_out = {{24{1'b0}},data_out_intermediate[31:24]};                       
                        default:data_out = {{24{data_out_intermediate[7]}},data_out_intermediate[7:0]};
                    endcase
                end   
                //Halfword alligned                  
                //lh (001)
                3'b001:begin
                    case (data_addr[1])
                        1'b0:data_out = {{16{data_out_intermediate[15]}},data_out_intermediate[15:0]}; 
                        1'b1:data_out = {{16{data_out_intermediate[31]}},data_out_intermediate[31:16]};
                        default: data_out = {{16{data_out_intermediate[15]}},data_out_intermediate[15:0]};
                    endcase
                end
                //Halfword alligned
                //lhu (101)
                3'b101:begin
                    case (data_addr[1])
                        1'b0:data_out = {{16{1'b0}},data_out_intermediate[15:0]}; 
                        1'b1:data_out = {{16{1'b0}},data_out_intermediate[31:16]};
                        default: data_out = {{16{data_out_intermediate[15]}},data_out_intermediate[15:0]};
                    endcase
                end
                //lw  (010)
                3'b010: data_out<=data_out_intermediate;
            endcase
        end else begin
            data_out = 32'dx;
        end
    end

    //!Need to change the cache value as well - add code or check, can add dirty bit?
    always_ff @(posedge clk) begin
        if(memwrt)begin
            unique case(space_sig) 
                //Word alliging
                3'b000:begin
                    case (data_addr[1:0])
                    2'b00:data[data_addr[31:2]] <= {data[data_addr[31:2]][31:8], data_in[7:0]};
                    2'b01:data[data_addr[31:2]] <= {data[data_addr[31:2]][31:16],data_in[15:8],data[data_addr[31:2]][7:0]};                        
                    2'b10:data[data_addr[31:2]] <= {data[data_addr[31:2]][31:24],data_in[23:16],data[data_addr[31:2]][15:0]};
                    2'b11:data[data_addr[31:2]] <= {                             data_in[31:24],data[data_addr[31:2]][23:0]};                       
                        default:data[data_addr[31:2]] <= {data[data_addr][31:8],data_in[7:0]};
                    endcase
                end
                //Word alliging
                3'b001:begin
                    case (data_addr[1])
                        1'b0:data[data_addr[31:2]] <= {data[data_addr[31:2]][31:16], data_in[15:0]};
                        1'b1:data[data_addr[31:2]] <= {data_in[31:16],data[data_addr[31:2]][15:0]};
                        default: data[data_addr[31:2]] <= {data[data_addr[31:2]][31:16], data_in[15:0]};
                    endcase
                end
                3'b010:data[data_addr[31:2]]<=data_in[31:0];               
            endcase
        end
    end

    //To write on cache
    //Adding the row to the cache
    //Normal case, Cache in sync with Memory
    //Only one row will be out of sync once
    //Even both rows out of sync, rows will be synced as accessed 
    always_ff @( posedge clk ) begin
        if (cache_miss_1) begin
            if (!Dirty_bits_1_0 && !Dirty_bits_1_1) begin
                        if (Flag_bits_1) begin
                            Mem_cache[6] <= data[{data_addr[31:3],1'b0}];
                            Mem_cache[7] <= data[{data_addr[31:3],1'b1}];
                            Tag_bits_1_1 <= data_addr[6:4];
                        end else  begin
                            Mem_cache[4] <= data[{data_addr[31:3],1'b0}];
                            Mem_cache[5] <= data[{data_addr[31:3],1'b1}]; 
                            Tag_bits_1_0 <= data_addr[6:4];       
                        end
                        Flag_bits_1 <= !Flag_bits_1;                        
                    end else begin
                        //Row 1 is no sync, so write there
                        if (Dirty_bits_1_1) begin
                            Mem_cache[6] <= data[{data_addr[31:3],1'b0}];
                            Mem_cache[7] <= data[{data_addr[31:3],1'b1}];
                            Tag_bits_1_1 <= data_addr[6:4];
                            Dirty_bits_1_1 <= 0;
                        end else  begin
                            Mem_cache[4] <= data[{data_addr[31:3],1'b0}];
                            Mem_cache[5] <= data[{data_addr[31:3],1'b1}]; 
                            Tag_bits_1_0 <= data_addr[6:4];
                            Dirty_bits_1_0 <= 0;         
                        end                     
                    end    
                    //cache_miss_1 <= 1'b0;                    
        end else if (cache_miss_0) begin
            if (!Dirty_bits_0_0 && !Dirty_bits_0_1) begin
                    if (Flag_bits_0) begin
                          Mem_cache[2] <= data[{data_addr[31:3],1'b0}];
                          Mem_cache[3] <= data[{data_addr[31:3],1'b1}];
                          Tag_bits_0_1 <= data_addr[6:4];
                      end else  begin
                          Mem_cache[0] <= data[{data_addr[31:3],1'b0}];
                          Mem_cache[1] <= data[{data_addr[31:3],1'b1}]; 
                          Tag_bits_0_0 <= data_addr[6:4];        
                      end
                      Flag_bits_0 <= !Flag_bits_0;
                //Memory changed case  
                end else begin
                    //Row 1 is no sync, so write there
                    if (Dirty_bits_0_1) begin
                          Mem_cache[2] <= data[{data_addr[31:3],1'b0}];
                          Mem_cache[3] <= data[{data_addr[31:3],1'b1}];
                          Tag_bits_0_1 <= data_addr[6:4];
                          Dirty_bits_0_1 <= 0;
                      end else  begin
                          Mem_cache[0] <= data[{data_addr[31:3],1'b0}];
                          Mem_cache[1] <= data[{data_addr[31:3],1'b1}]; 
                          Tag_bits_0_0 <= data_addr[6:4]; 
                          Dirty_bits_0_0 <= 0;        
                      end
                end
                //cache_miss_0 <= 1'b0;            
        end else if (memwrt) begin
            Dirty_bits_0_0 <= (data_addr[6:4] == Tag_bits_0_0) && (data_addr[3] == 1'b0) ? 1'b1 :Dirty_bits_0_0; 
            Dirty_bits_0_1 <= (data_addr[6:4] == Tag_bits_0_1) && (data_addr[3] == 1'b0) ? 1'b1 :Dirty_bits_0_1; 
            Dirty_bits_1_0 <= (data_addr[6:4] == Tag_bits_1_0) && (data_addr[3] == 1'b1) ? 1'b1 :Dirty_bits_1_0; 
            Dirty_bits_1_1 <= (data_addr[6:4] == Tag_bits_1_1) && (data_addr[3] == 1'b1) ? 1'b1 :Dirty_bits_1_1; 
        end  
    end 

    //For demonstration
    always_comb begin
        case(sw[1:0])
            2'b00: FPGA_mem_out=data[0];
            2'b01: FPGA_mem_out=data[1];
            2'b10: FPGA_mem_out=data[2];
            2'b11: FPGA_mem_out=data[3];
        endcase
    end

endmodule