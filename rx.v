module rx(input clk, input rst, input rx, output reg [7:0] rx_data, output reg rx_done);

parameter CLKS_PER_BIT = 104;

localparam IDLE = 0; //STATES
localparam START = 1;
localparam DATA = 2;
localparam STOP = 3;

reg [1:0] state; //registers
reg [7:0] clk_count;
reg [2:0] bit_index;
reg [7:0] data_reg;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        state<=IDLE;
        clk_count<=0;
        bit_index<=0;
        data_reg<=0;
        rx_data<=0;
        rx_done<=0;
    end

    else begin
        case(state) 
        IDLE: begin
            rx_done<=0;
            clk_count<=0;
            bit_index<=0;

            if(rx==0) begin //start bit detection
                state<=START;
            end
            else begin
                state<=IDLE;
            end
        end
        
        START: begin
            if(clk_count==(CLKS_PER_BIT-1)/2) begin
                clk_count<=0;

                if(rx==0)
                    state<=DATA;
                else 
                    state<=IDLE;
            end
            else begin
                clk_count<=clk_count+1;
                state<=START;
            end
        end

        DATA: begin
            if(clk_count<CLKS_PER_BIT-1) begin
                clk_count<=clk_count+1;
                state<=DATA;
            end

            else begin 
                clk_count<=0;
                data_reg[bit_index]<=rx;

                if(bit_index<7) begin
                    bit_index<=bit_index+1;
                    state<=DATA;
                end

                else begin
                    bit_index<=0;
                    state<=STOP;
                end
            end
        end

        STOP: begin
            if(clk_count<CLKS_PER_BIT-1) begin
                clk_count<=clk_count+1;
                state<=STOP;
            end

            else begin
                rx_data<=data_reg;
                rx_done<=1;
                clk_count<=0;
                state<=IDLE;
            end
    end



        endcase
    end
end

endmodule