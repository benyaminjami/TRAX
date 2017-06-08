module tile_check(
		output reg [5:0]	tile_type,
		output reg		endsignal,
		input			start_signal,
		input	[2:0]		up_tile,
		input	[2:0]		down_tile,
		input	[2:0]		right_tile,
		input	[2:0]		left_tile,
		input			clock
		);

reg white_input = 0, black_input = 0;	//number of white or black inputs into a tile
reg empty_tile = 0 , left_white = 2, up_white = 2, right_white = 2, down_white = 2;
//tiles are slash_down , slash_up , plus_vrt , plus_hz , baskslash_up , backsalsh_down , these are based on white color
parameter slash_down = 1, slash_up = 2, plus_vrt = 3, plus_hz = 4, backslash_up = 5, backslash_down = 6;
parameter empty = 0;
initial
begin
	// chek the white inputs
	if(left_tile == slash_down || left_tile == plus_hz || left_tile == backslash_up)
	begin
		white_input = white_input + 1;
		left_white = 1;
	end

	if(up_tile == slash_down || up_tile == plus_vrt || up_tile == backslash_down)
	begin
		white_input = white_input + 1;
		up_white = 1;
	end

	if(right_tile == slash_up || right_tile == plus_hz || right_tile == backslash_down)
	begin
		white_input = white_input + 1;
		right_white = 1;
	end

	if(down_tile == slash_up || down_tile == plus_vrt || down_tile == backslash_up)
	begin
		white_input = white_input + 1;
		down_white = 1;
	end

	// chek the blask inputs
	if(left_tile == slash_up || left_tile == plus_vrt || left_tile == backslash_down)
	begin
		black_input = black_input + 1;
		left_white = 0;
	end

	if(up_tile == slash_down || up_tile == plus_vrt || up_tile == backslash_down)
	begin
		black_input = black_input + 1;
		up_white = 0;
	end

	if(right_tile == slash_down || right_tile == plus_vrt || right_tile == backslash_up)
	begin
		black_input = black_input + 1;
		right_white = 0;
	end

	if(down_tile == slash_down || down_tile == plus_hz || down_tile == backslash_down)
	begin
		black_input = black_input + 1;
		down_white = 0;
	end

	//check the mandatory moves for white tile
	if(white_input == 2)
	begin
		if(left_white == 1)	//check the left tile with others
		begin
			if(up_white == 1)
			begin
				tile_type[slash_up - 1] = 1;
				endsignal = 1;
			end

			else if(right_white == 1)
			begin
				tile_type[plus_hz - 1] = 1;
				endsignal = 1;
			end
			
			else if (down_white == 1)
			begin
				tile_type[backslash_down - 1] = 1;
				endsignal = 1;
			end
		end
	
		if(up_white == 1)	//check the up tile with others
		begin
			if(right_white == 1)
			begin
				tile_type[backslash_up - 1] = 1;
				endsignal = 1;
			end
			
			if(down_white == 1)
			begin
				tile_type[plus_vrt - 1] = 1;
				endsignal = 1;
			end
		end
		
		if(right_white == 1)	//check the right tile with down tile
		begin
			if(down_white == 1)
			begin
				tile_type[slash_down - 1] = 1;
				endsignal = 1;
			end
		end
	end	//end of checking mandatory moves for white


	//check the mandatory moves for black tile
	if(black_input == 2)
	begin
		if(left_white == 0)	//chek the left tile with others
		begin
			if(up_white == 1)
			begin
				tile_type[slash_up - 1] = 1;
				endsignal = 1;
			end

			else if(right_white == 0)
			begin
				tile_type[plus_hz - 1] = 1;
				endsignal = 1;
			end
			
			else if (down_white == 0)
			begin
				tile_type[backslash_down - 1] = 1;
				endsignal = 1;
			end
		end
	
		if(up_white == 0)	//check the up tile with others
		begin
			if(right_white == 0)
			begin
				tile_type[backslash_up - 1] = 1;
				endsignal = 1;
			end
			
			if(down_white == 0)
			begin
				tile_type[plus_vrt - 1] = 1;
				endsignal = 1;
			end
		end
		
		if(right_white == 0)	//check the right tile with down tile
		begin
			if(down_white == 0)
			begin
				tile_type[slash_down - 1] = 1;
				endsignal = 1;
			end
		end
	end	//end of checking mandatory moves for black

	//check if left tile is the only one set before(in the 4 tile up, down, left, right)
	if(left_tile != empty && up_tile == empty && right_tile == empty && down_tile == empty && endsignal != 1)
	begin
		if(white_input == 1)
		begin
			tile_type[slash_up - 1] = 1;
			tile_type[plus_hz - 1] = 1;
			tile_type[backslash_down - 1] = 1;
			endsignal = 1;
		end

		else if(black_input == 1)
		begin
			tile_type[slash_down - 1] = 1;
			tile_type[plus_vrt - 1] = 1;
			tile_type[backslash_up - 1] = 1;
			endsignal = 1;
		end
	end

	//check if up tile is the only one set before(in the 4 tile up, down, left, right)
	if(left_tile == empty && up_tile != empty && right_tile == empty && down_tile == empty && endsignal != 1)
	begin
		if(white_input == 1)
		begin
			tile_type[slash_up - 1] = 1;
			tile_type[plus_vrt - 1] = 1;
			tile_type[backslash_up - 1] = 1;
			endsignal = 1;
		end

		else if(black_input == 1)
		begin
			tile_type[slash_down - 1] = 1;
			tile_type[plus_hz - 1] = 1;
			tile_type[backslash_down - 1] = 1;
			endsignal = 1;
		end
	end

	//check if right tile is the only one set before(in the 4 tile up, down, left, right)
	if(left_tile == empty && up_tile == empty && right_tile != empty && down_tile == empty && endsignal != 1)
	begin
		if(white_input == 1)
		begin
			tile_type[slash_down - 1] = 1;
			tile_type[plus_hz - 1] = 1;
			tile_type[backslash_up - 1] = 1;
			endsignal = 1;
		end

		else if(black_input == 1)
		begin
			tile_type[slash_up - 1] = 1;
			tile_type[plus_vrt - 1] = 1;
			tile_type[backslash_down - 1] = 1;
			endsignal = 1;
		end
	end

	//check if down tile is the only one set before(in the 4 tile up, down, left, right)
	if(left_tile == empty && up_tile == empty && right_tile == empty && down_tile != empty && endsignal != 1)
	begin
		if(white_input == 1)
		begin
			tile_type[slash_down - 1] = 1;
			tile_type[plus_vrt - 1] = 1;
			tile_type[backslash_down - 1] = 1;
			endsignal = 1;
		end

		else if(black_input == 1)
		begin
			tile_type[slash_up - 1] = 1;
			tile_type[plus_hz - 1] = 1;
			tile_type[backslash_up - 1] = 1;
			endsignal = 1;
		end
	end

	//if the left and the up tile is set before
	if(left_tile != empty && up_tile != empty && right_tile == empty && down_tile == empty && endsignal != 1)
	begin
		if(left_white == 1)
		begin
			if(up_white == 0)
			begin
				tile_type[plus_hz - 1] = 1;
				tile_type[backslash_down - 1] = 1;
				endsignal = 1;
			end
		end
		else if (left_white == 0)
		begin
			if(up_white == 1)
			begin
				tile_type[plus_vrt - 1] = 1;
				tile_type[backslash_up - 1] = 1;
				endsignal = 1;
			end
		end
	end

	//if the left and the right tile is set before
	if(left_tile != empty && up_tile == empty && right_tile != empty && down_tile == empty && endsignal != 1)
	begin
		if(left_white == 1)
		begin
			if(right_white == 0)
			begin
				tile_type[slash_up - 1] = 1;
				tile_type[backslash_down - 1] = 1;
				endsignal = 1;
			end
		end
		else if (left_white == 0)
		begin
			if(right_white == 1)
			begin
				tile_type[slash_down - 1] = 1;
				tile_type[backslash_up - 1] = 1;
				endsignal = 1;
			end
		end
	end

	//if the left and the down tile is set before
	if(left_tile != empty && up_tile == empty && right_tile == empty && down_tile != empty && endsignal != 1)
	begin
		if(left_white == 1)
		begin
			if(down_white == 0)
			begin
				tile_type[slash_up - 1] = 1;
				tile_type[plus_hz - 1] = 1;
				endsignal = 1;
			end
		end
		else if (left_white == 0)
		begin
			if(down_white == 1)
			begin
				tile_type[slash_down - 1] = 1;
				tile_type[plus_vrt - 1] = 1;
				endsignal = 1;
			end
		end
	end

	//if the up and the right tile is set before
	if(left_tile == empty && up_tile != empty && right_tile != empty && down_tile == empty && endsignal != 1)
	begin
		if(up_white == 1)
		begin
			if(right_white == 0)
			begin
				tile_type[slash_up - 1] = 1;
				tile_type[plus_vrt - 1] = 1;
				endsignal = 1;
			end
		end
		else if (up_white == 0)
		begin
			if(right_white == 1)
			begin
				tile_type[slash_down - 1] = 1;
				tile_type[plus_hz - 1] = 1;
				endsignal = 1;
			end
		end
	end

	//if the up and the down tile is set before
	if(left_tile == empty && up_tile != empty && right_tile == empty && down_tile != empty && endsignal != 1)
	begin
		if(up_white == 1)
		begin
			if(down_white == 0)
			begin
				tile_type[slash_up - 1] = 1;
				tile_type[backslash_up - 1] = 1;
				endsignal = 1;
			end
		end
		else if (up_white == 0)
		begin
			if(down_white == 1)
			begin
				tile_type[slash_down - 1] = 1;
				tile_type[backslash_down - 1] = 1;
				endsignal = 1;
			end
		end
	end

	//if the right and the down tile is set before
	if(left_tile == empty && up_tile == empty && right_tile != empty && down_tile != empty && endsignal != 1)
	begin
		if(right_white == 1)
		begin
			if(down_white == 0)
			begin
				tile_type[plus_hz - 1] = 1;
				tile_type[backslash_up - 1] = 1;
				endsignal = 1;
			end
		end
		else if (right_white == 0)
		begin
			if(down_white == 1)
			begin
				tile_type[plus_vrt - 1] = 1;
				tile_type[backslash_down - 1] = 1;
				endsignal = 1;
			end
		end
	end
end
endmodule
