module String_bit(
	input [55:0] 	rx_input,
	input [2:0]	number,
	input 		active,
	output[21:0]	rx_out
	);
reg [55:0]	r_rx_input;
reg [21:0]	r_rx_out = 0;
integer		temp;
integer i = 0;
assign rx_out = r_rx_out;
always @(posedge active)
begin
	temp = number;
	r_rx_input = rx_input;
	r_rx_out[9:0] = r_rx_input[7:0] - "@";

	if(r_rx_input[15:8] >= "A" & r_rx_input[15:8] <= "Z")
	begin
		r_rx_out[9:0] = r_rx_out[9:0] + (r_rx_input[15:8] - "@") * 26;
		i = 1; 
	end
	r_rx_out[19:10] = r_rx_input[((temp - 3) * 8)+:8] - "0";
	i = i + 1;
	if(r_rx_input[((temp - 4) * 8)+:8] >= "1" & r_rx_input[((temp - 4) * 8)+:8] <= "9")
	begin
		r_rx_out[19:10] = r_rx_out[19:10] + (r_rx_input[((temp - 4) * 8)+:8] - "0") * 10;
		i = i + 1;
	end
	if(r_rx_input[((temp - 5) * 8)+:8] >= "1" & r_rx_input[((temp - 5) * 8)+:8] <= "9")
	begin
		r_rx_out[19:10] = r_rx_out[19:10] + (r_rx_input[((temp - 5) * 8)+:8] - "0") * 100;
		i = i + 1;
	end
	if(r_rx_input[((temp - 2) * 8)+:8] == "/")
		r_rx_out[21:20] = 0;
	if(r_rx_input[((temp - 2) * 8)+:8] == 8'b01011100)
		r_rx_out[21:20] = 1;
	if(r_rx_input[((temp - 2) * 8)+:8] == "+")
		r_rx_out[21:20] = 2;
end
endmodule
