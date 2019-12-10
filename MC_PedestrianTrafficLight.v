//MC_PedestrianTrafficLight.v

module MC_PedestrianTrafficLight(Clock, CLK_100Hz, ResetN, state, CNT, startTimeSec_A, startTimeMin_A, 
											startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C, 
											blinkStartTimeMultiply100_A, blinkStartTimeMultiply100_B, blinkStartTimeMultiply100_C, 
											PTL_A, PTL_B, PTL_C, SEG_COM, SEG_DATA, PIEZO, PIEZO_onOff, POS, POS_LED, POS_flag);
	
	input Clock, CLK_100Hz, ResetN;
	input [3:0] state;
	input [17:0] CNT;
	input [5:0] startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C;
	input [17:0] blinkStartTimeMultiply100_A, blinkStartTimeMultiply100_B, blinkStartTimeMultiply100_C;				//신호등 blink시작 시간 * 100
	input PIEZO_onOff;
	input POS;
	
	output reg [1:0] PTL_A, PTL_B, PTL_C;	//Pedestrian Traffic Light (보행자 신호등)
	output [3:0] SEG_COM;	//보행자 신호등 남은 시간
	output [7:0] SEG_DATA;		//보행자 신호등 남은 시간
	//output [6:0] SEG_DATA;	
	output reg PIEZO;			//for PIEZO
	output reg POS_LED;
	output reg POS_flag;	//for state 순서 변경 - c, b, a
	
	//reg [3:0] secLeft;		//for 7segment, 신호등 남은 시간
	reg piezoEnable, piezoEnable2, piezoEnable3;			//for PIEZO, 2: togle 반복용
	reg [10:0] CNT_PIEZO;	//for PIEZO
	reg [5:0] CNT_PIEZO_ITERATION;		//PIEZO 일정 주기로 togle 반복
	reg [2:0] CNT_PIEZO_ITERATION_2;		//PIEZO 일정 주기로 togle 반복
	reg [6:0] cnt2;	//0~99, for count down
	reg [17:0] blinkStartTimeMultiply100_tmep;
	
	parameter	A_STATE	= 4'd5,
					B_STATE	= 4'd6,
					C_STATE	= 4'd7;
	
	always @(posedge CLK_100Hz) begin	/*CNT or negedge ResetN*/
		if(!ResetN) begin
			piezoEnable <= 1'b0;		//for PIEZO
			//secLeft <= 4'b1111;
			PTL_A <= 2'b00;
			PTL_B <= 2'b00;
			PTL_C <= 2'b00;
		end
		
		if(state == A_STATE || state == B_STATE || state == C_STATE) begin
			if(CNT < 99) begin
				piezoEnable <= 1'b0;		//for PIEZO
				//secLeft <= 4'b1111;		//남은 시간: NULL
				PTL_A <= 2'b01;//00
				PTL_B <= 2'b01;//00
				PTL_C <= 2'b01;//00
			end
			else begin
				case(state)
					A_STATE: blinkStartTimeMultiply100_tmep <= blinkStartTimeMultiply100_A;
					B_STATE: blinkStartTimeMultiply100_tmep <= blinkStartTimeMultiply100_B;
					C_STATE:	blinkStartTimeMultiply100_tmep <= blinkStartTimeMultiply100_C;
					default: blinkStartTimeMultiply100_tmep <= blinkStartTimeMultiply100_A;
				endcase
	//			if(state == A_STATE || state == B_STATE || state == C_STATE) begin
				if(CNT >= blinkStartTimeMultiply100_tmep-1 && PIEZO_onOff)//300
					piezoEnable <= 1'b1;
				else
					piezoEnable <= 1'b0;
				
				//신호등 Light 표시
				if(CNT < blinkStartTimeMultiply100_tmep-1)		//3초 뒤 toggle
					case(state)
						A_STATE: begin
							PTL_A <= 2'b10;//11
							PTL_B <= 2'b01;//00
							PTL_C <= 2'b01;//00
						end
						B_STATE: begin
							PTL_A <= 2'b01;//00
							PTL_B <= 2'b10;//11
							PTL_C <= 2'b01;//00
						end
						C_STATE:	begin
							PTL_A <= 2'b01;//00
							PTL_B <= 2'b01;//00
							PTL_C <= 2'b10;//11
						end
						default: begin
							PTL_A <= 2'b01;//00
							PTL_B <= 2'b01;//00
							PTL_C <= 2'b01;//00
						end
					endcase
