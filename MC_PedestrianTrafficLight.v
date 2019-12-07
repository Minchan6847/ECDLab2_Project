//MC_PedestrianTrafficLight.v

module MC_PedestrianTrafficLight(Clock, CLK_100Hz, ResetN, state, CNT, PTL_A, PTL_B, PTL_C, SEG_DATA, PIEZO, POS, POS_LED, POS_flag);
	
	input Clock, CLK_100Hz, ResetN;
	input [3:0] state;
	input [8:0] CNT;
	input POS;
	
	output reg [1:0] PTL_A, PTL_B, PTL_C;	//Pedestrian Traffic Light (보행자 신호등)
	output [6:0] SEG_DATA;	//보행자 신호등 남은 시간
	output reg PIEZO;			//for PIEZO
	output reg POS_LED;
	output reg POS_flag;	//for state 순서 변경 - c, b, a
	
	reg [3:0] secLeft;		//for 7segment, 신호등 남은 시간
	reg piezoEnable, piezoEnable2;			//for PIEZO, 2: togle 반복용
	reg [10:0] CNT_PIEZO;	//for PIEZO
	reg [5:0] CNT_PIEZO_ITERATION;	//PIEZO 일정 주기로 togle 반복
	
	parameter	A_STATE	= 4'd5,
					B_STATE	= 4'd6,
					C_STATE	= 4'd7;
	
	always @(*) begin	/*CNT or negedge ResetN*/
		if(!ResetN) begin
			piezoEnable <= 1'b0;		//for PIEZO
			secLeft <= 4'b1111;
			PTL_A <= 2'b00;
			PTL_B <= 2'b00;
			PTL_C <= 2'b00;
		end
		
		if(CNT < 99) begin
			piezoEnable <= 1'b0;		//for PIEZO
			secLeft <= 4'b1111;		//남은 시간: NULL
			PTL_A <= 2'b00;
			PTL_B <= 2'b00;
			PTL_C <= 2'b00;
		end
		else begin
			//PIEZO와 남은 시간 표시
			if(state == A_STATE || state == B_STATE || state == C_STATE) begin
				piezoEnable <= 1'b1;
				secLeft <= /*(secLeft < 99) ? 5 : */(CNT< 199) ? 4'd4 : //신호등 남은 시간
															((CNT < 299) ? 4'd3 : 
															((CNT < 399) ? 4'd2 : 
															((CNT < 499) ? 1 : 4'b1111)));
			end
			else begin
				piezoEnable <= 1'b0;
				secLeft <= 4'b1111;
			end
			
			//신호등 Light 표시
			case(state)
				A_STATE: begin
					PTL_A <= 2'b11;
					PTL_B <= 2'b00;
					PTL_C <= 2'b00;
				end
				B_STATE: begin
					PTL_A <= 2'b00;
					PTL_B <= 2'b11;
					PTL_C <= 2'b00;
				end
				C_STATE:	begin
					PTL_A <= 2'b00;
					PTL_B <= 2'b00;
					PTL_C <= 2'b11;
				end
				default: begin
					PTL_A <= 2'b00;
					PTL_B <= 2'b00;
					PTL_C <= 2'b00;
				end
			endcase
		end
	end
	
	always @(posedge CLK_100Hz or negedge ResetN) begin	//pedestrian operation signal, B 신호등에 부착됨, Button swich 2 누르면 LED on
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
		else if(piezoEnable & piezoEnable2) begin	//C3, ?1,911.127963012794?
		CNT_PIEZO <= (CNT_PIEZO >= 11'd1910) ? 11'd0 : CNT_PIEZO + 1'b1;
		PIEZO <= (CNT_PIEZO >= 11'd1910) ? ~PIEZO : PIEZO;
		//BCD <= 4'd1;
		end
	end
	
	always @(posedge CLK_100Hz or negedge ResetN) begin
		if(!ResetN) begin
			CNT_PIEZO_ITERATION <= 6'd0;
			piezoEnable2 <= 6'd0;
		end
		else if(piezoEnable) begin
			CNT_PIEZO_ITERATION <= (CNT_PIEZO_ITERATION >= 6'd50) ? 6'd0 : CNT_PIEZO_ITERATION + 1'b1;
			piezoEnable2 <= (CNT_PIEZO_ITERATION >= 6'd50) ? ~piezoEnable2 : piezoEnable2;
		end
	end
	
	MC_7SegmnetDecoder_forProject M3(.BCD(secLeft), .SEG_DATA(SEG_DATA));
	
endmodule
