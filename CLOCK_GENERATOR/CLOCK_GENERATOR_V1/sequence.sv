class rst_clk extends uvm_sequence #(clk_transaction); // rst = 1
    `uvm_object_utils(rst_clk)

    clk_transaction trans;

    function new(string name = "rst_clk");
        super.new(name);
    endfunction: new

    task body();
        repeat(5) begin
            trans = clk_transaction::type_id::create("trans");
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = reset_asserted; // make sure that reset is 1 after randomization
            finish_item(trans);
        end
    endtask:body
endclass: rst_clk

class variable_baud extends uvm_sequence #(clk_transaction);
    `uvm_object_utils(variable_baud)

    clk_transaction trans;

    function new(string name = "variable_baud");
        super.new(name);
    endfunction: new

    task body();
        repeat(5) begin
            trans = clk_transaction::type_id::create("trans");
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.oper = randon_baud; // make sure that reset is 0 after randomization
            finish_item(trans);
        end
    endtask:body
endclass: variable_baud