/*				else if(CNT == 400) begin
					//PTL_A <= 2'b00;
					//PTL_B <= 2'b00;
					//PTL_C <= 2'b00;
					case(state)
						A_STATE: begin
							PTL_A <= 2'b00;
							PTL_B <= 2'b01;//00
							PTL_C <= 2'b01;//00
						end
						B_STATE: begin
							PTL_A <= 2'b01;//00
							PTL_B <= 2'b00;//11
							PTL_C <= 2'b01;//00
						end
						C_STATE:	begin
							PTL_A <= 2'b01;//00
							PTL_B <= 2'b01;//00
							PTL_C <= 2'b00;//11
						end
						default: begin
							PTL_A <= 2'b01;//00
							PTL_B <= 2'b01;//00
							PTL_C <= 2'b01;//00
						end
					endcase
				end*/
				else begin
					case(state)
						A_STATE: begin
							//PTL_A <= (cnt2 >= 7'd49) ? PTL_A ^ 2'b11 : PTL_A;	//Toggle
							PTL_A[0] <=1'b0;
							PTL_A[1] <= (cnt2 == 7'd00 || cnt2 == 7'd50) ? PTL_A[1] ^ 1'b1 : PTL_A[1];	//Toggle
							PTL_B <= 2'b01;//00
							PTL_C <= 2'b01;//00
						end
						B_STATE: begin
							PTL_A <= 2'b01;//00
							//PTL_B <= (cnt2 >= 7'd49) ? PTL_B ^ 2'b11 : PTL_B;	//Toggle
							PTL_B[0] <=1'b0;
							PTL_B[1] <= (cnt2 == 7'd00 || cnt2 == 7'd50) ? PTL_B[1] ^ 1'b1 : PTL_B[1];	//Toggle
							PTL_C <= 2'b01;//00
						end
						C_STATE:	begin
							PTL_A <= 2'b01;//00
							PTL_B <= 2'b01;//00
							//PTL_C <= (cnt2 >= 7'd49) ? PTL_C ^ 2'b11 : PTL_C;	//Toggle
							PTL_C[0] <=1'b0;
							PTL_C[1] <= (cnt2 == 7'd00 || cnt2 == 7'd50) ? PTL_C[1] ^ 1'b1 : PTL_C[1];	//Toggle
						end
						default: begin
							PTL_A <= 2'b01;//00
							PTL_B <= 2'b01;//00
							PTL_C <= 2'b01;//00
						end
					endcase
				end
			end
		end
		else begin
			PTL_A <= 2'b00;
			PTL_B <= 2'b00;
			PTL_C <= 2'b00;
			piezoEnable <= 1'b0;
		end
	end
	
	//pedestrian operation signal, B 신호등에 부착됨, Button swich 2 누르면 LED on
	always @(posedge CLK_100Hz or negedge ResetN) begin
		if(!ResetN) begin
			POS_LED <= 1'b0;
			POS_flag <= 1'b0;
		end
		else if(POS == 1'b1) begin
			POS_LED <= 1'b1;
			if(state == C_STATE)
				POS_flag <= 1'b1;
		end
		else begin
			if(state == A_STATE)
				POS_flag <= 1'b0;
			else if(state == B_STATE)
				POS_LED <= 1'b0;
		end
	end
	
	//PIEZO
	always @(posedge Clock or negedge ResetN) begin
		if(!ResetN) begin
			CNT_PIEZO <= 11'd0;
			PIEZO <= 11'd0;
		end
		else if(piezoEnable & piezoEnable2 & piezoEnable3) begin	//C3, ?1,911.127963012794?
		CNT_PIEZO <= (CNT_PIEZO >= 11'd477) ? 11'd0 : CNT_PIEZO + 1'b1;//1910//955
		PIEZO <= (CNT_PIEZO >= 11'd477) ? ~PIEZO : PIEZO;
		//BCD <= 4'd1;
		end
	end
	
	always @(posedge CLK_100Hz or negedge ResetN) begin
		if(!ResetN) begin
			CNT_PIEZO_ITERATION <= 6'd0;
			CNT_PIEZO_ITERATION_2 <= 6'd0;
			piezoEnable2 <= 6'd0;
			piezoEnable3 <= 6'd0;
		end
		else if(piezoEnable) begin
			CNT_PIEZO_ITERATION <= (CNT_PIEZO_ITERATION >= 6'd49) ? 6'd0 : CNT_PIEZO_ITERATION + 1'b1;
			piezoEnable2 <= (CNT_PIEZO_ITERATION >= 6'd49) ? ~piezoEnable2 : piezoEnable2;
			CNT_PIEZO_ITERATION_2 <= (CNT_PIEZO_ITERATION_2 >= 3'd4) ? 3'd0 : CNT_PIEZO_ITERATION_2 + 1'b1;
			piezoEnable3 <= (CNT_PIEZO_ITERATION_2 >= 3'd4) ? ~piezoEnable3 : piezoEnable3;
		end
		else begin
			CNT_PIEZO_ITERATION <= 6'd0;
			CNT_PIEZO_ITERATION_2 <= 6'd0;
		end
	end
	
	//0~99 count
	always @(posedge CLK_100Hz or negedge ResetN) begin
		if(!ResetN)
			cnt2 <= 7'd0;
		else if(CNT == 9'd0)
			cnt2 <= 7'd0;
		else
			cnt2 <= (cnt2 >= 7'd99) ? 0 : cnt2 + 7'd1;
	end
	
	MC_DigitalClock_forProject countDown(.Clock(Clock), .CLK_100Hz(CLK_100Hz), .cnt(CNT), .cnt2(cnt2), .ResetN(ResetN), .state(state), .SEG_COM(SEG_COM), .SEG_DATA(SEG_DATA), 
												.startTimeSec_A(startTimeSec_A), .startTimeMin_A(startTimeMin_A), .startTimeSec_B(startTimeSec_B), .startTimeMin_B(startTimeMin_B), 
												.startTimeSec_C(startTimeSec_C), .startTimeMin_C(startTimeMin_C));
	//MC_7SegmentDecoder_forProject_2 M3(.BCD(secLeft), .dot(), .SEG_DATA(SEG_DATA));
	
endmodule
