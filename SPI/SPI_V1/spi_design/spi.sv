`include "spi_ctrl.sv"
`include "spi_mem.sv"

module spi_top(
    input wr, clk, rst,
    input [7:0] addr, din,
    output [7:0] dout,
    output done, err
);

    wire mosireg, misoreg, csreg, readyreg, donereg;

    spi_ctrl ctrl_dut(wr, rst, clk, readyreg, donereg, addr, din, dout, csreg, mosireg, misoreg, done, err);
    spi_mem mem_dut(rst, clk, csreg, mosireg, misoreg, readyreg, donereg);
endmodule: spi_top
