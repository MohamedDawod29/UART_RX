module deserializer #(parameter DATA_WIDTH = 8)
(
	input wire clk,reset_n,
	input wire deser_en,sampled_bit,
	output [DATA_WIDTH-1:0] P_DATA
);

	reg [DATA_WIDTH-1:0] DATA;
	
	always @(posedge clk, negedge reset_n)
	begin
		if (!reset_n)
			DATA <= 0;
			
		else if (deser_en)
		begin
			DATA <= DATA << 1;
			DATA[0] <= sampled_bit;
		end
	end
	
	assign P_DATA = DATA;
	
endmodule

	