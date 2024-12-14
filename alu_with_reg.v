module alu_with_reg (


	//////////// ADC //////////
	//output		          		ADC_CONVST,
	//output		          		ADC_DIN,
	//input 		          		ADC_DOUT,
	//output		          		ADC_SCLK,

	//////////// Audio //////////
	//input 		          		AUD_ADCDAT,
	//inout 		          		AUD_ADCLRCK,
	//inout 		          		AUD_BCLK,
	//output		          		AUD_DACDAT,
	//inout 		          		AUD_DACLRCK,
	//output		          		AUD_XCK,

	//////////// CLOCK //////////
	//input 		          		CLOCK2_50,
	//input 		          		CLOCK3_50,
	//input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SDRAM //////////
	//output		    [12:0]		DRAM_ADDR,
	//output		     [1:0]		DRAM_BA,
	//output		          		DRAM_CAS_N,
	//output		          		DRAM_CKE,
	//output		          		DRAM_CLK,
	//output		          		DRAM_CS_N,
	//inout 		    [15:0]		DRAM_DQ,
	//output		          		DRAM_LDQM,
	//output		          		DRAM_RAS_N,
	//output		          		DRAM_UDQM,
	//output		          		DRAM_WE_N,

	//////////// I2C for Audio and Video-In //////////
	//output		          		FPGA_I2C_SCLK,
	//inout 		          		FPGA_I2C_SDAT,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// IR //////////
	//input 		          		IRDA_RXD,
	//output		          		IRDA_TXD,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// PS2 //////////
	//inout 		          		PS2_CLK,
	//inout 		          		PS2_CLK2,
	//inout 		          		PS2_DAT,
	//inout 		          		PS2_DAT2,

	//////////// SW //////////
	input 		     [9:0]		SW

	//////////// Video-In //////////
	//input 		          		TD_CLK27,
	//input 		     [7:0]		TD_DATA,
	//input 		          		TD_HS,
	//output		          		TD_RESET_N,
	//input 		          		TD_VS,

	//////////// VGA //////////
	//output		          		VGA_BLANK_N,
	//output		     [7:0]		VGA_B,
	//output		          		VGA_CLK,
	//output		     [7:0]		VGA_G,
	//output		          		VGA_HS,
	//output		     [7:0]		VGA_R,
	//output		          		VGA_SYNC_N,
	//output		          		VGA_VS,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_0,

	//////////// GPIO_1, GPIO_1 connect to GPIO Default //////////
	//inout 		    [35:0]		GPIO_1
);

wire clk;
assign clk = CLOCK_50;

wire rst;
assign rst = KEY[3];

wire input_start;
assign input_start = ~KEY[2];

wire input_draw;
assign input_draw = ~KEY[1];

wire input_fold;
assign input_fold = ~KEY[0];

reg [7:0]S, NS;

parameter
    START = 4'd0,
    STOP_LFSR = 4'd1,
    CREATE_DECK = 4'd2,
    DELAY = 4'd3,
    SERVE_TWO = 4'd4,
    PLAYER_TURN = 4'd5,
    PLAYER_DRAW = 4'd6,
    DELAY_HUMAN_SPEED = 4'd7,
    PLAYER_BUST = 4'd8,
    DEALER_TURN = 4'd9,
    DEALER_DRAW = 4'd10,
    DEALER_BUST = 4'd11,
    LOSS = 4'd12;

	 
reg [4:0] deck [11:0];  // 12 items, each 4 bits wide
reg [4:0] shuff_deck [11:0];  // 12 items, each 4 bits wide
reg deck_aces [11:0];  // 12 items, each 4 bits wide

reg [4:0] player_hand [5:0];  // 12 items, each 4 bits wide
reg [3:0] player_aces, new_player_aces;
reg [9:0] player_points;
reg [4:0] dealer_hand [5:0];  // 12 items, each 4 bits wide
reg [3:0] dealer_aces, new_dealer_aces;
reg [9:0] dealer_points;

reg gen_seed;
reg gen_card;
reg stop_lfsr;
wire rand_out;
wire ace_pres;   
reg start_delay;
reg create_deck_done;
reg delay_done;
reg serve_two_done;
reg player_draw_done, player_busted, delay_2_done, dealer_turn_done, dealer_draws, dealer_draw_done, dealer_busted;

