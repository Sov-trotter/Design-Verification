class clk_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(clk_scoreboard)

    real count = 0;
    real baud_count = 0;
    bit pass = 1'b0;
    // apply a uvm analysis implementation in the the clk_scoreboard class to the clk_transaction 
    uvm_analysis_imp#(clk_transaction, clk_scoreboard) scoreboard_port;
    

    // standard constructor of a uvm component
    function new(string name = "clk_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this);
    endfunction: build_phase

    // technically this implementation should be in the run phase
    function void write(clk_transaction trans);
        baud_count = trans.period / 20; // number of ticks of is: period / clk time period
        `uvm_info("SCOREBOARD", $sformatf("Baud:%0d count:%0d", trans.baud, baud_count), UVM_NONE);
            
        // + 2 ticks in each comparison to accomodate 0->1 and 1->0 transtions
        case(trans.baud)
            4800: begin
                if(baud_count == 10418)  // 10416 + 2
                    pass = 1'b1;        
                end
            9600: begin
                if(baud_count == 5210)  // 5208 + 2
                    pass = 1'b1;        
            
            end
            14400: begin
                if(baud_count == 3474)  // 3472 + 2
                    pass = 1'b1;        
            
            end
            19200: begin
                if(baud_count == 10418)  // 10416 + 2
                    pass = 1'b1;        
            
            end
            38400: begin
                if(baud_count == 2606)  // 2604 + 2
                    pass = 1'b1;        
            
            end
            57600: begin
                if(baud_count == 870)  // 868 + 2
                    pass = 1'b1;        
            
            end
        endcase

        if(pass) begin
            `uvm_info("SCOREBOARD", "TEST PASSED", UVM_NONE);
            pass = ~pass;
        end
        else begin
            `uvm_info("SCOREBOARD", "TEST FAILED", UVM_NONE);
        end
        $display("------------------------------------------------------------");
    endfunction:write 
endclass: clk_scoreboard
