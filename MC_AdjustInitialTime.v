//MC_AdjustInitialTime.v

module MC_AdjustInitialTime(Clock, ResetN, startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, 
										startTimeSec_C, startTimeMin_C, startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C, 
										STsecUp, STsecDown, STminUp, STminDown, select);
	input Clock, ResetN;
	input STsecUp, STsecDown, STminUp, STminDown;
	input [1:0] select;
	
	output reg [5:0] startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C;			//신호등 count down 시작 시간
	output [17:0] startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C;				//신호등 count down 시작 시간 * 100
	
	wire STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE;
	
	always @(posedge Clock or negedge ResetN)
	begin
		if(!ResetN) begin
			startTimeSec_A <= 6'd5;
			startTimeMin_A <= 6'd0;
			startTimeSec_B <= 6'd5;
			startTimeMin_B <= 6'd0;
			startTimeSec_C <= 6'd5;
			startTimeMin_C <= 6'd0;
		end
		else begin
			case(select)
				2'b00: begin
					case({STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE})
						4'b1000: startTimeSec_A <= (startTimeSec_A == 6'd59) ? 6'd0 : startTimeSec_A + 1'b1;
						4'b0100: startTimeSec_A <= (startTimeSec_A == 6'd0) ? 6'd59 : startTimeSec_A - 1'b1;
						4'b0010: startTimeMin_A <= (startTimeMin_A == 6'd59) ? 6'd0 : startTimeMin_A + 1'b1;
						4'b0001: startTimeMin_A <= (startTimeMin_A == 6'd0) ? 6'd59 : startTimeMin_A - 1'b1;
					endcase
				end
				2'b01: begin
					case({STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE})
						4'b1000: startTimeSec_B <= (startTimeSec_B == 6'd59) ? 6'd0 : startTimeSec_B + 1'b1;
						4'b0100: startTimeSec_B <= (startTimeSec_B == 6'd0) ? 6'd59 : startTimeSec_B - 1'b1;
						4'b0010: startTimeMin_B <= (startTimeMin_B == 6'd59) ? 6'd0 : startTimeMin_B + 1'b1;
						4'b0001: startTimeMin_B <= (startTimeMin_B == 6'd0) ? 6'd59 : startTimeMin_B - 1'b1;
					endcase
				end
				2'b10: begin
					case({STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE})
						4'b1000: startTimeSec_C <= (startTimeSec_C == 6'd59) ? 6'd0 : startTimeSec_C + 1'b1;
						4'b0100: startTimeSec_C <= (startTimeSec_C == 6'd0) ? 6'd59 : startTimeSec_C - 1'b1;
						4'b0010: startTimeMin_C <= (startTimeMin_C == 6'd59) ? 6'd0 : startTimeMin_C + 1'b1;
						4'b0001: startTimeMin_C <= (startTimeMin_C == 6'd0) ? 6'd59 : startTimeMin_C - 1'b1;
					endcase
				end
				default: begin
					case({STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE})
						4'b1000: startTimeSec_A <= (startTimeSec_A == 6'd59) ? 6'd0 : startTimeSec_A + 1'b1;
						4'b0100: startTimeSec_A <= (startTimeSec_A == 6'd0) ? 6'd59 : startTimeSec_A - 1'b1;
						4'b0010: startTimeMin_A <= (startTimeMin_A == 6'd59) ? 6'd0 : startTimeMin_A + 1'b1;
						4'b0001: startTimeMin_A <= (startTimeMin_A == 6'd0) ? 6'd59 : startTimeMin_A - 1'b1;
					endcase
				end
			endcase
		end
	end
	
	assign startTimeMultiply100_A = (startTimeMin_A * 60 + startTimeSec_A) * 100 - 1;
	assign startTimeMultiply100_B = (startTimeMin_B * 60 + startTimeSec_B) * 100 - 1;
	assign startTimeMultiply100_C = (startTimeMin_C * 60 + startTimeSec_C) * 100 - 1;
	
	MC_OneShotEnable secUp_OSE(Clock, STsecUp, STsecUp_OSE);
	MC_OneShotEnable secDown_OSE(Clock, STsecDown, STsecDown_OSE);
	MC_OneShotEnable minUp_OSE(Clock, STminUp, STminUp_OSE);
	MC_OneShotEnable minDown_OSE(Clock, STminDown, STminDown_OSE);

endmodule
