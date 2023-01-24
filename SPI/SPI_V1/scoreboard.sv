class spi_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(spi_scoreboard)
    uvm_analysis_imp#(spi_transaction, spi_scoreboard) scoreboard_port;
    bit [7:0] arr[32] = '{default:0}; // this is the sample memory
    bit [7:0] addr    = 0;
    bit [7:0] data_rd = 0;
    

    // standard constructor of a uvm component
    function new(string name = "spi_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction
  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard_port = new("scoreboard_port", this);
    endfunction: build_phase

    // technically this implementation should be in the run phase
    function void write(spi_transaction trans);
        if(trans.oper == rstdut) begin
            `uvm_info("SCOREBOARD", "System Reset", UVM_NONE);
        end
        
        else if(trans.oper == writed) begin
            if(trans.err == 1'b1) begin
                `uvm_info("SCOREBOARD", "Mem Error Reported during WRITE OPERATION", UVM_NONE);
            end

            else begin
                arr[trans.addr] = trans.din;
                `uvm_info("SCOREBOARD", $sformatf("DATA WRITE OPERATION  addr:%0d, wdata:%0d arr_wr:%0d",trans.addr,trans.din,  arr[trans.addr]), UVM_NONE);
            end
        end

        else if(trans.oper == readd) begin
            if(trans.err == 1'b1) begin
                `uvm_info("SCOREBOARD", "Mem Error Reported during READ OPERATION", UVM_NONE);
            end
            else begin
                data_rd = arr[trans.addr];
                if(trans.dout == data_rd) begin
                    `uvm_info("SCOREBOARD", $sformatf("DATA READ OPERATION  SUCCESSFUL addr:%0d, rdata:%0d",trans.addr,trans.dout), UVM_NONE);
                end
                else begin
                    `uvm_error("SCOREBOARD", $sformatf("TEST FAILED : addr:%0d, rdata:%0d data_rd_arr:%0d",trans.addr,trans.dout,data_rd));
                end
            end
        end
        $display("------------------------------------------------------------");
    endfunction:write 
endclass: spi_scoreboard
