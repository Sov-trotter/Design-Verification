import uvm_pkg::*;
class dff_transaction extends uvm_sequence_item;
    `uvm_object_utils(dff_transaction)

    rand bit rst;
    rand bit din;
         bit dout;

    function new(string name="dff_transaction");
        super.new(name);
    endfunction: new
    
endclass: dff_transaction
