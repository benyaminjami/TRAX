module tranceiver_tx(
	input	[21:0]	move_in,
	input 		start_transmit,
	input 		clock,
	input 		reset,
	input		tx_done,
	output	[7:0]	tx_byte,
	output		send
	);

parameter s_IDLE 	= 2'b00;
parameter s_GET_STRING	= 2'b01;
parameter s_SEND_DATA	= 2'b10;
parameter s_WAIT	= 2'b11;



reg	[21:0]	r_move_in = 0;
reg		r_tx_done;
reg	[55:0]	r_tx_out;
reg		active = 0;
reg 	[1:0]	r_SM_Main = 0;
reg	[7:0]	r_tx_byte;
reg		r_send;
integer 	index = 0;
wire	[55:0]	string_out;
bit_String inst(.move_in(r_move_in),
		.active(active),
		.tx_out(string_out));

assign tx_byte = r_tx_byte;
assign send = r_send;

always @(posedge clock)
begin
	if(reset == 1)
		r_SM_Main = s_IDLE;
	case(r_SM_Main)
	s_IDLE :
	begin
		r_send = 0;
		if(start_transmit == 1)
		begin
			r_move_in = move_in;
			index = 0;
			active = 1;
			r_SM_Main = s_GET_STRING;
		end
		else 
			r_SM_Main = s_IDLE;
	end
	
	s_GET_STRING :
	begin
		r_tx_out = string_out;
		active = 0; 
		r_SM_Main = s_SEND_DATA;
	end
	
	s_SEND_DATA:
	begin
		if(index < 8)
		begin
			if(r_tx_out[(index*8)+:8] != 0)
			begin
				r_tx_byte = r_tx_out[(index*8)+:8];
				r_send = 1;
				r_SM_Main = s_WAIT;
			end
			index = index + 1;
		end
		else
			r_SM_Main = s_IDLE;
	end

	s_WAIT :
	begin
		r_send = 0;
		if(tx_done == 1)
			r_SM_Main = s_SEND_DATA;
		else 
			r_SM_Main = s_WAIT;
	end
	endcase
end

endmodule