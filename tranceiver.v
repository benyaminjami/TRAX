module tranceiver(
	input		rx,
	input [21:0]	move_in,
	input 		start_transmit,
	input 		clock,
	input 		reset,
	output		tx,
	output[21:0]	move_out,
	output		end_receive,
	output 		color
	);
wire [7:0] rx_byte,tx_data;
UART uart_inst(
	.clock(clock),
	.reset(reset),
	.rx(rx),
	.tx(tx),
	.send(send),
	.rx_data(rx_byte),
	.rx_finish(rx_finish),
	.tx_done(tx_done),
	.tx_data(tx_data)
	);
tranceiver_tx tx_inst(
	.clock(clock),
	.reset(reset),
	.move_in(move_in),
	.start_transmit(start_transmit),
	.tx_done(tx_done),
	.tx_byte(tx_data),
	.send(send)
	);
transeiver_rx rx_inst(
	.clock(clock),
	.reset(reset),
	.rx_finish(rx_finish),
	.rx_byte(rx_byte),
	.move_out(move_out),
	.color(color),
	.end_receive(end_receive)
	);
endmodule 