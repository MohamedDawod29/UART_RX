module StartCheck
(
	input wire clk,reset_n,
	input wire sampled_bit,strt_chk_en,
	output reg strt_glitch
);

	
	always @(posedge clk, negedge reset_n)
	begin
		if(!reset_n)
			strt_glitch <= 1'b0;
		else if (strt_chk_en)
			strt_glitch <= (sampled_bit == 1'b0)? 1'b0 : 1'b1;
	end
	
	
endmodule 