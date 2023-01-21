class uart_env extends uvm_env;
    `uvm_component_utils(uart_env)

    uart_agent agnt;
    uart_scoreboard scb;
    
    function new(string name="uart_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agnt=uart_agent::type_id::create("agnt", this);
        scb=uart_scoreboard::type_id::create("scb", this);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnt.mon.monitor_port.connect(scb.scoreboard_port);
    endfunction: connect_phase

endclass: uart_env
