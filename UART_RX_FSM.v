module UART_RX_FSM #(parameter scale_WIDTH = 6 )
(
	input wire clk,reset_n,
	input wire RX_IN,PAR_EN,par_err,strt_glitch,stp_err,
	input wire [scale_WIDTH-1:0] edge_cnt,prescaler,
	input wire [3:0] bit_cnt,
	output reg data_valid,
	output reg enable,deser_en,dat_samp_en,
	output reg par_chk_en,strt_chk_en,stp_chk_en
);


	reg [2:0] next_state,current_state;
	 
	localparam [2:0] idle = 3'b000, start = 3'b001, data = 3'b011, parity = 3'b010, stop = 3'b110;
	
	//states transition
	always @(posedge clk, negedge reset_n)
	begin
		if(!reset_n)
			current_state <= idle;
		else
			current_state <= next_state;
	end
	
	
	//next state logic
	always @(*)
	begin
		case (current_state)
		idle:
		begin
			if (RX_IN == 1'b0)
				next_state = start;
			else  
				next_state = idle;
		end
		
		start:
		begin
		   if (strt_glitch)
				next_state = idle;
			else if (bit_cnt >= 'd2 & bit_cnt <= 'd9)
				next_state = data;
			else
				next_state = start;
		end
	
		
		data:
		begin
			if (bit_cnt >= 'd2 & bit_cnt <= 'd9)
				next_state = data;
			else
				next_state = (PAR_EN) ? parity : stop;
		end
		
		parity:
		begin
			if (bit_cnt == 'd10) 
				next_state = parity;
			else if (par_err)
				next_state = idle;
			else 
				next_state = stop;
		end
		
		
		stop:
		begin
			if (PAR_EN)
			begin
				if (bit_cnt =='d11)
					next_state = stop;
				else 
				begin
					if (stp_err)
						next_state = idle;
					else
					begin
					 if (RX_IN)
						next_state = idle;
					 else
						next_state = start;
					end
				end
			end
			else
			begin
				if (bit_cnt =='d10)
					next_state = stop;
				else 
				begin
					if (stp_err)
						next_state = idle;
					else
					begin
					 if (RX_IN)
						next_state = idle;
					 else
						next_state = start;
					end
				end
			end
		end
		
		
		default:
		begin
			next_state = idle;
		end
	   endcase
	end	
		
		
	//output logic
	always @(*)
	begin
		case (current_state)
		idle:
		begin
			if (RX_IN == 0)
				enable = 1'b1;
			else
				enable = 1'b0;		
		end
		
		start:
		begin
			data_valid = 1'b0;
		   enable = 1'b1;
			deser_en = 1'b0;
			dat_samp_en = 1'b0;
		   par_chk_en = 1'b0;
			strt_chk_en = 1'b0;
			stp_chk_en = 1'b0;
			case (prescaler)
			6'b001000:                      //prescale by 8
			begin
				if (edge_cnt == 3 | edge_cnt == 4 | edge_cnt == 5)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 6)
					strt_chk_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					strt_chk_en = 1'b0;
				end
			end
			6'b010000:                       //prescale by 16
			begin
				if (edge_cnt == 7 | edge_cnt == 8 | edge_cnt == 9)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 10)
					strt_chk_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					strt_chk_en = 1'b0;
				end
			end
			6'b100000:                       //prescale by 32
			begin
				if (edge_cnt == 15 | edge_cnt == 16 | edge_cnt == 17)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 18)
					strt_chk_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					strt_chk_en = 1'b0;
				end
			end
			default: strt_chk_en = 1'b0;
			endcase
		end
		
		data:
		begin
			data_valid = 1'b0;
		   enable = 1'b1;
			deser_en = 1'b0;
			dat_samp_en = 1'b0;
		   par_chk_en = 1'b0;
			strt_chk_en = 1'b0;
			stp_chk_en = 1'b0;
			case (prescaler)
			6'b001000:                      //prescale by 8
			begin
				if (edge_cnt == 3 | edge_cnt == 4 | edge_cnt == 5)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 6)
					deser_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					deser_en = 1'b0;
				end
			end
			6'b010000:                       //prescale by 16
			begin
				if (edge_cnt == 7 | edge_cnt == 8 | edge_cnt == 9)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 10)
					deser_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					deser_en = 1'b0;
				end
			end
			6'b100000:                       //prescale by 32
			begin
				if (edge_cnt == 15 | edge_cnt == 16 | edge_cnt == 17)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 18)
					deser_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					deser_en = 1'b0;
				end
			end
			default: deser_en = 1'b0;
			endcase
		end
		
		parity:
		begin
			data_valid = 1'b0;
		   enable = 1'b1;
			deser_en = 1'b0;
			dat_samp_en = 1'b0;
		   par_chk_en = 1'b0;
			strt_chk_en = 1'b0;
			stp_chk_en = 1'b0;
			case (prescaler)
			6'b001000:                      //prescale by 8
			begin
				if (edge_cnt == 3 | edge_cnt == 4 | edge_cnt == 5)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 6)
					par_chk_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					par_chk_en = 1'b0;
				end
			end
			6'b010000:                       //prescale by 16
			begin
				if (edge_cnt == 7 | edge_cnt == 8 | edge_cnt == 9)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 10)
					par_chk_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					par_chk_en = 1'b0;
				end
			end
			6'b100000:                       //prescale by 32
			begin
				if (edge_cnt == 15 | edge_cnt == 16 | edge_cnt == 17)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 18)
					par_chk_en = 1'b1;
				else
				begin
					dat_samp_en = 1'b0;
					par_chk_en = 1'b0;
				end
			end
			default: par_chk_en = 1'b0;
			endcase
		end
		
		stop:
		begin
			data_valid = 1'b0;
		   enable = 1'b1;
			deser_en = 1'b0;
			dat_samp_en = 1'b0;
		   par_chk_en = 1'b0;
			strt_chk_en = 1'b0;
			stp_chk_en = 1'b0;
			case (prescaler)
			6'b001000:                      //prescale by 8
			begin
				if (edge_cnt == 3 | edge_cnt == 4 | edge_cnt == 5)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 6)
				begin
				   dat_samp_en = 1'b0;
					data_valid = 1'b0;
					stp_chk_en = 1'b1;
				end
				else if (edge_cnt == 7)
				begin
					dat_samp_en = 1'b0;
					stp_chk_en = 1'b0;
					data_valid = ((par_err == 0) & (strt_glitch == 0) & (stp_err == 0)) ? 1'b1 : 1'b0;
				end
				else
				begin
					dat_samp_en = 1'b0;
					stp_chk_en = 1'b0;
					data_valid = 1'b0;
				end
			end
			6'b010000:                       //prescale by 16
			begin
				if (edge_cnt == 7 | edge_cnt == 8 | edge_cnt == 9)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 10)
				begin
				   dat_samp_en = 1'b0;
					data_valid = 1'b0;
					stp_chk_en = 1'b1;
				end
				else if (edge_cnt == 11)
				begin
					dat_samp_en = 1'b0;
					stp_chk_en = 1'b0;
					data_valid = ((par_err == 0) & (strt_glitch == 0) & (stp_err == 0)) ? 1'b1 : 1'b0;
				end
				else
				begin
					dat_samp_en = 1'b0;
					stp_chk_en = 1'b0;
					data_valid = 1'b0;
				end
			end
			6'b100000:                       //prescale by 32
			begin
				if (edge_cnt == 15 | edge_cnt == 16 | edge_cnt == 17)
					dat_samp_en = 1'b1;
				else if (edge_cnt == 18)
				begin
				   dat_samp_en = 1'b0;
					data_valid = 1'b0;
					stp_chk_en = 1'b1;
				end
				else if (edge_cnt == 19)
				begin
					dat_samp_en = 1'b0;
					stp_chk_en = 1'b0;
					data_valid = ((par_err == 0) & (strt_glitch == 0) & (stp_err == 0)) ? 1'b1 : 1'b0;
				end
				else
				begin
					dat_samp_en = 1'b0;
					stp_chk_en = 1'b0;
					data_valid = 1'b0;
				end
			end
			default: stp_chk_en = 1'b0;
			endcase
		end
		default:
		begin
			data_valid = 1'b0;
		   enable = 1'b0;
			deser_en = 1'b0;
			dat_samp_en = 1'b0;
		   par_chk_en = 1'b0;
			strt_chk_en = 1'b0;
			stp_chk_en = 1'b0;
		end
	   endcase
	end	
		
endmodule

	



	