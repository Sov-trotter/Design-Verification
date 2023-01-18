class valid_din extends uvm_sequence #(dff_transaction); // this class makes sure that rst = 0
    `uvm_object_utils(valid_din)

    dff_transaction trans;

    function new(string name = "valid_din");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = dff_transaction::type_id::create("trans");
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.rst = 1'b0; // make sure that reset is 0 after randomization
            `uvm_info("SEQ", $sformatf("rst:%0d din:%0d dout:%0d", trans.rst, trans.din, trans.dout), UVM_NONE);
            finish_item(trans);
        end
    endtask:body
endclass: valid_din

class rst_dff extends uvm_sequence #(dff_transaction); // rst = 1
    `uvm_object_utils(rst_dff)

    dff_transaction trans;

    function new(string name = "rst_dff");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = dff_transaction::type_id::create("trans");
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            trans.rst = 1'b1; // make sure that reset is 1 after randomization
            `uvm_info("SEQ", $sformatf("rst:%0d din:%0d dout:%0d", trans.rst, trans.din, trans.dout), UVM_NONE);
            finish_item(trans);
        end
    endtask:body
endclass: rst_dff

class rand_din_rst extends uvm_sequence #(dff_transaction);
    `uvm_object_utils(rand_din_rst)

    dff_transaction trans;

    function new(string name = "rand_din_rst");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = dff_transaction::type_id::create("trans");
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            `uvm_info("SEQ", $sformatf("rst:%0d din:%0d dout:%0d", trans.rst, trans.din, trans.dout), UVM_NONE);
            finish_item(trans);
        end
    endtask:body
endclass: rand_din_rst
