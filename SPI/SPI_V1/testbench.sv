`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum bit [2:0] {
                      readd = 0,
                      writed = 1,
                      rstdut = 2,
                      writeerr = 3,
                      readerr = 4} operation_mode;

`include "interface.sv"
`include "config.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

module top;
  spi_intf sif();

  spi_top dut(.wr(sif.wr),
             .clk(sif.clk),
             .rst(sif.rst),
             .addr(sif.addr),
             .din(sif.din),
             .dout(sif.dout),
             .done(sif.done),
             .err(sif.err));

    initial begin
      uvm_config_db #(virtual spi_intf)::set(null, "*", "sif", sif);
        run_test("spi_test");
    end
     
    initial begin
      sif.clk <= 0;
    end
    always #10 sif.clk = ~sif.clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule
