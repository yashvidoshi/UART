module uart_tx (
    input  logic       clk,
    input  logic       rst,
    input  logic       tx_en,
    input  logic       Wrt,
    input  logic [7:0] p_data,
    output logic       s_data
);

    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } tx_state_t;

    tx_state_t state;
    logic [2:0] bit_idx;
    logic [7:0] tx_buffer;
    logic       wrt_pending;

    always_ff @(posedge clk) begin
        if (!rst) begin
            state       <= IDLE;
            bit_idx     <= 3'd0;
            tx_buffer   <= 8'h00;
            s_data      <= 1'b1;
            wrt_pending <= 1'b0;
        end else begin
            // Capture write request
            if (Wrt) begin
                wrt_pending <= 1'b1;
                tx_buffer   <= p_data;
            end

            case (state)
                IDLE: begin
                    s_data  <= 1'b1;
                    bit_idx <= 3'd0;
                    if ((Wrt || wrt_pending) && tx_en) begin
                        s_data      <= 1'b0; // Start bit
                        state       <= START;
                        wrt_pending <= 1'b0;
                    end
                end

                START: begin
                    s_data <= 1'b0; // Hold start bit for 1 bit period
                    if (tx_en) begin
                        s_data  <= tx_buffer[0];
                        bit_idx <= 3'd0;
                        state   <= DATA;
                    end
                end

                DATA: begin
                    s_data <= tx_buffer[bit_idx];
                    if (tx_en) begin
                        if (bit_idx < 3'd7) begin
                            bit_idx <= bit_idx + 1'b1;
                            s_data  <= tx_buffer[bit_idx + 1'b1];
                        end else begin
                            s_data <= 1'b1; // Stop bit
                            state  <= STOP;
                        end
                    end
                end

                STOP: begin
                    s_data <= 1'b1; // Hold stop bit
                    if (tx_en) begin
                        state <= IDLE;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
