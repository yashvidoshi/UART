module tb_tx;

reg clk;
reg rst;
reg tx_start;
reg [7:0] tx_data;

wire tx;

tx uut(clk,rst,tx_start,tx_data,tx);

always #5 clk=~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_tx);

    clk = 0;
    rst = 1;

    tx_start = 0;
    tx_data = 8'b01000001;
    #20;
    rst = 0;

    #20;

    tx_start = 1;

    #10;

    tx_start = 0;

    #100000;

    $finish;

end
endmodule