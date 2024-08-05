module ParityCheck #(parameter DATA_WIDTH = 8)
(
	input wire clk,reset_n,
	input wire PAR_TYP,
	input wire par_chk_en,sampled_bit,
	input wire [DATA_WIDTH-1:0] P_DATA,
	output reg par_err
);

	wire par_calc;
	
	assign par_calc = (PAR_TYP == 1'b1) ? (~^P_DATA) : (^P_DATA);
	
	
	always @(posedge clk, negedge reset_n)
	begin
		if(!reset_n)
			par_err <= 1'b0;
		else if (par_chk_en)
			par_err <= (sampled_bit == par_calc)? 1'b0 : 1'b1;
	end
	
	
endmodule 