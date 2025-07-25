`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2025 17:50:36
// Design Name: 
// Module Name: ram_1
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


module ram_1 #(parameter addr_size = 10, word_size = 8, memory_size = 1024)(
    input clk,
    input wr,
    input cs,
    input [addr_size-1:0] addr,
    input [word_size-1:0] data_in,
    output reg [word_size-1:0] data_out
);
    reg [word_size-1:0] mem [0:memory_size-1];

    always @(posedge clk) begin
        if (cs && wr) begin
            mem[addr] <= data_in;
        end
    end

    always @(*) begin
        if (cs && !wr)
            data_out = mem[addr];
        else
            data_out = 0;
    end
endmodule
