module clk_gen(
    input clk,
    input rst, 
    input [16:0] baud,
    output tx_clk
);
    // assumption is that we will need to down convert the input clock
    // and baud rate is lower than input clock 
    reg t_clk = 0; // stores the state of a clk
    int tx_max = 0; // temp variable to store wait period of the clk 
    int tx_count = 0; // ticks elapsed so far

    always@(posedge clk) begin
        if(rst) begin
            tx_max <= 0;
        end
        else begin
            case(baud) 
                // hardcoding the baudrates and tx_max for given clk = 50MHz
                4800: begin
                    tx_max <= 14'd10416;
                end
                9600: begin
                    tx_max <= 14'd5208;
                end
                14400: begin
                    tx_max <= 14'd3472;
                end
                19200: begin
                    tx_max <= 14'd10416;
                end
                38400: begin
                    tx_max <= 14'd2604;
                end
                57600: begin
                    tx_max <= 14'd868;
                end
                default: begin
                    tx_max <= 14'd5208; // default baud rate is 9600
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            tx_count <= 0;
            t_clk    <= 0;
        end
        else begin
            if(tx_count < tx_max/2) begin
                tx_count <= tx_count + 1;
            end
            else begin
                t_clk <= ~t_clk;
                tx_count <= 0;    
            end
        end
    end

    assign tx_clk = t_clk; 
endmodule