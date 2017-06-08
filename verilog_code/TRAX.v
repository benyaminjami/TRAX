module TRAX(
	input 	rx,
	output	tx,
	input clock 
	);


reg		set_color = 0;
reg		r_color = 0;
reg [3:0]	r_SM_Main = 0;
reg [21:0] 	r_send_move;
reg		r_start_transmit;
reg		r_reset;
reg [21:0]	r_receive_move;

reg [2:0]	board [C.B_width:0][C.B_height:0];

parameter	s_IDLE = 3'b000;
parameter	s_SET_Color = 3'b001;
parameter	s_RECEIVED_Tile = 3'b010;


tranceiver inst_tranceiver(
	.rx(rx),
	.move_in(r_send_move),
	.start_transmit(r_start_transmit),
	.clock(clock),
	.reset(r_reset),
	.tx(tx),
	.move_out(move_out),
	.end_receive(end_receive),
	.color(color)
	);

constants C();

always @(posedge clock)
begin
	case(r_SM_Main)
	s_IDLE :
	begin
		if(end_receive == 1)
			if(set_color == 0)
				r_SM_Main = C.T_empty;
			else
				r_SM_Main = s_RECEIVED_Tile;

	end

	s_SET_Color :
	begin
		r_color = color;
		set_color = 1;
		r_SM_Main = s_IDLE;
	end

	s_RECEIVED_Tile:
	begin
		
	end

	default
		r_SM_Main = s_IDLE;

	endcase
end
endmodule
