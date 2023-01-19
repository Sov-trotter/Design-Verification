class clk_monitor extends uvm_monitor;
    `uvm_component_utils(clk_monitor)

    virtual clk_intf cif; // interface

    real ton;
    real toff;

    uvm_analysis_port #(clk_transaction) monitor_port;
    clk_transaction trans;

    function new(string name="clk_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = clk_transaction::type_id::create("trans");
        if(!(uvm_config_db #(virtual clk_intf)::get(this, "*", "cif", cif))) begin
            `uvm_error("MONITOR CLASS", "failed to get interface handle"); 
        end

        monitor_port = new("monitor_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge cif.clk);
            if(cif.rst) begin
                trans.oper = reset_asserted;
                ton =0;
                toff = 0;
                `uvm_info("MONITOR", "Reset Detected", UVM_NONE);
                monitor_port.write(trans);
            end
            else begin
                trans.baud = cif.baud;
                trans.oper = randon_baud;

                ton =0;
                toff = 0;
                @(posedge cif.tx_clk);
                ton = $realtime;
                @(posedge cif.tx_clk);
                toff = $realtime;
                trans.period = toff - ton;

                `uvm_info("MONITOR", $sformatf("Baud:%0d Period:%0d", trans.baud, trans.period), UVM_NONE);
                monitor_port.write(trans);
            end
            
        end
    endtask: run_phase
endclass: clk_monitor
