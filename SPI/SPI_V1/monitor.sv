class spi_monitor extends uvm_monitor;
    `uvm_component_utils(spi_monitor)

    virtual spi_intf sif; // interface
    uvm_analysis_port #(spi_transaction) monitor_port;
    spi_transaction trans;

    function new(string name="spi_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = spi_transaction::type_id::create("trans");
        if(!(uvm_config_db #(virtual spi_intf)::get(this, "*", "sif", sif))) begin
            `uvm_error("MONITOR CLASS", "failed to get interface handle"); 
        end

        monitor_port = new("monitor_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge sif.clk);
            if(sif.rst) begin
                trans.oper <= rstdut;
                `uvm_info("MONITOR", "Reset Detected", UVM_NONE);
                monitor_port.write(trans);
            end

            else if(!sif.rst && sif.wr) begin
                @(posedge sif.done);
                trans.oper = writed;
                trans.din  = sif.din;
                trans.addr = sif.addr;
                trans.err  = sif.err;
                
                `uvm_info("MONITOR", $sformatf("DATA WRITE addr:%0d data:%0d err:%0d",trans.addr,trans.din,trans.err), UVM_NONE);
                monitor_port.write(trans);
            end

            // we ignore din here so that we dont feed anything unnecessary to scb
            else if(!sif.rst && !sif.wr) begin
                @(posedge sif.done);
                trans.oper = readd;
                trans.addr = sif.addr;
                trans.err  = sif.err;
                trans.dout = sif.dout;
                `uvm_info("MONITOR", $sformatf("DATA WRITE addr:%0d data:%0d err:%0d",trans.addr,trans.din,trans.err), UVM_NONE);
                monitor_port.write(trans);
            end
            
        end
    endtask: run_phase
endclass: spi_monitor
