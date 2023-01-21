class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor)

    virtual uart_intf uif; // interface
    uvm_analysis_port #(uart_transaction) monitor_port;
    uart_transaction trans;

    function new(string name="uart_monitor", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = uart_transaction::type_id::create("trans");
        if(!(uvm_config_db #(virtual uart_intf)::get(this, "*", "uif", uif))) begin
            `uvm_error("MONITOR CLASS", "failed to get interface handle"); 
        end

        monitor_port = new("monitor_port", this);
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        forever begin
            @(posedge uif.clk);
            if(uif.rst) begin
                trans.rst = 1'b1;
                `uvm_info("MONITOR", "Reset Detected", UVM_NONE);
                monitor_port.write(trans);
            end
            else begin
                @(posedge uif.tx_done);
                trans.rst         = 1'b0;
                trans.tx_start    = uif.tx_start;
                trans.rx_start    = uif.rx_start;
                trans.tx_data     = uif.tx_data;
                trans.baud        = uif.baud;
                trans.length      = uif.length;
                trans.parity_type = uif.parity_type;
                trans.parity_en   = uif.parity_en;
                trans.stop2       = uif.stop2;

                @(negedge uif.rx_done);
                trans.rx_out = uif.rx_out;

                `uvm_info("MONITOR", $sformatf("BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d RX_DATA:%0d", trans.baud, trans.length, trans.parity_type, trans.parity_en, trans.stop2, trans.tx_data, trans.rx_out), UVM_NONE);
                monitor_port.write(trans);
            end
            
        end
    endtask: run_phase
endclass: uart_monitor
