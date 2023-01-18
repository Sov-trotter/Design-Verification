`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"


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
  dff_intf dif();

  dff dut(.clk(dif.clk), .rst(dif.rst), .din(dif.din), .dout(dif.dout));

    initial begin
      uvm_config_db #(virtual dff_intf)::set(null, "*", "dif", dif);
        run_test("dff_test");
    end
     
    initial begin
      dif.clk = 0;
    end
    always #10 dif.clk = ~dif.clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
      	#10000 $finish; // kill the sim otherwise dump.vcd is never generated
    end
endmodule
