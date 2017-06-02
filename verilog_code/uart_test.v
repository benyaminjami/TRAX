module uart_test;


wire tx1,tx2,tx_done1,tx_done2,rx_finish1,rx_finish2;
wire [7:0] rx_data1,rx_data2;
reg clock1 = 0;
always #5 clock1 = ~clock1;
reg send1,send2,reset1,reset2;
reg [7:0] tx_data1,tx_data2;

initial begin
tx_data1 = 8'b11110000;
tx_data2 = 8'b00001111;
send1 = 1;
send2 = 1;
end
UART u1(tx2, send1, tx_data1, clock1, reset1, tx1, tx_done1, rx_finish1, rx_data1);
UART u2(tx1, send2, tx_data2, clock1, reset2, tx2, tx_done2, rx_finish2, rx_data2);

endmodule
