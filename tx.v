module tx(input clk, input rst, input tx_start, input [7:0] tx_data, output reg tx);

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
    if(rst)begin //RESET
        state<=IDLE;
        tx<=1'b1; //idle=high=1
        clk_count<=0;
        bit_index<=0;
        data_reg<=0;
    end

    else begin
        case(state)
        IDLE: begin
            tx<=1'b1; //keeps high forver
            clk_count<=0;
            bit_index<=0;

            if(tx_start) begin
                data_reg<=tx_data;
                state<=START;
            end
        end

        START: begin
            tx<=1'b0;

            if(clk_count<CLKS_PER_BIT-1)begin
                clk_count<=clk_count+1;
            end    

            else begin   
                clk_count<=0;
                state<=DATA;
            end    
            end
     


        DATA: begin
            tx<=data_reg[bit_index];

            if(clk_count<CLKS_PER_BIT-1)
            begin
                clk_count<=clk_count+1;
            end

            else begin
                clk_count<=0;

                if(bit_index<7)
                begin
                    bit_index<=bit_index+1;
                end

                else begin
                    bit_index<=0;
                    state<=STOP;
                end
            end
        end

        STOP: begin
            tx<=1'b1;
            
            if(clk_count<CLKS_PER_BIT-1) begin
                clk_count<=clk_count+1;
            end

            else begin
                clk_count<=0;
                state<=IDLE;
            end
        end
        endcase

end
end
endmodule

