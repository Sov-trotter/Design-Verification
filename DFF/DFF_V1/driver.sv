class dff_driver extends uvm_driver #(dff_transaction);
  `uvm_component_utils(dff_driver)

    dff_transaction trans; // data received form a sequence is stored in a container 
    virtual dff_intf dif; // interface

    function new(string name="dff_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!(uvm_config_db #(virtual dff_intf)::get(null, "*", "dif", dif))) begin // provide access to all classes(*) with key dif
            `uvm_error("DRIVER CLASS", "Failed to access dff_intf interface");
        end
    endfunction: build_phase


    task run_phase(uvm_phase phase);
        super.run_phase(phase);

        trans = dff_transaction::type_id::create("trans");
        forever begin // we are always ready to receive data from squencer
            seq_item_port.get_next_item(trans);
            dif.rst <= trans.rst;
            dif.din <= trans.din;
            `uvm_info("DRIVER", $sformatf("rst:%0d din:%0d dout:%0d", trans.rst, trans.din, trans.dout), UVM_NONE);
            seq_item_port.item_done();
            repeat(2) @(posedge dif.clk); // WAIT FOR 2 CLOCK TICKS BEFORE SENDING NEXT SEQ TO ALLOW FOR BETTER VISUAL COMPARISON            
        end
    endtask:run_phase
endclass: dff_driver
