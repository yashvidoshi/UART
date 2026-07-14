module tb_uart;
reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;
wire serial_line;
wire [7:0] rx_data;
wire rx_done;

tx transmitter(clk, rst, tx_start, tx_data, serial_line);
rx receiver (clk, rst, serial_line,rx_data, rx_done);

always #5 clk=~clk;

always @(posedge rx_done)
begin
    $display("=================================");
    $display("Time = %0t", $time);
    $display("Received Data = %b", rx_data);
    $display("Received Character = %c", rx_data);
    $display("=================================");
end

always @(serial_line)
begin
    $display("Time=%0t serial_line=%b", $time, serial_line);
end

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, tb_uart);

    clk=0; //initialzie
    rst=1;
    tx_data=0;
    tx_start=0;

    #20; //reset release
    rst=0;

    tx_data=8'b01001001;//send data 
    tx_start=1;

    #10;
    tx_start=0;

    #100000;
    $finish;
end
endmodule