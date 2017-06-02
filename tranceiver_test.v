module tranceiver_test;
wire tx_UART, tx_TRANCEIVER, rx_finish_UART, tx_done_UART,color,end_receive;
wire[21:0]move_out;
wire [7:0] rx_data_UART;

reg clock1 = 1, reset1, reset2, send_UART,start;
reg[21:0]move_in;
reg [7:0]tx_data1;

always #5 clock1 = ~clock1;
integer i = 0;
initial
begin
send_UART = 1;
move_in = 22'b0100100000000000011011;
start = 1;
reset1 = 0;
reset2 = 0;
for(i = 0 ; i < 7; i = i + 1)
begin
	if(i == 0)
	tx_data1 = "A";
	if(i==1)
	tx_data1 = @(posedge tx_done_UART)"A";
	if(i == 2)
	tx_data1 = @(posedge tx_done_UART)"1";
	if(i==3)
	tx_data1 = @(posedge tx_done_UART)"2";
	if(i==4)
	tx_data1 = @(posedge tx_done_UART)"8";
	if(i==5)
	tx_data1 = @(posedge tx_done_UART)"+";
	if(i==6)
	tx_data1 = @(posedge tx_done_UART)"\n";



end
end





UART u1(tx_TRANCEIVER, send_UART, tx_data1, clock1, reset1, tx_UART, tx_done_UART, rx_finish_UART, rx_data_UART);

tranceiver inst(
	.rx(tx_UART),
	.move_in(move_in),
	.start_transmit(start),
	.clock(clock1),
	.reset(reset2),
	.tx(tx_TRANCEIVER),
	.move_out(move_out),
	.end_receive(end_receive),
	.color(color)
	);


endmodule
