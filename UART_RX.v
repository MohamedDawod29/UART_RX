module UART_RX #(parameter DATA_WIDTH = 8, scale_WIDTH = 6)
(
	input wire clk,reset_n,
	input wire RX_IN,
	input wire [scale_WIDTH-1:0] prescaler,
	input wire PAR_EN,PAR_TYP,
	output data_valid,
	output [DATA_WIDTH-1:0] P_DATA,
	output Stop_Error,
	output Parity_Error
	
	//additional signals for test the working process
	/*
	output enable_TB,dat_samp_en_TB,
   output [3:0] bit_cnt_TB,
   output [scale_WIDTH-1:0] edge_cnt_TB,
	output sampled_bit,
	output deser_en,
	output par_chk_en,
	output stp_chk_en
	*/
);

	wire enable_;
	wire [3:0] bit_cnt_;
	wire [scale_WIDTH-1:0] edge_cnt_;
	wire par_err_,stp_err_,strt_glitch_,deser_en_,dat_samp_en_,stp_chk_en_,strt_chk_en_,par_chk_en_,sampled_bit_;
	
	
	
	
	
	UART_RX_FSM #(.scale_WIDTH(scale_WIDTH)) B0
	(
	.clk(clk),
	.reset_n(reset_n),
	.RX_IN(RX_IN),
	.PAR_EN(PAR_EN),
	.par_err(par_err_),
	.strt_glitch(strt_glitch_),
	.stp_err(stp_err_),
	.edge_cnt(edge_cnt_),
	.prescaler(prescaler),
	.bit_cnt(bit_cnt_),
	.data_valid(data_valid),
	.enable(enable_),
	.deser_en(deser_en_),
	.dat_samp_en(dat_samp_en_),
	.par_chk_en(par_chk_en_),
	.strt_chk_en(strt_chk_en_),
	.stp_chk_en(stp_chk_en_)
	);
	
	
	edge_bit_counter #(.scale_WIDTH(scale_WIDTH)) B1
	(
	.clk(clk),
	.reset_n(reset_n),
	.enable(enable_),
	.prescaler(prescaler),
	.PAR_EN(PAR_EN),
	.bit_cnt(bit_cnt_),
	.edge_cnt(edge_cnt_)
	);
	
	
	data_sampling #(.scale_WIDTH(scale_WIDTH)) B2
	(
	.clk(clk),
	.reset_n(reset_n),
	.RX_IN(RX_IN),
	.edge_cnt(edge_cnt_),
	.prescaler(prescaler),
	.dat_samp_en(dat_samp_en_),
	.sampled_bit(sampled_bit_)
	);
	
	
	deserializer #(.DATA_WIDTH(DATA_WIDTH)) B3
	(
	.clk(clk),
	.reset_n(reset_n),
	.deser_en(deser_en_),
	.sampled_bit(sampled_bit_),
	.P_DATA(P_DATA)
	);
	
	
	StartCheck B4
	(
	.clk(clk),
	.reset_n(reset_n),
	.sampled_bit(sampled_bit_),
	.strt_chk_en(strt_chk_en_),
	.strt_glitch(strt_glitch_)
	);
	
	
	ParityCheck B5
	(
	.clk(clk),
	.reset_n(reset_n),
	.PAR_TYP(PAR_TYP),
	.par_chk_en(par_chk_en_),
	.sampled_bit(sampled_bit_),
	.P_DATA(P_DATA),
	.par_err(par_err_)
	);
	
	
	StopCheck B6
	(
	.clk(clk),
	.reset_n(reset_n),
	.sampled_bit(sampled_bit_),
	.stp_chk_en(stp_chk_en_),
	.stp_err(stp_err_)
	);
	
	
	assign Stop_Error = stp_err_;
	assign Parity_Error = par_err_;
	
	//additional signals for testing
	/*
	assign enable_TB = enable_;
	assign dat_samp_en_TB = dat_samp_en_;
	assign bit_cnt_TB = bit_cnt_;
	assign edge_cnt_TB = edge_cnt_;
	assign sampled_bit = sampled_bit_;
	assign deser_en = deser_en_;
	assign par_chk_en = par_chk_en_;
	assign stp_chk_en = stp_chk_en_;
	*/
	
	
endmodule
