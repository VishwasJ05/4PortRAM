`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 13:54:49
// Design Name: 
// Module Name: PortRAM
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

module ram_4port (
    input clk,
    input cs_a, wr_a,
    input [9:0] addr_a,
    input [7:0] data_in_a,
    output reg [7:0] data_out_a,

    input cs_b, wr_b,
    input [9:0] addr_b,
    input [7:0] data_in_b,
    output reg [7:0] data_out_b,

    input cs_c, wr_c,
    input [9:0] addr_c,
    input [7:0] data_in_c,
    output reg [7:0] data_out_c,

    input cs_d, wr_d,
    input [9:0] addr_d,
    input [7:0] data_in_d,
    output reg [7:0] data_out_d,

    output reg conflict  // NEW: High when two or more write to same address
);
    parameter MEMORY_SIZE = 1024;
    reg [7:0] mem [0:MEMORY_SIZE-1];

    integer i;
    initial begin
        for (i = 0; i < MEMORY_SIZE; i = i + 1)
            mem[i] = 8'd0;
    end

    always @(posedge clk) begin
        // Conflict Detection
        conflict <= 0;
        if ((cs_a && wr_a && cs_b && wr_b && addr_a == addr_b) ||
            (cs_a && wr_a && cs_c && wr_c && addr_a == addr_c) ||
            (cs_a && wr_a && cs_d && wr_d && addr_a == addr_d) ||
            (cs_b && wr_b && cs_c && wr_c && addr_b == addr_c) ||
            (cs_b && wr_b && cs_d && wr_d && addr_b == addr_d) ||
            (cs_c && wr_c && cs_d && wr_d && addr_c == addr_d)) begin
            conflict <= 1;
        end

        // Priority Write
        if (cs_a && wr_a) mem[addr_a] <= data_in_a;

        if (cs_b && wr_b && !(cs_a && wr_a && addr_a == addr_b))
            mem[addr_b] <= data_in_b;

        if (cs_c && wr_c &&
            !(cs_a && wr_a && addr_a == addr_c) &&
            !(cs_b && wr_b && addr_b == addr_c))
            mem[addr_c] <= data_in_c;

        if (cs_d && wr_d &&
            !(cs_a && wr_a && addr_a == addr_d) &&
            !(cs_b && wr_b && addr_b == addr_d) &&
            !(cs_c && wr_c && addr_c == addr_d))
            mem[addr_d] <= data_in_d;

        // Read
        data_out_a <= (cs_a && !wr_a) ? mem[addr_a] : 8'd0;
        data_out_b <= (cs_b && !wr_b) ? mem[addr_b] : 8'd0;
        data_out_c <= (cs_c && !wr_c) ? mem[addr_c] : 8'd0;
        data_out_d <= (cs_d && !wr_d) ? mem[addr_d] : 8'd0;
    end
endmodule


