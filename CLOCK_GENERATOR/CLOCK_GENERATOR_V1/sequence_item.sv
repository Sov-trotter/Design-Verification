class clk_transaction extends uvm_sequence_item;
    `uvm_object_utils(clk_transaction)

    operation_mode oper;
    rand logic [16:0] baud;
    logic tx_clk;
    real period;

    constraint baud_c {baud inside {4800, 9600, 14400, 19200, 38400, 57600};}
    
    function new(string name="clk_transaction");
        super.new(name);
    endfunction: new
    
endclass: clk_transaction
