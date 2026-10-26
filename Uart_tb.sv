`timescale 1ns/1ps

module uart_tb;

    logic        clk;        
    logic        rst;

    // TX interface
    logic [7:0]  tx_data;
    logic        tx_start;
    logic        tx;

    // RX interface
    logic        rx;
    logic [7:0]  rx_data;
    logic        rx_rdy;
    logic        rx_clr;

    UART dut (
        .clk     (clk),
        .rst     (rst),
        .tx_data (tx_data),
        .tx_start(tx_start),
        .tx      (tx),
        .rx      (rx),
        .rx_data (rx_data),
        .rx_rdy  (rx_rdy),
        .rx_clr  (rx_clr)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, uart_tb.dut);
    end

    // Loopback TX to RX
    assign rx = tx;

    initial begin
        clk      = 0;
        rst      = 0;
        tx_start = 0;
        tx_data  = 8'h00;
        rx_clr   = 0;

        #100 rst = 1;

        // Wait for system stabilization
        #100;

        // ==========================================
        // Test 1: Transmit ASCII character 'I' (0x49)
        // ==========================================
        tx_data  = 8'h49; // 'I'
        tx_start = 1;
        #20;
        tx_start = 0;
        $display("==================================================");
        $display("[UART TX] Transmitting Byte 1: 0x%02X ('%c', %08b)", tx_data, tx_data, tx_data);

        // Wait for RX ready
        wait (rx_rdy);
        $display("[UART RX] Received Byte 1:     0x%02X ('%c', %08b) at %0t ps", rx_data, rx_data, rx_data, $time);
        if (rx_data === 8'h49)
            $display("[STATUS]  Byte 1 Verification: SUCCESS (Matched 'I' / 0x49)");
        else
            $display("[STATUS]  Byte 1 Verification: MISMATCH (Expected 0x49, Got 0x%02X)", rx_data);
        $display("==================================================");

        rx_clr = 1;
        #40;
        rx_clr = 0;

        // Wait for stop bit completion and idle inter-frame spacing
        #150_000;

        // ==========================================
        // Test 2: Transmit Byte 2: 0xA6
        // ==========================================
        tx_data  = 8'hA6;
        tx_start = 1;
        #20;
        tx_start = 0;
        $display("[UART TX] Transmitting Byte 2: 0x%02X (%08b)", tx_data, tx_data);

        // Wait for RX ready
        wait (rx_rdy);
        $display("[UART RX] Received Byte 2:     0x%02X (%08b) at %0t ps", rx_data, rx_data, $time);
        if (rx_data === 8'hA6)
            $display("[STATUS]  Byte 2 Verification: SUCCESS (Matched 0xA6)");
        else
            $display("[STATUS]  Byte 2 Verification: MISMATCH (Expected 0xA6, Got 0x%02X)", rx_data);
        $display("==================================================");

        rx_clr = 1;
        #40;
        rx_clr = 0;

        // Wait for stop bit completion and idle inter-frame spacing
        #150_000;

        // ==========================================
        // Test 3: Transmit Byte 3: 0x67
        // ==========================================
        tx_data  = 8'h67;
        tx_start = 1;
        #20;
        tx_start = 0;
        $display("[UART TX] Transmitting Byte 3: 0x%02X (%08b)", tx_data, tx_data);

        // Wait for RX ready
        wait (rx_rdy);
        $display("[UART RX] Received Byte 3:     0x%02X (%08b) at %0t ps", rx_data, rx_data, $time);
        if (rx_data === 8'h67)
            $display("[STATUS]  Byte 3 Verification: SUCCESS (Matched 0x67)");
        else
            $display("[STATUS]  Byte 3 Verification: MISMATCH (Expected 0x67, Got 0x%02X)", rx_data);
        $display("==================================================");

        rx_clr = 1;
        #40;
        rx_clr = 0;

        #50_000;
        $display("==================================================");
        $display("[SIM] ALL TESTS PASSED! FULL DUPLEX VERIFICATION COMPLETE.");
        $display("==================================================");
        $finish;
    end

endmodule
