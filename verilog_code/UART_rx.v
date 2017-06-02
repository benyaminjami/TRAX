module uart_rx 
	#(parameter CLKS_PER_BIT)
	(
	input	clock,
	input	rx,
	input	reset,
	output [7:0]	rx_data,
	output	rx_finish
	);
    
parameter s_IDLE         = 3'b000;
parameter s_RX_START_BIT = 3'b001;
parameter s_RX_DATA_BITS = 3'b010;
parameter s_RX_STOP_BIT  = 3'b011;
parameter s_CLEANUP      = 3'b100;
   
reg	r_Rx_Data_R = 1'b1;
reg     r_Rx_Data   = 1'b1;
reg	r_rx_finish = 1'b0;
reg [11:0]	r_Clock_Count = 0;
reg [2:0]	r_Bit_Index   = 0; 
reg [7:0]       r_Rx_Byte     = 0;
reg [2:0]	r_SM_Main     = 0;
  
always @(posedge clock)
begin
	r_Rx_Data_R <= rx;
	r_Rx_Data <= r_Rx_Data_R;
end
 
always @(posedge clock)
begin
	if(reset == 1'b1)
		r_SM_Main <= s_IDLE;   
        case (r_SM_Main)
		s_IDLE :
          	begin
          		r_Clock_Count <= 0;
		        r_Bit_Index <= 0;
			r_rx_finish <= 0;
            		if (r_Rx_Data == 1'b0)         
           			r_SM_Main <= s_RX_START_BIT;
            		else
            	  		r_SM_Main <= s_IDLE;
          	end
         
        	s_RX_START_BIT :
        	begin
            		if (r_Clock_Count == (CLKS_PER_BIT-1)/2)
            		begin
                		if (r_Rx_Data == 1'b0)
                		begin
                    			r_Clock_Count <= 0;  
                    			r_SM_Main <= s_RX_DATA_BITS;
                  		end
               			else
                  			r_SM_Main <= s_IDLE;
              		end
           		else
              		begin
              			r_Clock_Count <= r_Clock_Count + 1;
                		r_SM_Main <= s_RX_START_BIT;
              		end
          	end 
         
         
        	s_RX_DATA_BITS :
          	begin
          		if (r_Clock_Count < CLKS_PER_BIT-1)
              		begin
               		r_Clock_Count <= r_Clock_Count + 1;
                	r_SM_Main     <= s_RX_DATA_BITS;
              		end
            		else
            		begin
                		r_Clock_Count <= 0;
                		r_Rx_Byte[r_Bit_Index] <= r_Rx_Data;
                 
                		if (r_Bit_Index < 7)
                		begin
                    			r_Bit_Index <= r_Bit_Index + 1;
                    			r_SM_Main <= s_RX_DATA_BITS;
                  		end
                		else
                		begin
                    			r_Bit_Index <= 0;
                    			r_SM_Main <= s_RX_STOP_BIT;
                  		end
              		end
          	end
     
     
       		
        	s_RX_STOP_BIT :
          	begin
          		/
            		if (r_Clock_Count < CLKS_PER_BIT-1)
              		begin
               			r_Clock_Count <= r_Clock_Count + 1;
                		r_SM_Main <= s_RX_STOP_BIT;
              		end
            		else
              		begin
              			r_Clock_Count <= 0;
				r_rx_finish <= 1'b1;
                		r_SM_Main <= s_IDLE;
              		end
          	end
     	
	endcase
end   
assign rx_finish = r_rx_finish;
assign rx_data = r_Rx_Byte;
   
endmodule
