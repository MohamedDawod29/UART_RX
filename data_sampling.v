module data_sampling #(parameter scale_WIDTH = 6)
(
	input wire clk,reset_n,
	input wire RX_IN,
	input wire [scale_WIDTH-1:0] edge_cnt,prescaler,
	input wire dat_samp_en,
	output reg sampled_bit
);

	reg [2:0] samples;

	always @(posedge clk, negedge reset_n)
	begin
		if(!reset_n)
			samples <= 0;
			
		else if (dat_samp_en)
		begin
		
		// sampling according to the prescaler value 
		
			case (prescaler)
			6'b001000:                      //prescale by 8
			begin
				if (edge_cnt == 3)
					samples[0] <= RX_IN;
				else if (edge_cnt == 4) 
					samples[1] <= RX_IN;
				else if (edge_cnt == 5)
				   samples[2] <= RX_IN;
				else
					samples <= samples;				
			end
			6'b010000:                       //pescale by 16
			begin
				if (edge_cnt == 7)
					samples[0] <= RX_IN;
				else if (edge_cnt == 8) 
					samples[1] <= RX_IN;
				else if (edge_cnt == 9)
				   samples[2] <= RX_IN;
				else
					samples <= samples;	
			end
			6'b100000:                       //prescale by 32
			begin
				if (edge_cnt == 15)
					samples[0] <= RX_IN;
				else if (edge_cnt == 16) 
					samples[1] <= RX_IN;
				else if (edge_cnt == 17)
				   samples[2] <= RX_IN;
				else
					samples <= samples;	
			end
         default: samples <= samples;
			endcase
		end
		
		else
			samples <= samples;	
	end
	
	always @(posedge clk, negedge reset_n)
	begin
		// deduce the value of sampled bit 
		if (!reset_n)
			sampled_bit <= sampled_bit;
		else if (dat_samp_en)
		begin
			case (samples)
				3'b000: sampled_bit <= 1'b0;
				3'b001: sampled_bit <= 1'b0;
				3'b010: sampled_bit <= 1'b0;
				3'b011: sampled_bit <= 1'b1;
				3'b100: sampled_bit <= 1'b0;
				3'b101: sampled_bit <= 1'b1;
				3'b110: sampled_bit <= 1'b1;
				3'b111: sampled_bit <= 1'b1;
			endcase
		end
		else
			sampled_bit <= sampled_bit;
	end
	
	
endmodule


