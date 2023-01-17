class mul_driver extends uvm_driver #(mul_transaction);
  `uvm_component_utils(mul_driver)

    mul_transaction trans; // data received form a sequence is stored in a container 
    virtual mul_intf mif; // interface

    function new(string name="mul_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!(uvm_config_db #(virtual mul_intf)::get(null, "*", "mif", mif))) begin
            `uvm_error("DRIVER CLASS", "Failed to access mul_intf interface");
        end
    endfunction: build_phase


    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        trans = mul_transaction::type_id::create("trans");
        forever begin // we are always ready to receive data from squencer
            seq_item_port.get_next_item(trans);
            mif.a <= trans.a;
            mif.b <= trans.b;
            `uvm_info("DRIVER CLASS", $sformatf("a:%0d b:%0d", mif.a, mif.b), UVM_NONE);
            seq_item_port.item_done();
            #20; // because dut is a comb. ckt            
        end
    endtask:run_phase
endclass: mul_driver
