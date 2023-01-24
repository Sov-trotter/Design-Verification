// agent connects sequencer and driver
class spi_agent extends uvm_agent;
  `uvm_component_utils(spi_agent)

    function new(string name="spi_agent", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    spi_driver drv;
    spi_monitor mon;
    spi_config cfg;
    uvm_sequencer #(spi_transaction) seqr; // we use the default uvm sequencer

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cfg = spi_config::type_id::create("cfg", this);
        mon = spi_monitor::type_id::create("mon", this);

        if(cfg.is_active == UVM_ACTIVE)
        begin
            drv = spi_driver::type_id::create("drv", this);
            seqr = uvm_sequencer #(spi_transaction) ::type_id::create("seqr", this);
        end
    endfunction: build_phase    

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction:connect_phase
endclass:spi_agent