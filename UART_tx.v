module uart_tx 
	#(parameter CLKS_PER_BIT)
	(
	input       clock,
	input       send,
	input [7:0] tx_data,
	input       reset, 
	output reg  tx,
	output      tx_done
	);
 
parameter s_IDLE	 = 3'b000;
parameter s_TX_START_BIT = 3'b001;
parameter s_TX_DATA_BITS = 3'b010;
parameter s_TX_STOP_BIT  = 3'b011;
parameter s_CLEANUP      = 3'b100;
  
reg [2:0]	r_SM_Main = 0;
reg [11:0]	r_Clock_Count = 0;
reg [2:0]	r_Bit_Index = 0;
reg [7:0]	r_Tx_Data = 0;
reg 		r_Tx_Done = 0;
     
always @(posedge clock)
begin
	if(reset == 1'b1)
		r_SM_Main <= s_IDLE;

        case (r_SM_Main)
        	s_IDLE :
          	begin
			tx   <= 1'b1;         
			r_Tx_Done     <= 1'b0;
			r_Clock_Count <= 0;
			r_Bit_Index   <= 0;
             
			if (send == 1'b1)
			begin
				r_Tx_Data   <= tx_data;
				r_SM_Main   <= s_TX_START_BIT;
			end
            		else
            			r_SM_Main <= s_IDLE;
		end 
         
         
        	
		s_TX_START_BIT :
		begin
           		tx <= 1'b0;
             
            		
            		if (r_Clock_Count < CLKS_PER_BIT-1)
            		begin
		                r_Clock_Count <= r_Clock_Count + 1;
		                r_SM_Main <= s_TX_START_BIT;
		        end
            		else
             		begin
              			r_Clock_Count <= 0;
		                r_SM_Main <= s_TX_DATA_BITS;
 		        end
		end 
         
         
		        
		s_TX_DATA_BITS :
		begin
			tx <= r_Tx_Data[r_Bit_Index];
             
			if (r_Clock_Count < CLKS_PER_BIT-1)
			begin
				r_Clock_Count <= r_Clock_Count + 1;
				r_SM_Main <= s_TX_DATA_BITS;
			end
			else
			begin
				r_Clock_Count <= 0;
                 
			
				if (r_Bit_Index < 7)
				begin
					r_Bit_Index <= r_Bit_Index + 1;
                    			r_SM_Main <= s_TX_DATA_BITS;
                  		end
                		else
                		begin
			                r_Bit_Index <= 0;
			                r_SM_Main   <= s_TX_STOP_BIT;
                  		end
              		end
	          end 	
         
         
	        
	        s_TX_STOP_BIT :
	        begin
            		tx <= 1'b1;
             
            		
            		if (r_Clock_Count < CLKS_PER_BIT-1)
           		begin
              			r_Clock_Count <= r_Clock_Count + 1;
                		r_SM_Main     <= s_TX_STOP_BIT;
              		end
            		else
              		begin
                		r_Tx_Done <= 1'b1;
                		r_Clock_Count <= 0;
                		r_SM_Main <= s_IDLE;
              		end
          	end 
      		endcase
end
 
assign tx_done = r_Tx_Done;
   
endmodule
