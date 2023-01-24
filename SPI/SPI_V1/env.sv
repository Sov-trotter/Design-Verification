class spi_env extends uvm_env;
    `uvm_component_utils(spi_env)

    spi_agent agnt;
    spi_scoreboard scb;
    
    function new(string name="spi_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnt=spi_agent::type_id::create("agnt", this);
        scb=spi_scoreboard::type_id::create("scb", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnt.mon.monitor_port.connect(scb.scoreboard_port);
    endfunction: connect_phase

endclass: spi_env
