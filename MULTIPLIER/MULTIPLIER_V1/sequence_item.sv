import uvm_pkg::*;
class mul_transaction extends uvm_sequence_item;
    `uvm_object_utils(mul_transaction)

    rand bit [3:0] a;
    rand bit [3:0] b;
         bit [7:0] y;

    function new(string name="mul_transaction");
        super.new(name);
    endfunction: new
    
endclass: mul_transaction
