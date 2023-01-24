// ready - mem is ready to send data to controller
// op_done - data written to memory
module spi_ctrl(
    input wr, rst, clk, ready, op_done,
    input [7:0] addr, din, 
    output [7:0] dout,
    output reg cs, mosi,  
    input miso,
    output reg done, err
);

    reg [16:0] din_reg; // 8 data + 8 addr + wr/rd;
    reg [7:0] dout_reg;
    
    integer count = 0;
    
    typedef enum bit [2:0] {
        idle = 0,
        load = 1, 
        check_op = 2,
        send_data = 3,
        send_addr = 4,
        read_data = 5,
        error = 6,
        check_ready = 7} state_type;

        state_type state = idle;

    // cs(chip select) logic
    always @(posedge clk) begin
        if(rst) begin
            state <= idle;
            count <= 0;
            cs <= 1'b1;
            mosi <= 1'b0;
            err <= 1'b0;
            done <= 1'b0;
        end
        else begin
            case(state)
                idle: begin
                    cs <= 1'b1;
                    mosi <= 1'b0;
                    state <= load;
                    err <= 1'b0;
                    done <= 1'b0;
                end

                load: begin
                    din_reg <= {din, addr, wr};
                    state <= check_op;
                end

                // check operation
                check_op: begin
                    if(wr == 1'b1 && addr < 32) begin
                        cs <= 1'b0; // cs = 0 selects the memory
                        state <= send_data;
                        end
                    else if(wr == 1'b0 && addr < 32) begin
                        cs <= 1'b0; // cs = 0 selects the memory
                        state <= send_addr;
                        end
                    else begin
                        state <= error;
                        cs <= 1'b1; 
                    end
                end

                send_data: begin
                    if(count <= 16) begin
                        // non blocking assignment so order of count statement doesn't matter
                        count <= count + 1;
                        mosi <= din_reg[count]; // bit from ctrl to mem
                        state = send_data;  // stay in the same state
                    end
                    else begin
                        cs <= 1'b1; 
                        mosi <= 1'b0;
                        if(op_done) begin // received from the mem
                            count <= 0;
                            done <= 1'b1;
                            state <= idle;
                        end
                        else // wait in the same state till op_done received
                            state <= send_data;
                    end
                end

                send_addr: begin
                    if(count <= 8) begin // 9 bits = 8 addr + 1 mode
                        count <= count + 1;
                        mosi <= din_reg[count];
                        state <= send_addr;
                    end
                    else begin
                        count <= 0;
                        cs <= 1'b1;
                        state <= check_ready;
                    end
                end

                read_data: begin
                    if(count <= 7) begin
                            count <= count + 1;
                            dout_reg[count] <= miso;
                            state <= read_data;
                        end
                    else begin
                        count <= 0;
                        done <= 1'b1;
                        state <= idle;
                    end
                end

                check_ready: begin
                    if(ready)
                        state <= read_data;
                    else
                        state <= check_ready;
                end

                error: begin
                    err <= 1'b1;
                    count <= 1'b0;
                    state <= idle; 
                end

                default: begin
                    state <= idle;
                    count <= 0;
                end
            endcase
        end
    end

    assign dout = dout_reg;
endmodule: spi_ctrl