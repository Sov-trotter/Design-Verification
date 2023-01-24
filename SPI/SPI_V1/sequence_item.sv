class spi_transaction extends uvm_sequence_item;

    rand operation_mode oper;
    logic wr, rst;
    randc logic [7:0] addr; // random-cyclic - on randomization variable values don't repeat a random value until every possible value has been assigned. 
    rand logic [7:0] din;
    rand logic [7:0] dout;
    logic done, err;

    // https://www.chipverify.com/uvm/uvm-utility-field-macros#:~:text=%60uvm_field_*%20macros%20that%20were,like%20copy%2C%20compare%20and%20print.
    // `uvm_object_utils expands to a begin and end block
    // *_begin includes implementation of other macros
    // field macros operate on class properties and provide automatic implementation
    // of core methods like copy, compare and print
    `uvm_object_utils_begin(spi_transaction)
    `uvm_field_int (wr, UVM_ALL_ON)
    `uvm_field_int (rst, UVM_ALL_ON)
    `uvm_field_int (addr, UVM_ALL_ON)
    `uvm_field_int (din, UVM_ALL_ON)
    `uvm_field_int (dout, UVM_ALL_ON)
    `uvm_field_int (done, UVM_ALL_ON)
    `uvm_field_int (err, UVM_ALL_ON)
    `uvm_field_enum(operation_mode, oper, UVM_DEFAULT)
    `uvm_object_utils_end

    constraint addr_c {addr <= 10;}
    constraint addr_c_err {addr > 31;}

    function new(string name="spi_transaction");
        super.new(name);
    endfunction: new
endclass: spi_transaction
