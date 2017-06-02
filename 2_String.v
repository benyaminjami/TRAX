module bit_String(
	input[21:0]	move_in,
	input 		active,
	output[55:0]	tx_out
	);
reg [21:0]	r_move_in;
parameter	size = 0;
reg [55:0]	r_tx_out;
reg [5:0] 	temp;
always @(posedge active)
begin
	r_move_in = move_in;
	r_tx_out[7:0] = "@" + (r_move_in[9:0]%26);
	r_tx_out[15:8] = (r_move_in[9:0] / 26) > 0 ? "@" + r_move_in[9:0] / 26 : 0;
	r_tx_out[39:32] = (r_move_in[19:10] % 10) + "0";
	r_tx_out[31:24] = (r_move_in[19:10] / 10) > 0 ? (r_move_in[19:10] / 10) % 10 + "0" : 0;
	r_tx_out[23:16] = (r_move_in[19:10] / 100) > 0 ? (r_move_in[19:10] / 100) % 10 + "0" : 0;
	if(r_move_in[21:20] == 2'b00)
		r_tx_out[47:40] = "/";
	if(r_move_in[21:20] == 2'b01)
		r_tx_out[47:40] = 8'b01011100;
	if(r_move_in[21:20] == 2'b10)
		r_tx_out[47:40] = "+";
	r_tx_out[55:48] = "\n";
end
assign tx_out = r_tx_out;
endmodule
