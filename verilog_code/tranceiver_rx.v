module transeiver_rx(
	input 		clock,
	input		reset,
	input 		rx_finish,
	input	[7:0]	rx_byte,
	output	[21:0]	move_out,
	output 		color,
	output 		end_receive
	);

parameter s_IDLE 	= 3'b000;
parameter s_RECEIVE_DATA= 3'b001;
parameter s_SET_COLOR	= 3'b010;
parameter s_STOP_RECEIVE= 3'b011;
parameter s_END		= 3'b100;

reg [2:0]	number = 0;
reg		r_active = 0;
reg [2:0]	r_SM_Main = 0;
reg 		r_color;
reg 		r_end_receive;
reg [21:0]	r_move_out;
reg [55:0]	r_input_data;
integer 	index = 0;

assign end_receive = r_end_receive;
assign color = r_color;
assign active = r_active;

String_bit inst(
	.number(number),
	.rx_input(r_input_data),
	.active(r_active),
	.rx_out(move_out)
	);

always @(posedge clock)
begin
	if(reset == 1)
		r_SM_Main = s_IDLE;
	
	case(r_SM_Main)
	s_IDLE :
	begin
		r_end_receive = 0;
		if(rx_finish == 1)
			r_SM_Main = s_RECEIVE_DATA;
		else	
			r_SM_Main = s_IDLE;
	end
	
	s_RECEIVE_DATA :
	begin
		r_input_data[(index * 8)+:8] = rx_byte;
		number = number + 1;
		if(r_input_data[(index*8)+:8] == "\n")
			if(r_input_data[7:0] == "-")
				r_SM_Main = s_SET_COLOR;
			else
			begin
				r_active = 1;
				r_SM_Main = s_STOP_RECEIVE;
			end
		else
			r_SM_Main = s_IDLE;
		index = index + 1;
	end

	s_SET_COLOR :
	begin
		if(r_input_data[15:8] == "W")
			r_color = 0;
		else 
			r_color = 1;
		r_end_receive = 1;
		r_SM_Main = s_END;
	end

	s_STOP_RECEIVE :
	begin
		r_end_receive = 1;
		r_SM_Main = s_END; 
	end
	
	s_END :
	begin
		number = 0;
		r_active = 0;
		r_SM_Main = s_IDLE;
	end

	endcase
	
end
endmodule
