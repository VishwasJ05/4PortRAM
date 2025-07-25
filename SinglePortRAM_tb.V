`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.07.2025 17:48:59
// Design Name: 
// Module Name: RAM_tb
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


module RAM_tb;
    reg clk;
    reg [9:0] address;
    reg [7:0] data_in;
    wire [7:0] data_out;
    reg write, select;
    integer k, myseed;

    // Instantiate the RAM
    ram_1 RAM (
        .clk(clk),
        .wr(write),
        .cs(select),
        .addr(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Generate clock
    always #1 clk = ~clk;

    initial begin
        clk = 0;
        myseed = 35;

        // Write to all addresses
        for (k = 0; k < 1024; k = k + 1) begin
            @(posedge clk);
            address = k;
            data_in = (k + k) % 256;
            write = 1;
            select = 1;
        end

        // Turn off write after writing
        @(posedge clk);
        write = 0;

        // Read random addresses
        repeat (20) begin
            @(posedge clk);
            address = $random(myseed) % 1024;
            write = 0;
            select = 1;
            #1 $display ("Address: %4d, Data: %4d", address, data_out);
        end
        #1000;
        $finish;
    end
endmodule

