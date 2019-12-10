//MC_AdjustInitialTime.v

module MC_AdjustInitialTime(Clock, ResetN, mode, mode2, startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, 
										startTimeSec_C, startTimeMin_C, startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C, 
										blinkStartTimeSec_A, blinkStartTimeMin_A, blinkStartTimeSec_B, blinkStartTimeMin_B, 
										blinkStartTimeSec_C, blinkStartTimeMin_C, blinkStartTimeMultiply100_A, blinkStartTimeMultiply100_B, blinkStartTimeMultiply100_C, 
										STsecUp, STsecDown, STminUp, STminDown, select);
	input Clock, ResetN, mode, mode2;
	input STsecUp, STsecDown, STminUp, STminDown;
	input [1:0] select;
	
	output reg [5:0] startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C, 
						blinkStartTimeSec_A, blinkStartTimeMin_A, blinkStartTimeSec_B, blinkStartTimeMin_B,	blinkStartTimeSec_C, blinkStartTimeMin_C;			//신호등 count down 시작 시간
	output [17:0] startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C, 
						blinkStartTimeMultiply100_A, blinkStartTimeMultiply100_B, blinkStartTimeMultiply100_C;				//신호등 count down 시작 시간 * 100
	
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
			blinkStartTimeSec_A <= 6'd3;
			blinkStartTimeMin_A <= 6'd0;
			blinkStartTimeSec_B <= 6'd3;
			blinkStartTimeMin_B <= 6'd0;
			blinkStartTimeSec_C <= 6'd3;
			blinkStartTimeMin_C <= 6'd0;
		end
		else begin
			if(mode == 1'b1) begin
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
			else if(mode2 == 1'b1) begin
				case(select)
					2'b00: begin
						case({STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE})
							4'b1000: blinkStartTimeSec_A <= (blinkStartTimeSec_A == 6'd59) ? 6'd0 : blinkStartTimeSec_A + 1'b1;
							4'b0100: blinkStartTimeSec_A <= (blinkStartTimeSec_A == 6'd0) ? 6'd59 : blinkStartTimeSec_A - 1'b1;
							4'b0010: blinkStartTimeMin_A <= (blinkStartTimeMin_A == 6'd59) ? 6'd0 : blinkStartTimeMin_A + 1'b1;
							4'b0001: blinkStartTimeMin_A <= (blinkStartTimeMin_A == 6'd0) ? 6'd59 : blinkStartTimeMin_A - 1'b1;
						endcase
					end
					2'b01: begin
						case({STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE})
							4'b1000: blinkStartTimeSec_B <= (blinkStartTimeSec_B == 6'd59) ? 6'd0 : blinkStartTimeSec_B + 1'b1;
							4'b0100: blinkStartTimeSec_B <= (blinkStartTimeSec_B == 6'd0) ? 6'd59 : blinkStartTimeSec_B - 1'b1;
							4'b0010: blinkStartTimeMin_B <= (blinkStartTimeMin_B == 6'd59) ? 6'd0 : blinkStartTimeMin_B + 1'b1;
							4'b0001: blinkStartTimeMin_B <= (blinkStartTimeMin_B == 6'd0) ? 6'd59 : blinkStartTimeMin_B - 1'b1;
						endcase
					end
					2'b10: begin
						case({STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE})
							4'b1000: blinkStartTimeSec_C <= (blinkStartTimeSec_C == 6'd59) ? 6'd0 : blinkStartTimeSec_C + 1'b1;
							4'b0100: blinkStartTimeSec_C <= (blinkStartTimeSec_C == 6'd0) ? 6'd59 : blinkStartTimeSec_C - 1'b1;
							4'b0010: blinkStartTimeMin_C <= (blinkStartTimeMin_C == 6'd59) ? 6'd0 : blinkStartTimeMin_C + 1'b1;
							4'b0001: blinkStartTimeMin_C <= (blinkStartTimeMin_C == 6'd0) ? 6'd59 : blinkStartTimeMin_C - 1'b1;
						endcase
					end
					default: begin
						case({STsecUp_OSE, STsecDown_OSE, STminUp_OSE, STminDown_OSE})
							4'b1000: blinkStartTimeSec_A <= (blinkStartTimeSec_A == 6'd59) ? 6'd0 : blinkStartTimeSec_A + 1'b1;
							4'b0100: blinkStartTimeSec_A <= (blinkStartTimeSec_A == 6'd0) ? 6'd59 : blinkStartTimeSec_A - 1'b1;
							4'b0010: blinkStartTimeMin_A <= (blinkStartTimeMin_A == 6'd59) ? 6'd0 : blinkStartTimeMin_A + 1'b1;
							4'b0001: blinkStartTimeMin_A <= (blinkStartTimeMin_A == 6'd0) ? 6'd59 : blinkStartTimeMin_A - 1'b1;
						endcase
					end
				endcase
			end
		end
	end
	
	assign startTimeMultiply100_A = (startTimeMin_A * 60 + startTimeSec_A) * 100 - 1;
	assign startTimeMultiply100_B = (startTimeMin_B * 60 + startTimeSec_B) * 100 - 1;
	assign startTimeMultiply100_C = (startTimeMin_C * 60 + startTimeSec_C) * 100 - 1;
	assign blinkStartTimeMultiply100_A = (blinkStartTimeMin_A * 60 + blinkStartTimeSec_A) * 100 - 1;
	assign blinkStartTimeMultiply100_B = (blinkStartTimeMin_B * 60 + blinkStartTimeSec_B) * 100 - 1;
	assign blinkStartTimeMultiply100_C = (blinkStartTimeMin_C * 60 + blinkStartTimeSec_C) * 100 - 1;
	
	MC_OneShotEnable secUp_OSE(Clock, STsecUp, STsecUp_OSE);
	MC_OneShotEnable secDown_OSE(Clock, STsecDown, STsecDown_OSE);
	MC_OneShotEnable minUp_OSE(Clock, STminUp, STminUp_OSE);
	MC_OneShotEnable minDown_OSE(Clock, STminDown, STminDown_OSE);

endmodule
