// agent connects sequencer and driver
class uart_agent extends uvm_agent;
  `uvm_component_utils(uart_agent)

    function new(string name="uart_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uart_driver drv;
    uart_monitor mon;
    uart_config cfg;
    uvm_sequencer #(uart_transaction) seqr; // we use the default uvm sequencer

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = uart_config::type_id::create("cfg", this);
        mon = uart_monitor::type_id::create("mon", this);

        if(cfg.is_active == UVM_ACTIVE)
        begin
            drv = uart_driver::type_id::create("drv", this);
            seqr = uvm_sequencer #(uart_transaction) ::type_id::create("seqr", this);
        end
    endfunction: build_phase    

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction:connect_phase
endclass:uart_agent