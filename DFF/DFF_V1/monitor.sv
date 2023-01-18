class dff_monitor extends uvm_monitor;
    `uvm_component_utils(dff_monitor)

    virtual dff_intf dif; // interface

    uvm_analysis_port #(dff_transaction) monitor_port;
    dff_transaction trans;

    function new(string name="dff_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = dff_transaction::type_id::create("trans");
        if(!(uvm_config_db #(virtual dff_intf)::get(this, "*", "dif", dif))) begin
            `uvm_error("MONITOR CLASS", "failed to get interface handle"); 
        end

        monitor_port = new("monitor_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            repeat(2) @(posedge dif.clk);
            trans.rst = dif.rst;
            trans.din = dif.din;
            trans.dout = dif.dout;
            `uvm_info("MONITOR", $sformatf("rst:%0d din:%0d dout:%0d", trans.rst, trans.din, trans.dout), UVM_NONE);
            monitor_port.write(trans);
        end
    endtask: run_phase
endclass: dff_monitor
