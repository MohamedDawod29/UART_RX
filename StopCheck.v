module StopCheck
(
	input wire clk,reset_n,
	input wire sampled_bit,stp_chk_en,
	output reg stp_err
);

	
	always @(posedge clk, negedge reset_n)
	begin
		if(!reset_n)
			stp_err <= 1'b0;
		else if (stp_chk_en)
			stp_err <= (sampled_bit == 1'b1)? 1'b0 : 1'b1;
	end
	
	
endmodule 