`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum bit [1:0] {reset_asserted = 0, randon_baud = 1} operation_mode;

`include "interface.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "test.sv"

module top;
  clk_intf cif();

  clk_gen dut(.clk(cif.clk), .rst(cif.rst), .baud(cif.baud), .tx_clk(cif.tx_clk));

    initial begin
      uvm_config_db #(virtual clk_intf)::set(null, "*", "cif", cif);
        run_test("clk_test");
    end
     
    initial begin
      cif.clk <= 0;
    end
    always #10 cif.clk = ~cif.clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule
