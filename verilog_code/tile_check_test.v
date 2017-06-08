module tile_check_test;


wire [5:0] tile_type;
wire endsignal;
reg [2:0] left_tile, up_tile, right_tile, down_tile;

tile_check t1(tile_type,endsignal, , up_tile, down_tile, right_tile, left_tile, );

initial
begin
	up_tile = 3'b001;	left_tile = 3'b000;	right_tile = 3'b000;	down_tile = 3'b000;
#15	up_tile = 3'b001;	left_tile = 3'b000;	right_tile = 3'b000;	down_tile = 3'b010;
#15    	up_tile = 3'b000;	left_tile = 3'b011;	right_tile = 3'b110;	down_tile = 3'b000;	
end
endmodule






