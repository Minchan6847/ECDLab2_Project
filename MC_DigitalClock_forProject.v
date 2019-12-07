//MC_DigitalClock_forProject.v

module MC_DigitalClock_forProject(Clock, CLK_100Hz, cnt, cnt2, ResetN, state, SEG_COM, SEG_DATA, startTimeSec_A, startTimeMin_A, 
												startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C);
	
	input Clock, CLK_100Hz, ResetN/*, mode, minUp, secUp*/;
	input [17:0] cnt;
	input [5:0] startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C;
	input [6:0] cnt2;
	input [3:0] state;
	
	output reg [3:0] SEG_COM;
	output [7:0] SEG_DATA;
	
	reg [5:0] min, sec;
	reg [3:0] num;
	reg seg_dot;
	reg [1:0] cnt_scan;
	
	wire [3:0] min10, min1, sec10, sec1;
	
	parameter	A_STATE	= 4'd5,
					B_STATE	= 4'd6,
					C_STATE	= 4'd7;
					
	always @(posedge CLK_100Hz)
	begin
/*		if(!ResetN)
		begin
			//cnt <= 10'd0;
			sec <= 6'd0;
			min <= 6'd0;
		end*/
		if(cnt == 9'd0) begin
			case(state)
				A_STATE: begin
					sec <= startTimeSec_A;
					min <= startTimeMin_A;
				end
				B_STATE: begin
					sec <= startTimeSec_B;
					min <= startTimeMin_B;
				end
				C_STATE: begin
					sec <= startTimeSec_C;
					min <= startTimeMin_C;
				end
				default: begin
					sec <= 0;
					min <= 0;
				end
			endcase
		end
		else begin		//1초마다 Count down
			//sec <= (cnt2 == 7'd99) ? ((sec == 6'd00) ? 6'd59 : sec - 1'b1) : sec;
			sec <= (cnt2 == 7'd99) ? ((sec == 6'd0) ? 6'd59 : sec - 1'b1) : sec;
			min <= (cnt2 ==  7'd99 & sec == 6'd0) ?  min - 1'b1 : min;
		end
		
		/*
		else if(!mode) begin		//1초마다 Count up
			//cnt <= (cnt == 10'd999) ? 10'd0 : cnt + 1'b1;
			sec <= (cnt == 10'd99) ? ((sec == 6'd00) ? 6'd59 : sec - 1'b1) : sec;
			min <= (cnt == 10'd99 & sec == 6'd00) ? ((min == 6'd00) ? 6'd59 : min - 1'b1) : min;
		end
		else if(mode) begin		//버튼 스위치 누를 때마다 Count up
			if(secUp_OSE)
				sec <= (sec == 6'd59) ? 6'd0 : sec + 1'b1;
			else if(minUp_OSE)
				min <= (min == 6'd59) ? 6'd0 : min + 1'b1;
		end
		*/
	end
	
	always @(posedge Clock or negedge ResetN)
	begin
		if(!ResetN) begin
			seg_dot <= 1'b0;
			SEG_COM <= 4'b0000;
			num <= 4'd0;
			cnt_scan <= 2'd0;
		end
		else if(cnt >= 99) begin
			cnt_scan <= cnt_scan + 1'b1;
			case(cnt_scan)
				2'd0:
					begin
						num <= min10;
						num <= min10;
						seg_dot <= 1'b0;
						SEG_COM <= 4'b0111;
					end
				2'd1:
					begin
						num <= min1;
						seg_dot <= 1'b1;
						SEG_COM <= 4'b1011;
					end
				2'd2:
					begin
						num <= sec10;
						seg_dot <= 1'b0;
						SEG_COM <= 4'b1101;
					end
				2'd3:
					begin
						num <= sec1;
						seg_dot <= 1'b0;
						SEG_COM <= 4'b1110;
					end
			endcase
		end
		else begin
			num <= 4'b1111;	//NULL
			seg_dot <= 1'b0;
		end
	end
	
	/****************One shot enable****************/
	/*
	always @(negedge Clock)
	begin
		secUp_1 <= secUp;
		secUp_2 <= secUp_1;
		minUp_1 <= minUp;
		minUp_2 <= minUp_1;
	end
	
	assign secUp_OSE = secUp_1 && ~secUp_2;
	assign minUp_OSE = minUp_1 && ~minUp_2;
	*/
	/***********************************************/
	
	MC_DigitalClock_Separator sec_SEP(sec, sec10, sec1);
	MC_DigitalClock_Separator min_SEP(min, min10, min1);
	MC_DigitalClock_7SegmentDecoder Decoder1(num, seg_dot, SEG_DATA);
	
endmodule
