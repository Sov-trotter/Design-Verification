class alu_scoreboard extends uvm_test;
  
  `uvm_component_utils(alu_scoreboard)
  
    
  uvm_analysis_imp #(alu_sequence_item, alu_scoreboard) scoreboard_port; // imp -> implementaion port rx..
 
  alu_sequence_item transactions[$]; // queue- FIFO
  
  function new(string name = "alu_scoreboard", uvm_component parent=null);
    super.new(name, parent);
    `uvm_info("Scoreboard_CLASS", "Inside constructor", UVM_HIGH);	
  endfunction
  
  // run phase includes statements that take longer time to run
  // so it is declared as a task unlike build phase and connect phase
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("Scoreboard_CLASS", "BUILD PHASE", UVM_HIGH);	
      scoreboard_port = new("scoreboard_port", this);
  endfunction: build_phase
  
  
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("Scoreboard_CLASS", "Connect PHASE", UVM_HIGH);	
    
    // connect monitor with scoreboard
    
  endfunction: connect_phase
  
  
  
  function void write(alu_sequence_item item);
    transactions.push_back(item);
  endfunction: write
  
  
  
  
  task run_phase (uvm_phase phase);
    super.run_phase(phase);
    
    //logic
    `uvm_info("Scoreboard_CLASS", "RUN PHASE", UVM_HIGH);	
    
    forever begin
      	//get packet
      // generate expected value
      // compare it with actual value
      // and then score the transactions accordingly
      
      alu_sequence_item curr_trans;
      wait((transactions.size() != 0));
      curr_trans = transactions.pop_front();
      
      compare(curr_trans);
      
    end
  endtask: run_phase
  
  
   
  task compare(alu_sequence_item curr_trans);
    logic [7:0] expected, actual;
    
    case(curr_trans.opcode)
      
      0: begin // A+B
		expected = curr_trans.a + curr_trans.b;     
      end
      
      1: begin // A-B
		expected = curr_trans.a - curr_trans.b;         
      end
      
      2: begin // A*B
		expected = curr_trans.a * curr_trans.b;         
      end
      
      3: begin // A/B
		expected = curr_trans.a / curr_trans.b;         
      end
    endcase
    
    actual = curr_trans.result;
    
    if(actual != expected) begin
      `uvm_error("COMPARE", $sformatf("Transaction failed! ACTUAL = %d, EXPECTED = %d", actual, expected));
    end
    else begin
      `uvm_info("COMPARE", $sformatf("Transaction passed! ACTUAL = %d, EXPECTED = %d", actual, expected), UVM_LOW);
      
    end
    
  endtask:compare
   
  
endclass: alu_scoreboard