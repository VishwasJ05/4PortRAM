`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2025 17:10:34
// Design Name: 
// Module Name: PortRAM_tb
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

`timescale 1ns/1ps

module tb_ram_4port;
    reg clk;
    reg cs_a, wr_a, cs_b, wr_b, cs_c, wr_c, cs_d, wr_d;
    reg [9:0] addr_a, addr_b, addr_c, addr_d;
    reg [7:0] data_in_a, data_in_b, data_in_c, data_in_d;
    wire [7:0] data_out_a, data_out_b, data_out_c, data_out_d;
    wire conflict;

    ram_4port uut (
        .clk(clk),
        .cs_a(cs_a), .wr_a(wr_a), .addr_a(addr_a), .data_in_a(data_in_a), .data_out_a(data_out_a),
        .cs_b(cs_b), .wr_b(wr_b), .addr_b(addr_b), .data_in_b(data_in_b), .data_out_b(data_out_b),
        .cs_c(cs_c), .wr_c(wr_c), .addr_c(addr_c), .data_in_c(data_in_c), .data_out_c(data_out_c),
        .cs_d(cs_d), .wr_d(wr_d), .addr_d(addr_d), .data_in_d(data_in_d), .data_out_d(data_out_d),
        .conflict(conflict)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (conflict)
            $display("[CONFLICT DETECTED] @ time %0t", $time);
    end

    initial begin
        $display("=== Starting 4-Port RAM Testbench ===");

        // Reset all signals
        cs_a = 0; wr_a = 0; addr_a = 0; data_in_a = 0;
        cs_b = 0; wr_b = 0; addr_b = 0; data_in_b = 0;
        cs_c = 0; wr_c = 0; addr_c = 0; data_in_c = 0;
        cs_d = 0; wr_d = 0; addr_d = 0; data_in_d = 0;

        @(posedge clk);

        // Write different addresses: No conflict expected
        cs_a = 1; wr_a = 1; addr_a = 10; data_in_a = 8'd110;
        cs_b = 1; wr_b = 1; addr_b = 20; data_in_b = 8'd123;
        cs_c = 1; wr_c = 1; addr_c = 30; data_in_c = 8'd130;
        cs_d = 1; wr_d = 1; addr_d = 40; data_in_d = 8'd99;

        @(posedge clk);

        // Disable all writes
        cs_a = 0; wr_a = 0;
        cs_b = 0; wr_b = 0;
        cs_c = 0; wr_c = 0;
        cs_d = 0; wr_d = 0;

        @(posedge clk);

        // Read from those addresses
        cs_a = 1; wr_a = 0; addr_a = 10;
        cs_b = 1; wr_b = 0; addr_b = 20;
        cs_c = 1; wr_c = 0; addr_c = 30;
        cs_d = 1; wr_d = 0; addr_d = 40;

        @(posedge clk);

        $display("Read A (addr 10): %0d", data_out_a);
        $display("Read B (addr 20): %0d", data_out_b);
        $display("Read C (addr 30): %0d", data_out_c);
        $display("Read D (addr 40): %0d", data_out_d);

        // Priority write to same address
        cs_a = 1; wr_a = 1; addr_a = 50; data_in_a = 8'd200;
        cs_b = 1; wr_b = 1; addr_b = 50; data_in_b = 8'd201;
        cs_c = 1; wr_c = 1; addr_c = 50; data_in_c = 8'd202;
        cs_d = 1; wr_d = 1; addr_d = 50; data_in_d = 8'd203;

        @(posedge clk);

        // Disable all
        cs_a = 0; wr_a = 0;
        cs_b = 0; wr_b = 0;
        cs_c = 0; wr_c = 0;
        cs_d = 0; wr_d = 0;

        @(posedge clk);

        // Read back from same address 
        // all will read 200 bcz of shared memory
        cs_a = 1; wr_a = 0; addr_a = 50;
        cs_b = 1; wr_b = 0; addr_b = 50;
        cs_c = 1; wr_c = 0; addr_c = 50;
        cs_d = 1; wr_d = 0; addr_d = 50;

        @(posedge clk);

        $display("Read A (addr 50): %0d", data_out_a);
        $display("Read B (addr 50): %0d", data_out_b);
        $display("Read C (addr 50): %0d", data_out_c);
        $display("Read D (addr 50): %0d", data_out_d);

        $display("=== Testbench Finished ===");
        $finish;
    end
endmodule





