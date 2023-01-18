class mul_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(mul_scoreboard)

    // apply a uvm analysis implementation in the the mul_scoreboard class to the mul_transaction 
    uvm_analysis_imp#(mul_transaction, mul_scoreboard) scoreboard_port;
  
    // standard constructor of a uvm component
    function new(string name = "mul_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this);
    endfunction: build_phase

    // technically this implementation should be in the run phase
    function void write(mul_transaction trans);
        if(trans.y == (trans.a * trans.b)) begin
            `uvm_info("SCOREBOARD", $sformatf("Transaction passed! %d %d * %d", trans.a, trans.b, trans.y), UVM_LOW);
        end
        else begin
            `uvm_error("SCOREBOARD", $sformatf("Transaction failed! y = %d,  a * b = %d * %d", trans.a, trans.b, trans.y));
        end
    endfunction:write 
endclass: mul_scoreboard
