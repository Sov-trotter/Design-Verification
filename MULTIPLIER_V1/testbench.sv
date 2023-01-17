`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"


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
  mul_intf mif();

  mul dut(.a(mif.a), .b(mif.b), .y(mif.y));

    initial begin
      uvm_config_db #(virtual mul_intf)::set(null, "*", "mif", mif);
        run_test("mul_test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
      	#10000 $finish; // kill the sim otherwise dump.vcd is never generated
    end
endmodule
