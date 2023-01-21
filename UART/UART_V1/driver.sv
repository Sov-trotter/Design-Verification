class uart_driver extends uvm_driver #(uart_transaction);
  `uvm_component_utils(uart_driver)

    uart_transaction trans; // data received form a sequence is stored in a container 
    virtual uart_intf uif; // interface

    function new(string name="uart_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        trans = uart_transaction::type_id::create("trans");
        if(!(uvm_config_db #(virtual uart_intf)::get(null, "*", "uif", uif))) begin // provide access to all classes(*) with key uif
            `uvm_error("DRIVER CLASS", "Failed to access uart_intf interface");
        end
    endfunction: build_phase

    task reset_dut();
        repeat(5) begin
            uif.rst         <= 1'b1;
            uif.tx_start    <=  1'b0;
            uif.rx_start    <=  1'b0;
            uif.tx_data     <=  8'h00;
            uif.baud        <=  16'h0;
            uif.length      <=  4'h0;
            uif.parity_type <=  1'b0;
            uif.parity_en   <=  1'b0;
            uif.stop2       <=  1'b0;
            `uvm_info("DRIVER CLASS", $sformatf("System Reset BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d", trans.baud, trans.length, trans.parity_type, trans.parity_en, trans.stop2, trans.tx_data), UVM_NONE);
            @(posedge uif.clk); 
        end                            
    endtask

    task drive();
        reset_dut(); // always reset everything before the next sequence
        forever begin
            seq_item_port.get_next_item(trans);
            // remove reset but drive everything from trans to interface/dut
            uif.rst         <= 1'b0;
            uif.tx_start    <= trans.tx_start;
            uif.rx_start    <= trans.rx_start;
            uif.tx_data     <= trans.tx_data;
            uif.baud        <= trans.baud;
            uif.length      <= trans.length;
            uif.parity_type <= trans.parity_type;
            uif.parity_en   <= trans.parity_en;
            uif.stop2       <= trans.stop2;
            `uvm_info("DRIVE", $sformatf("Driving data : BAUD:%0d LEN:%0d PAR_T:%0d PAR_EN:%0d STOP:%0d TX_DATA:%0d", trans.baud, trans.length, trans.parity_type, trans.parity_en, trans.stop2, trans.tx_data), UVM_NONE);
            @(posedge uif.clk); // match the delay for reset and normal operation 
            @(posedge uif.tx_done); // posedge because tx_done is not crucial in determining whether next seq should be driven or not
            @(negedge uif.rx_done); // negedge to assure that reception is fully complete
            seq_item_port.item_done();
        end
    endtask:drive

    task run_phase(uvm_phase phase);
        drive();
    endtask: run_phase
endclass: uart_driver
