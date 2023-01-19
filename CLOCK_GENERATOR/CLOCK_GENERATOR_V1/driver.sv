class clk_driver extends uvm_driver #(clk_transaction);
  `uvm_component_utils(clk_driver)

    clk_transaction trans; // data received form a sequence is stored in a container 
    virtual clk_intf cif; // interface

    function new(string name="clk_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = clk_transaction::type_id::create("trans");
        if(!(uvm_config_db #(virtual clk_intf)::get(null, "*", "cif", cif))) begin // provide access to all classes(*) with key cif
            `uvm_error("DRIVER CLASS", "Failed to access clk_intf interface");
        end
    endfunction: build_phase


    task run_phase(uvm_phase phase);
        forever begin // we are always ready to receive data from squencer
            seq_item_port.get_next_item(trans);
            
            if(trans.oper == reset_asserted) begin
                cif.rst = 1'b1;
                @(posedge cif.clk); // wait for single positive edge
            end
            else if (trans.oper == randon_baud) begin
                `uvm_info("DRIVER CLASS",$sformatf("Baud : %0d",trans.baud), UVM_NONE);
                cif.rst <= 1'b0;
                cif.baud <= trans.baud;
                @(posedge cif.clk);

                // wait for 2 clock edges of the output/slower clock so that
                // we have something for comparison in the monitor and scoreboard 
                @(posedge cif.tx_clk);
                @(posedge cif.tx_clk);
            end
            seq_item_port.item_done();
        end
    endtask:run_phase
endclass: clk_driver