reg [3:0]new_plater_aces;

reg [9:0]leds_out;
assign LEDR = S; // CHANGE BACK LATERRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR

wire [3:0] seed;
assign seed = 4'b0101;

reg [1:0] timer, new_timer;
reg [32:0] timer_2, new_timer_2;

reg [5:0] curr_card_deck, new_curr_card_deck;
reg [5:0] curr_card_player, new_curr_card_player;
reg [5:0] curr_card_dealer, new_curr_card_dealer;


// Instantiate the lfsr_cards module
lfsr_cards d0 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b001),
    .out(deck[0])         // Connect LFSR output to the top-level module
);
lfsr_cards d1 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b0010),       
    .out(deck[1])         // Connect LFSR output to the top-level module
);
lfsr_cards d2 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b0011), 
    .out(deck[2])         // Connect LFSR output to the top-level module
);
lfsr_cards d3 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b0100),  
    .out(deck[3])         // Connect LFSR output to the top-level module
);
lfsr_cards d4 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b0101),
    .out(deck[4])         // Connect LFSR output to the top-level module
);
lfsr_cards d5 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b0111),  
    .out(deck[5])         // Connect LFSR output to the top-level module
);
lfsr_cards d6 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b1000),   
    .out(deck[6])         // Connect LFSR output to the top-level module
);
lfsr_cards d7 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b1001),   
    .out(deck[7])         // Connect LFSR output to the top-level module
);
lfsr_cards d8 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b1010),  
    .out(deck[8])         // Connect LFSR output to the top-level module
);
lfsr_cards d9 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b1011),  
    .out(deck[9])         // Connect LFSR output to the top-level module
);
lfsr_cards d10 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b1100), 
    .out(deck[10])         // Connect LFSR output to the top-level module
);
lfsr_cards d11 (.clk(clk), .reset(rst), .enable(gen_card), .seed(4'b1101),  
    .out(deck[11])         // Connect LFSR output to the top-level module
);


seven_segment u_temp_seven_segment (
  .i0(disp_0),       // Connect input i0 to the first input of temp_seven_segment
  .o0(sev_0),       // Connect output o0 to the first 7-segment display
  .i1(disp_1),       // Connect input i1 to the second input of temp_seven_segment
  .o1(sev_1),       // Connect output o1 to the second 7-segment display
  .i2(disp_2),       // Connect input i2 to the third input of temp_seven_segment
  .o2(sev_2),       // Connect output o2 to the third 7-segment display
  .i3(disp_3),       // Connect input i3 to the fourth input of temp_seven_segment
  .o3(sev_3),       // Connect output o3 to the fourth 7-segment display
  .i4(disp_4),       // Connect input i4 to the fifth input of temp_seven_segment
  .o4(sev_4),       // Connect output o4 to the fifth 7-segment display
  .i5(disp_5),       // Connect input i5 to the sixth input of temp_seven_segment
  .o5(sev_5)        // Connect output o5 to the sixth 7-segment display
);

reg [3:0]disp_0, disp_1, disp_2, disp_3, disp_4, disp_5;
wire [6:0] sev_0, sev_1, sev_2, sev_3, sev_4, sev_5;

assign HEX0 = sev_0;
assign HEX1 = sev_1;
assign HEX2 = sev_2; 
assign HEX3 = sev_3;
assign HEX4 = sev_4;
assign HEX5 = sev_5;

wire player_or_dealer;
assign player_or_dealer = SW[0];

wire deck_or_hands;
assign deck_or_hands = SW[1];

always @(*) begin
	if(deck_or_hands == 1'b1) begin
		if(player_or_dealer == 1'b1) begin
			disp_0 = dealer_hand[0];
			disp_1 = dealer_hand[1];
			disp_2 = dealer_hand[2];
			disp_3 = dealer_hand[3];
			disp_4 = dealer_hand[4];
			disp_5 = dealer_hand[5];
		end else begin
			disp_0 = player_hand[0];
			disp_1 = player_hand[1];
			disp_2 = player_hand[2];
			disp_3 = player_hand[3];
			disp_4 = player_hand[4];
			disp_5 = player_hand[5];
		end
	end else begin
		if(player_or_dealer == 1'b1) begin
			disp_0 = shuff_deck[0];
			disp_1 = shuff_deck[1];
			disp_2 = shuff_deck[2];
			disp_3 = shuff_deck[3];
			disp_4 = shuff_deck[4];
			disp_5 = shuff_deck[5];
		end else begin
			disp_0 = shuff_deck[6];
			disp_1 = shuff_deck[7];
			disp_2 = shuff_deck[8];
			disp_3 = shuff_deck[9];
			disp_4 = shuff_deck[10];
			disp_5 = shuff_deck[11];
		end
	end
end



always @(posedge clk or negedge rst) begin
    if(rst == 1'b0)begin
        S <= START;
    end else begin
        S <= NS;
    end
end

always @(*) begin
   
    case(S)

    START: begin
        if(input_start == 1'b1) begin
            NS = STOP_LFSR;
        end else begin
            NS = START;
        end
    end

    STOP_LFSR: begin
        if(stop_lfsr == 1'b1) begin
            NS = SERVE_TWO;
        end else begin
            NS = STOP_LFSR;
        end
    end

    SERVE_TWO: begin
        if(serve_two_done == 1'b1) begin
            NS = PLAYER_TURN;
        end else begin
            NS = SERVE_TWO;
        end
    end

    PLAYER_TURN: begin
        if(input_draw == 1'b1) begin
            NS = PLAYER_DRAW;
        end else if(input_fold)begin
            NS = DEALER_TURN;
        end else begin
            NS = PLAYER_TURN;
        end
    end

    PLAYER_DRAW: begin
        if(player_draw_done == 1'b1) begin
            if(player_busted == 1'b1) begin
                NS = PLAYER_BUST;
            end else begin
                NS = DELAY_HUMAN_SPEED;
            end
        end else begin
            NS = PLAYER_DRAW;
        end
    end

    DELAY_HUMAN_SPEED: begin
        if(delay_2_done == 1'b1) begin
            NS = PLAYER_TURN;
        end else begin
            NS = DELAY_HUMAN_SPEED;
        end
    end

    PLAYER_BUST: leds_out <= 10'b1111001111;

    DEALER_TURN: begin
        if(dealer_turn_done == 1'b1) begin
            if(dealer_draws == 1'b1) begin
                NS = DEALER_DRAW;
            end else begin
                NS = LOSS;
            end
        end else begin
            NS = DEALER_TURN;
        end
    end

    DEALER_DRAW:begin
        if(dealer_draw_done == 1'b1) begin
            if(dealer_busted == 1'b1) begin
                NS = DEALER_BUST;
            end else begin
                NS = DEALER_TURN;
            end
        end else begin
            NS = DEALER_DRAW;
        end
    end

    DEALER_BUST:  leds_out <= 10'b1010101010;

    LOSS:  leds_out <= 10'b1111111111;

    endcase
end


always @(posedge clk or negedge rst) begin
    
	 if(rst == 1'b0)begin
		 stop_lfsr <= 1'b1;
		 start_delay <= 1'b1;
		 delay_done <= 1'b1;
		 serve_two_done <= 1'b1;
		 
		dealer_hand[0] <= 4'd0;
		dealer_hand[1] <= 4'd0;
		dealer_hand[2] <= 4'd0;
		dealer_hand[3] <= 4'd0;
		dealer_hand[4] <= 4'd0;
		dealer_hand[5] <= 4'd0;

		player_hand[0] <= 4'd0;
		player_hand[1] <= 4'd0;
		player_hand[2] <= 4'd0;
		player_hand[3] <= 4'd0;
		player_hand[4] <= 4'd0;
		player_hand[5] <= 4'd0;

		shuff_deck[0] <= 4'd0;
		shuff_deck[1] <= 4'd0;
		shuff_deck[2]  <= 4'd0;
		shuff_deck[3]   <= 4'd0;
		shuff_deck[4]  <= 4'd0;
		shuff_deck[5]  <= 4'd0;
		shuff_deck[6]   <= 4'd0;
		shuff_deck[7]  <= 4'd0;
		shuff_deck[8]   <= 4'd0;
		shuff_deck[9]  <= 4'd0;
		shuff_deck[10]   <= 4'd0;
		shuff_deck[11]  <= 4'd0;
	 end
	 
    case(S)

    START: begin 
		 gen_card <= 1'b1; 
		 curr_card_deck <= 6'd4; 
		 curr_card_player <= 6'd2; 
		 curr_card_dealer <= 6'd2; 
		 
		shuff_deck[0] <= deck[0];
		shuff_deck[1] <= deck[1];
		shuff_deck[2] <= deck[2];
		shuff_deck[3] <= deck[3];
		shuff_deck[4] <= deck[4];
		shuff_deck[5] <= deck[5];
		shuff_deck[6] <= deck[6];
		shuff_deck[7] <= deck[7];
		shuff_deck[8] <= deck[8];
		shuff_deck[9] <= deck[9];
		shuff_deck[10] <= deck[10];
		shuff_deck[11] <= deck[11];
	 end

    STOP_LFSR: begin
        gen_card <= 1'b0;
		  gen_card <= 1'b0;
		  gen_card <= 1'b0;
		  gen_card <= 1'b0;
        stop_lfsr <= 1'b1;
    end

    SERVE_TWO: begin
        player_hand[0] <= shuff_deck[0];
        player_hand[1] <= shuff_deck[1];
        dealer_hand[0] <= shuff_deck[2];
        dealer_hand[1] <= shuff_deck[3];

        player_aces <= deck_aces[0] + deck_aces[1];
        dealer_aces <= deck_aces[2] + deck_aces[3];

        serve_two_done <= 1'b1;
    end

    //PLAYER_TURN:

    PLAYER_DRAW: begin 
        player_hand[curr_card_player] <= shuff_deck[curr_card_deck];
		  
        new_player_aces <= player_aces + deck_aces[curr_card_deck];
        player_aces <= new_player_aces;

        new_curr_card_player <= curr_card_player + 6'b1;
		  
        curr_card_player <= new_curr_card_player;

        new_curr_card_deck <= curr_card_deck + 6'b1;
        curr_card_deck <= new_curr_card_deck;

        player_points <= player_hand[0] + player_hand[1] + player_hand[2] + player_hand[3] + player_hand[4] + player_hand[5];

        if((player_points) > 5'd21) begin
            player_busted <= 1'b1;
        end else begin 
				player_busted <= 1'b0;
		  end

        player_draw_done <= 1'b1;
    end

    DELAY_HUMAN_SPEED: begin
        player_draw_done <= 1'b0;
        if(timer_2 < 32'd500000000) begin new_timer_2 <= timer_2 + 1'b1; timer_2 <= new_timer_2; end
        else begin timer_2 <= 1'b0; new_timer_2 <= 1'b0; delay_2_done = 1'b1; end
    end

    //PLAYER_BUST:

    DEALER_TURN:begin

        dealer_points <= dealer_hand[0] + dealer_hand[1] + dealer_hand[2] + dealer_hand[3] + dealer_hand[4] + dealer_hand[5];

        if(player_points >= dealer_points) dealer_draws = 1'b1;
        
        dealer_turn_done <= 1'b1;
    end

    DEALER_DRAW: begin 
        dealer_hand[curr_card_dealer] <= deck[curr_card_deck];
        new_dealer_aces <= dealer_aces + deck_aces[curr_card_deck];
        dealer_aces <= new_dealer_aces;

        new_curr_card_dealer <= curr_card_dealer + 1'b1;
        curr_card_dealer <= new_curr_card_dealer;

        new_curr_card_deck <= curr_card_deck + 1'b1;
        curr_card_deck <= new_curr_card_deck;

        dealer_points <= dealer_hand[0] + dealer_hand[1] + dealer_hand[2] + dealer_hand[3] + dealer_hand[4] + dealer_hand[5];

        if((dealer_points) > 5'd21) begin
            dealer_busted <= 1'b1;
        end else dealer_busted <= 1'b0;

        dealer_draw_done <= 1'b1;
    end

    //DEALER_BUST:

    endcase
end
endmodule