`timescale 1us/1ns

module UART_RX_TB;

  localparam scale_WIDTH = 6;
  localparam DATA_WIDTH = 8;
  localparam clk_period_TX = 8.86; // freq of TX 115200 period 8.86 us
  localparam clk_period_RX = 8.86/8;

  // signal definition
  reg clk_TB_TX, clk_TB_RX;
  reg reset_n_TB;
  reg RX_IN_TB;
  reg [scale_WIDTH - 1:0] prescaler_TB;
  reg PAR_EN_TB, PAR_TYP_TB;
  wire [DATA_WIDTH - 1:0] P_DATA_TB;
  wire Parity_Error_TB;
  wire Stop_Error_TB;
  wire data_valid_TB;
  
  //aditional signals for testing
  /*
  wire enable_TB,dat_samp_en_TB;
  wire [3:0] bit_cnt_TB;
  wire [scale_WIDTH-1:0] edge_cnt_TB;
  wire sampled_bit;
  wire deser_en;
  wire par_chk_en;
  wire stp_chk_en;
  */

  // initial block
  initial begin
    $dumpfile("UART_RX_TB.vcd");
    $dumpvars;

	 
    initialize();
    reset();
	
	
	 //case 1 no parity and prescale 8
	 
    confg(1'b0, 1'b0, 6'd8);
	 
    //**********start_bit ************
    Data_Entry(1'b0); #(clk_period_TX) 
												  //*********************************************************Data****************************************************************************
	                                   Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) 
												  Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) 
    //***stop_bit***
    Data_Entry(1'b1);
	 #(clk_period_TX)
	 
	 check_data(8'b10111010,2'b01); 
	 
	/******************************************************************************************************************************************************************************	
	******************************************************************************************************************************************************************************/ 
	
	 
	 
	 
	 //case 2 even parity and prescale 8
	 
    confg(1'b1, 1'b0, 6'd8);
	 
    //**********start_bit ************
    Data_Entry(1'b0); #(clk_period_TX) 
												  //*********************************************************Data****************************************************************************
	                                   Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) 
												  Data_Entry(1'b0); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) 
	 //***parity_bit**
    Data_Entry(1'b0);
	 #(clk_period_TX)
    //***stop_bit***
    Data_Entry(1'b1);
	 #(clk_period_TX)
	 
	 check_data(8'b11100100,2'b10); 
	 
	/******************************************************************************************************************************************************************************	
	******************************************************************************************************************************************************************************/ 
	
	 
	 
	 
	 //case 3 odd parity and prescale 8

    confg(1'b1, 1'b1, 6'd8);
	 
    //**********start_bit ************
    Data_Entry(1'b0); #(clk_period_TX) 
												  //*********************************************************Data****************************************************************************
	                                   Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) 
												  Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) Data_Entry(1'b1); #(clk_period_TX) Data_Entry(1'b0); #(clk_period_TX) 
	 //***parity_bit**
    Data_Entry(1'b0);
	 #(clk_period_TX)
    //***stop_bit***
    Data_Entry(1'b1);
	 
	
	 check_data(8'b10111010,2'b11); 

    #(2*clk_period_TX)
	 
    $stop;
  end

  // instantiation
  UART_RX DUT(
    .clk(clk_TB_RX),
    .reset_n(reset_n_TB),
    .RX_IN(RX_IN_TB),
    .prescaler(prescaler_TB),
    .PAR_EN(PAR_EN_TB),
    .PAR_TYP(PAR_TYP_TB),
    .P_DATA(P_DATA_TB),
	 .Parity_Error(Parity_Error_TB),
	 .Stop_Error(Stop_Error_TB),
	 .data_valid(data_valid_TB)
	 
	 //additional signals for testing
	 /*
	 .enable_TB(enable_TB),
	 .dat_samp_en_TB(dat_samp_en_TB),
    .bit_cnt_TB(bit_cnt_TB),
    .edge_cnt_TB(edge_cnt_TB),
	 .sampled_bit(sampled_bit),
	 .deser_en(deser_en),
	 .par_chk_en(par_chk_en),
	 .stp_chk_en(stp_chk_en)
	 */
  );

  // clock generator for RX
  always #(clk_period_RX / 2) clk_TB_RX = ~clk_TB_RX;

  // clock generator for TX
  always #(clk_period_TX / 2) clk_TB_TX = ~clk_TB_TX;

  // Initialization
  task initialize;
  begin
    clk_TB_TX = 1'b0;
    clk_TB_RX = 1'b0;
    reset_n_TB = 1'b1;
    RX_IN_TB = 1'b1;
  end
  endtask

  // reset
  task reset;
  begin
    #(clk_period_TX)
    reset_n_TB = 1'b0;
    #(clk_period_TX)
    reset_n_TB = 1'b1;
	 #(clk_period_TX/2);
  end
  endtask

  // configuration
  task confg;
  input PAR_EN_T, PAR_TYP_T;
  input [scale_WIDTH - 1:0] prescaler_T;
  begin
    PAR_EN_TB = PAR_EN_T;
    PAR_TYP_TB = PAR_TYP_T;
    prescaler_TB = prescaler_T;
  end
  endtask
  

  // input the data
  task Data_Entry;
  input Data_in; // one input for this task
  begin
    RX_IN_TB = Data_in;
  end
  endtask
  
  
  // check
  
  task check_data;
  input [7:0] data_detected;
  input [1:0]i;
  begin
	if (data_detected == P_DATA_TB)
	begin
		 $display("#################################################################################################################################\n");
		 $display("###########################################CASE  %d CHECK IS PASSED###############################################################\n",i);
		 $display("#############Data are correctly sent and detected ----> P_DATA = %b  -----> Time = %t us#################\n",P_DATA_TB,$time);
		 $display("#################################################################################################################################\n");
		 $display("#\n#\n#\n");
	end
	else
	begin
		 $display("##################################################################################################################################\n");
		 $display("##########################################CASE %d CHECK IS NOT PASSED##############################################################\n",i);
		 $display("#############Data are correctly sent and detected ----> P_DATA = %b  -----> Time = %t us#################\n",P_DATA_TB,$time);
		 $display("##################################################################################################################################\n");
		 $display("#\n#\n#\n");
	end
  end
  endtask
	
  
endmodule
