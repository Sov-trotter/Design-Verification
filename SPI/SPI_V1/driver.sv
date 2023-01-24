class spi_driver extends uvm_driver #(spi_transaction);
  `uvm_component_utils(spi_driver)

    spi_transaction trans; // data received form a sequence is stored in a container 
    virtual spi_intf sif; // interface

    function new(string name="spi_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = spi_transaction::type_id::create("trans");
        
        if(!(uvm_config_db #(virtual spi_intf)::get(this, "*", "sif", sif))) begin // provide access to all classes(*) with key sif
            `uvm_error("DRIVER CLASS", "Failed to access spi_intf interface");
        end
    endfunction: build_phase

    task reset_dut();
        repeat(5) begin
            sif.rst  <= 1'b1;
            sif.addr <=  'h0;
            sif.din  <=  'h0;
            sif.wr   <=  1'b0;
            `uvm_info("DRIVER CLASS", "System Reset - Sim Start", UVM_MEDIUM);
            @(posedge sif.clk); 
        end                            
    endtask

    task drive();
        reset_dut(); // always reset everything before the next sequence
        forever begin
            seq_item_port.get_next_item(trans);
            
            if(trans.oper == rstdut) begin
                sif.rst <= 1'b1;
                @(posedge sif.clk);
            end

            else if (trans.oper == readd) begin
                sif.rst  <= 1'b0;
                sif.addr <= trans.addr;
                sif.din  <= trans.din; // this is redundant
                sif.wr   <= 1'b0;
                @(posedge sif.clk); 
                `uvm_info("DRIVE", $sformatf("mode : Read addr:%0d din:%0d", sif.addr, sif.din), UVM_NONE);
                @(posedge sif.done);
            end
            
            else if (trans.oper == writed) begin
                sif.rst  <= 1'b0;
                sif.addr <= trans.addr;
                sif.din  <= trans.din;
                sif.wr   <= 1'b1;
                @(posedge sif.clk); 
                `uvm_info("DRIVE", $sformatf("mode : Write addr:%0d din:%0d", sif.addr, sif.din), UVM_NONE);
                @(posedge sif.done);                
            end

            seq_item_port.item_done();
        end
    endtask:drive

    task run_phase(uvm_phase phase);
        drive();
    endtask: run_phase
endclass: spi_driver
