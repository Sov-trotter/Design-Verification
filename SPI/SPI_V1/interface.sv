interface spi_intf;
    logic wr, clk, rst;
    logic [7:0] addr, din, dout;
    logic done, err;   
endinterface: spi_intf
