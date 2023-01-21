class uart_transaction extends uvm_sequence_item;
    `uvm_object_utils(uart_transaction)

    rand operation_mode oper;
    logic tx_start, rx_start;
    logic rst;
    rand logic [7:0] tx_data;
    rand logic [16:0] baud;
    rand logic [3:0] length;
    rand logic parity_type, parity_en;
    logic stop2;
    logic tx_done, rx_done, tx_err, rx_err;
    logic [7:0] rx_out;


    constraint baud_c {baud inside {4800, 9600, 14400, 19200, 38400, 57600};}
    constraint length_c {length inside {5, 6, 7, 8};}

    function new(string name="uart_transaction");
        super.new(name);
    endfunction: new
    

endclass: uart_transaction
