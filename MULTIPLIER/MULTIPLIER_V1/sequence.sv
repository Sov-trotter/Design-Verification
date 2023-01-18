class mul_sequence extends uvm_sequence #(mul_transaction);
    `uvm_object_utils(mul_sequence)

    mul_transaction trans;

    function new(string name = "mul_sequence");
        super.new(name);
    endfunction: new

    task body();
        repeat(15) begin
            trans = mul_transaction::type_id::create("trans");
            start_item(trans); //send request to sequencer that we have new data
            assert(trans.randomize());
            `uvm_info("SEQ", $sformatf("a:%0d b:%0d y:%0d", trans.a, trans.b, trans.y), UVM_NONE);
            finish_item(trans);
        end
    endtask:body
endclass: mul_sequence
