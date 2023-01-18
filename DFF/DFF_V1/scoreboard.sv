class dff_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(dff_scoreboard)

    // apply a uvm analysis implementation in the the dff_scoreboard class to the dff_transaction 
    uvm_analysis_imp#(dff_transaction, dff_scoreboard) scoreboard_port;
  
    // standard constructor of a uvm component
    function new(string name = "dff_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this);
    endfunction: build_phase

    // technically this implementation should be in the run phase
    function void write(dff_transaction trans);
        `uvm_info("SCOREBOARD", $sformatf("rst:%0d din:%0d dout:%0d", trans.rst, trans.din, trans.dout), UVM_NONE);
        if(trans.rst == 1'b1) begin
            `uvm_info("SCOREBOARD", "DFF RESET", UVM_NONE);
        end
        else if (trans.rst == 1'b0 && (trans.din == trans.dout)) begin
            `uvm_info("SCOREBOARD", $sformatf("Transaction passed! din = %d dout %d", trans.din, trans.dout), UVM_NONE);
        end
        else begin
            `uvm_error("SCOREBOARD", $sformatf("Transaction failed! din %d,  dout %d", trans.din, trans.dout));
        end
        $display("------------------------------------------------------------");
    endfunction:write 
endclass: dff_scoreboard
