class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)
    uvm_analysis_imp#(uart_transaction, uart_scoreboard) scoreboard_port;
    
    // standard constructor of a uvm component
    function new(string name = "uart_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this);
    endfunction: build_phase

    // technically this implementation should be in the run phase
    function void write(uart_transaction trans);
        if(trans.rst == 1'b1)
            `uvm_info("SCOREBOARD", "System Reset", UVM_NONE)
        else if(trans.tx_data == trans.rx_out)
            `uvm_info("SCOREBOARD", "Test Passed", UVM_NONE)
        else
            `uvm_error("SCOREBOARD", "Test Failed")
        $display("------------------------------------------------------------");
    endfunction:write 
endclass: uart_scoreboard
