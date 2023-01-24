`timescale 1ns/1ns
`include "spi.sv"

module spi_tb();
    reg clk = 0, rst;
    reg wr;
    wire done, err;
    reg [7:0] addr, din;
    wire [7:0] dout;

    spi_top dut(wr, clk, rst, addr, din, dout, done, err);

    always #10 clk = ~clk;
 
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars();
        rst = 1'b1;
        repeat(5) @(posedge clk);

        rst = 1'b0;
        wr = 1'b1;
        addr = 8'd25;
        din = 8'd25;

        @(posedge done);
        
        wr = 1'b0;
        addr = 8'd25;
        @(posedge done);
        
        $display("Stored Data is: %d", dout);
        #1000 $finish();
    end
endmodule: spi_tb