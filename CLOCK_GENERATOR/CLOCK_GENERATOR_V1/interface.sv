interface clk_intf();

    logic clk;
    logic rst;
    logic [16:0] baud;
    logic tx_clk;

endinterface: clk_intf
