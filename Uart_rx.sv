module uart_rx (
    input  logic       clk,
    input  logic       rst,
    input  logic       rx,
    input  logic       rx_en,
    input  logic       rdy_clr,
    output logic [7:0] data_out,
    output logic       rdy
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } rx_state_t;

    rx_state_t state;
    logic [3:0] sample_cnt;
    logic [2:0] bit_idx;
    logic [7:0] rx_shift;

    always_ff @(posedge clk) begin
        if (!rst) begin
            state      <= IDLE;
            sample_cnt <= 4'd0;
            bit_idx    <= 3'd0;
            rx_shift   <= 8'h00;
            data_out   <= 8'h00;
            rdy        <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    sample_cnt <= 4'd0;
                    bit_idx    <= 3'd0;
                    // Detect start bit falling edge / low level
                    if (!rx) begin
                        state <= START;
                    end
                end

                START: begin
                    if (rx_en) begin
                        if (sample_cnt == 4'd7) begin
                            // Check for valid start bit (glitch rejection)
                            if (rx != 1'b0) begin
                                state      <= IDLE;
                                sample_cnt <= 4'd0;
                            end else begin
                                sample_cnt <= sample_cnt + 1'b1;
                            end
                        end else if (sample_cnt == 4'd15) begin
                            sample_cnt <= 4'd0;
                            bit_idx    <= 3'd0;
                            state      <= DATA;
                        end else begin
                            sample_cnt <= sample_cnt + 1'b1;
                        end
                    end
                end

                DATA: begin
                    if (rx_en) begin
                        if (sample_cnt == 4'd7) begin
                            // Sample data at mid-bit
                            rx_shift[bit_idx] <= rx;
                            sample_cnt        <= sample_cnt + 1'b1;
                        end else if (sample_cnt == 4'd15) begin
                            sample_cnt <= 4'd0;
                            if (bit_idx < 3'd7) begin
                                bit_idx <= bit_idx + 1'b1;
                            end else begin
                                state <= STOP;
                            end
                        end else begin
                            sample_cnt <= sample_cnt + 1'b1;
                        end
                    end
                end

                STOP: begin
                    if (rx_en) begin
                        if (sample_cnt == 4'd7) begin
                            // Valid stop bit check at mid-bit
                            if (rx == 1'b1) begin
                                data_out <= rx_shift;
                                rdy      <= 1'b1;
                            end
                            sample_cnt <= sample_cnt + 1'b1;
                        end else if (sample_cnt == 4'd15) begin
                            sample_cnt <= 4'd0;
                            state      <= IDLE;
                        end else begin
                            sample_cnt <= sample_cnt + 1'b1;
                        end
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase

            // Synchronous clear for ready flag has priority
            if (rdy_clr) begin
                rdy <= 1'b0;
            end
        end
    end

endmodule
