module uart_rx(
    input rx_clk, rx_start,
    input rst,
    input rx,
    input [3:0] length,
    input parity_type, parity_en,
    input stop2,
    output reg [7:0] rx_out,
    output logic rx_done, rx_err
);

    logic [7:0] rx_data;
    logic parity = 0; // parity of received data
    int count = 0; // used to find the middle of data
    int bit_count = 0; // number of bits received so far

    typedef enum bit [2:0] {
        idle = 0,
        start_bit = 1, 
        rec_data = 2,
        check_parity = 3,
        check_first_stop = 4,
        check_sec_stop = 5,
        done = 6} state_type;

        state_type state = idle, next_state = idle;

    // reset detector
    always @(posedge rx_clk) begin
        if(rst)
            state <= idle;
        else
            state <= next_state;
    end

    // next state decoder + output decoder
    always @(*) begin 
        case(state)
            idle: begin
                // blocking statements because this is comb. ckt.
                rx_done = 1'b0;
                rx_err = 0;
                if(rx_start && !rx) // !rx => start_bit is not transmitted yet
                    next_state = start_bit;
                else
                    next_state = idle;
            end

            start_bit: begin
                // count == 7 is the middle of start bit
                if(count == 7 && rx)
                    next_state = idle;
                // if we are at the end of start bit -> tx = 16    
                else if (count == 15)
                    next_state = rec_data;
                else
                // we are still somewhere else
                    next_state = start_bit;
            end

            rec_data: begin
                // count == 7 is the middle of some data bit
                if(count == 7)
                    // rx0 xxxxxx
                    // rx1 rx0 xxxxx
                    // acts as a right shift reg
                    rx_data[7:0] = {rx, rx_data[7:1]};

                // if we are at the end of data bit -> tx = 16    
                // bit count is at the last bit...so rx all the bits
                else if (count == 15 && bit_count == (length - 1))
                    begin
                        case(length)
                            // truncate the output reg to remove garbage values
                            5: rx_out = rx_data[7:3];
                            6: rx_out = rx_data[7:2];
                            7: rx_out = rx_data[7:1];
                            8: rx_out = rx_data[7:0];
                            default: rx_out = 8'h00;
                        endcase

                        if(parity_type)
                            parity = ^rx_data;
                        else
                            parity = ~^rx_data;

                        if(parity_en)
                            next_state = check_parity;
                        else
                            next_state = check_first_stop;
                    end
                
                else
                    next_state = rec_data;
            end

            
            check_parity: begin
                if(count == 7) 
                begin
                    if(rx == parity)
                        rx_err = 1'b0;
                    else
                        rx_err = 1'b1;
                end  
                else if (count == 15) 
                    next_state = check_first_stop;
                else
                    next_state = check_parity;
            end
            
            check_first_stop : begin
                if(count == 7)
                    begin
                        if(rx != 1'b1)
                            rx_err = 1'b1;
                        else
                            rx_err = 1'b0;
                    end
                else if (count == 15)
                    begin
                        if(stop2)
                            next_state = check_sec_stop;
                        else
                            next_state = done; 
                    end
                end

            check_sec_stop: begin
                if(count == 7)
                    begin
                        if(rx != 1'b1)
                            rx_err = 1'b1;
                        else
                            rx_err = 1'b0;
                    end
                else if (count == 15)
                    next_state = done; 
                end

            done :  begin
                rx_done = 1'b1;
                next_state = idle;
                rx_err = 1'b0;
            end
        endcase
    end

    // counts handler
    always  @(posedge rx_clk) begin
        case(state)
            idle: begin
                count     <= 0;
                bit_count <= 0;
            end

            start_bit: begin 
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end
        
            rec_data: begin
                if(count < 15)
                    count <= count + 1;
                else begin
                    count <= 0;
                    bit_count <= bit_count + 1;
                end
            end  
            
            check_parity: begin
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end       
                
            check_first_stop: begin 
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end
                
            check_sec_stop: begin
                if(count < 15)
                    count <= count + 1;
                else
                    count <= 0;
            end
                
            done :  begin
                count <= 0;
                bit_count <= 0;
            end    
        endcase
    end
endmodule: uart_rx