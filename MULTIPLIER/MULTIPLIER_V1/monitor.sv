class mul_monitor extends uvm_monitor;
    `uvm_component_utils(mul_monitor)

    virtual mul_intf mif; // interface

    uvm_analysis_port #(mul_transaction) monitor_port;
    mul_transaction trans;

    function new(string name="mul_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = mul_transaction::type_id::create("trans");
        if(!(uvm_config_db #(virtual mul_intf)::get(this, "*", "mif", mif))) begin
            `uvm_error("MONITOR CLASS", "failed to get interface handle"); 
        end

        monitor_port = new("monitor_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            #20;
            trans.a = mif.a;
            trans.b = mif.b;
            trans.y = mif.y;
            `uvm_info("MONITOR CLASS", $sformatf("a:%0d b:%0d y:%0d", trans.a, trans.b, trans.y), UVM_NONE);
            monitor_port.write(trans);
        end
    endtask: run_phase


endclass: mul_monitor