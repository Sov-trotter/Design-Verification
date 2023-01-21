`timescale 1ns/1ns

import uvm_pkg::*;
`include "uvm_macros.svh"

typedef enum bit [3:0] {
                    rand_baud_1_stop = 0,
                    rand_length_1_stop = 1,
                    length5wp = 2,
                    length6wp = 3,
                    length7wp = 4,
                    length8wp = 5,
                    length5wop = 6,
                    length6wop = 7,
                    length7wop = 8,
                    length8wop = 9,
                    rand_baud_2_stop = 11,
                    rand_length_2_stop = 12} operation_mode;

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
  uart_intf uif();

  uart_top dut(.clk(uif.clk), .rst(uif.rst), .tx_start(uif.tx_start), .rx_start(uif.rx_start), .tx_data(uif.tx_data), .baud(uif.baud), .length(uif.length), .parity_type(uif.parity_type), .parity_en(uif.parity_en),.stop2(uif.stop2),.tx_done(uif.tx_done), .rx_done(uif.rx_done), .tx_err(uif.tx_err), .rx_err(uif.rx_err), .rx_out(uif.rx_out));

    initial begin
      uvm_config_db #(virtual uart_intf)::set(null, "*", "uif", uif);
        run_test("uart_test");
    end
     
    initial begin
      uif.clk <= 0;
    end
    always #10 uif.clk = ~uif.clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end
endmodule
