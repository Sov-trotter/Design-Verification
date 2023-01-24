// ready - mem is ready to send data to controller
// op_done - data written to memory
module spi_mem(
    input rst, clk, cs, miso, 
    output reg mosi, ready, op_done
);
    reg [7:0] mem [31:0];// = '{default:0};
    integer count = 0;
    reg [15:0] din;
    reg [7:0] dout;
    
    typedef enum bit [2:0] {
        idle = 0,
        detect_op = 1, 
        write_data = 2,
        read_data = 3,
        send_data = 4} state_type;

        state_type state = idle;

    always @(posedge clk) begin
        if(rst) begin
            state <= idle;
            count <= 0;
            mosi <= 1'b0;
            ready <= 1'b0;
            op_done <= 1'b0;
        end

        else begin
            case(state)
                idle: begin
                    state <= idle;
                    count <= 0;
                    mosi <= 1'b0;
                    ready <= 1'b0;
                    op_done <= 1'b0;
                    din <= 0;

                    if(!cs)
                        state <= detect_op;
                    else
                        state <= idle;
                end

                detect_op: begin 
                    // the first bit sent is LSB which is the operation wr
                    if(miso)
                        state <= write_data; // write to mem
                    else
                        state <= read_data; // read from mem
                end

                write_data: begin
                    if(count <= 15) begin
                        din[count] <= miso;
                        count = count + 1;
                        state <= write_data;
                    end 
                    else begin
                        mem[din[7:0]] = din[15:8];
                        state <= idle;
                        op_done <= 1'b1;
                        count <= 0;
                    end
                end

                read_data: begin
                    if(count <= 7) begin
                        din[count] <= miso;
                        count = count + 1;
                        state <= read_data;
                    end
                    else begin
                        dout <= mem[din];
                        ready <= 1'b1;
                        count <= 0;
                        state <= send_data;
                    end
                end

                send_data: begin
                    ready = 1'b0;
                    if(count <= 7) begin
                        count <= count + 1;
                        mosi <= dout[count];
                        state <= send_data;
                    end 
                    else begin
                        count <= 0;
                        state <= idle;
                        op_done <= 1'b1;
                    end
                end

                default: state <= idle;
            endcase
        end
    end
endmodule: spi_mem