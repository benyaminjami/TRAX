module UART(
	input	rx,
	input	send,
	input	[7:0] tx_data,
	input 	clock,
	input 	reset,
	output	tx,
	output 	tx_done,
	output 	rx_finish,
	output 	[7:0] rx_data);
	
uart_rx #(.CLKS_PER_BIT(50)) UART_RX_INST
    (.clock(clock),
     .rx(rx),
     .reset(reset),
     .rx_data(rx_data),
     .rx_finish(rx_finish)
     );

uart_tx #(.CLKS_PER_BIT(50)) UART_TX_INST
    (.clock(clock),
     .send(send),
     .tx_data(tx_data),
     .tx(tx),
     .reset(reset),
     .tx_done(tx_done)
     );
 endmodule 