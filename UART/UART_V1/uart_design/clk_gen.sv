module clk_gen(
    input clk,
    input rst, 
    input [16:0] baud,
    output reg tx_clk, rx_clk
);
    // assumption is that we will need to down convert the input clock
    // and baud rate is lower than input clock 
    
    int tx_max = 0, rx_max = 0; // temp variable to store wait period of the clk 
    int tx_count = 0, rx_count = 0; // ticks elapsed so far

    always@(posedge clk) begin
        if(rst) begin
            tx_max <= 0;
            rx_max <= 0;
        end
        else begin
            case(baud) 
                // hardcoding the baudrates rx_max and tx_max for given clk = 50MHz
                4800: begin
                    rx_max <= 11'd651; // 10416 / 16
                    tx_max <= 14'd10416;
                end
                9600: begin
                    rx_max <= 11'd325;
                    tx_max <= 14'd5208;
                end
                14400: begin
                    rx_max <= 11'd217;
                    tx_max <= 14'd3472;
                end
                19200: begin
                    rx_max <= 11'd163;
                    tx_max <= 14'd10416;
                end
                38400: begin
                    rx_max <= 11'd81;
                    tx_max <= 14'd2604;
                end
                57600: begin
                    rx_max <= 11'd54;
                    tx_max <= 14'd868;
                end
                115200: begin 
                    rx_max <=11'd27;
                    tx_max <=14'd434;	
                end
				128000: begin 
                    rx_max <=11'd24;
                    tx_max <=14'd392;	
                end
                default: begin
                    rx_max <= 11'd325;
                    tx_max <= 14'd5208; // default baud rate is 9600
                end
            endcase
        end
    end

    always @(posedge clk) begin
        if(rst) begin
            rx_max   <= 0;
            rx_count <= 0;
        end
        else begin
            if(rx_count < rx_max) begin
                rx_count <= rx_count + 1;
            end
            else begin
                rx_count <= 0;    
            end
        end
    end

    assign rx_clk = (rx_count == rx_max) ? 1'b1 : 1'b0; 
    
    always @(posedge clk) begin
        if(rst) begin
            tx_max   <= 0;
            tx_count <= 0;
        end
        else begin
            if(tx_count < tx_max) begin
                tx_count <= tx_count + 1;
            end
            else begin
                tx_count <= 0;    
            end
        end
    end
    assign tx_clk = (tx_count == tx_max) ? 1'b1 : 1'b0; 

endmodule