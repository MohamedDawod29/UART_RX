module edge_bit_counter #(parameter scale_WIDTH = 6)
(
	input wire clk,reset_n,
	input wire enable,
	input wire [scale_WIDTH-1:0] prescaler,
	input wire PAR_EN,
	output reg [3:0] bit_cnt,
	output reg [scale_WIDTH-1:0] edge_cnt
);


	
	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
		begin
			edge_cnt <= 1;
			bit_cnt <= 1;
		end
		
		else if (enable)
		begin
			
			case (prescaler)                                    
			
			6'b001000:                      //prescale by 8
			begin
				if (edge_cnt == 8)
				begin
					if (PAR_EN)
					begin
						if (bit_cnt == 11)
							bit_cnt <= 1;
						else
							bit_cnt <= bit_cnt + 1;
					end
					else
					begin
						if (bit_cnt == 10)
							bit_cnt <= 1;
						else
							bit_cnt <= bit_cnt + 1;
					end
					edge_cnt <= 1;
				end
				
				else
				begin
					edge_cnt <= edge_cnt + 1;
					bit_cnt <= bit_cnt;
				end
			end
			
			6'b010000:                       //pescale by 16
			begin
				if (edge_cnt == 16)
				begin
					if (PAR_EN)
					begin
						if (bit_cnt == 11)
							bit_cnt <= 1;
						else
							bit_cnt <= bit_cnt + 1;
					end
					else
					begin
						if (bit_cnt == 10)
							bit_cnt <= 1;
						else
							bit_cnt <= bit_cnt + 1;
					end
					edge_cnt <= 1;
				end
				
				else
				begin
					edge_cnt <= edge_cnt + 1;
					bit_cnt <= bit_cnt;
				end
			end
			
			
			6'b100000:                       //prescale by 32
			begin
				if (edge_cnt == 32)
				begin
					if (PAR_EN)
					begin
						if (bit_cnt == 11)
							bit_cnt <= 1;
						else
							bit_cnt <= bit_cnt + 1;
					end
					else
					begin
						if (bit_cnt == 10)
							bit_cnt <= 1;
						else
							bit_cnt <= bit_cnt + 1;
					end
					edge_cnt <= 1;
				end
				
				else
				begin
					edge_cnt <= edge_cnt + 1;
					bit_cnt <= bit_cnt;
				end
			end
			
         default: 
			begin
			edge_cnt <= 1;
			bit_cnt <= 1;
			end
			
			endcase
			
		end
		
		else
		begin
			edge_cnt <= 1;
			bit_cnt <= 1;
		end
	end
	
	
	
	
endmodule

