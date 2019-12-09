//MC_VehicleTrafficLight.v

module MC_VehicleTrafficLight(CLK_100Hz, Clock, ResetN, LCD_E, LCD_RS, LCD_RW, LCD_DATA, state, CNT, startTimeSec_A, startTimeMin_A, 
										startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C, 
										startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C, select);
	
	input CLK_100Hz, Clock, ResetN;
	input [3:0] state;
	input [17:0] CNT;
	input [5:0] startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C;	//신호등 count down 시작 시간
	input [17:0] startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C;
	input [1:0] select;
	
	output LCD_E;
	output reg LCD_RS, LCD_RW;
	output reg [7:0] LCD_DATA;
	
	reg [5:0] startTimeSecTemp, startTimeMinTemp;
	
	wire [17:0] startTimeMultiply100Minus100_A, startTimeMultiply100Minus100_B, startTimeMultiply100Minus100_C;
	wire [3:0] min10, min1, sec10, sec1;
	
	parameter 	DELAY				= 4'd0,
					FUNCTION_SET	= 4'd1,
					DISP_ONOFF		= 4'd2,
					ENTRY_MODE		= 4'd3,
					NUMBER_OUTPUT	= 4'd4,
					A_STATE			= 4'd5,
					B_STATE			= 4'd6,
					C_STATE			= 4'd7,
					ADJUSTMENT		= 4'd8,
					ALL_ORANGE		= 4'd9,			//for 점멸 신호
					ALL_RED	 		= 4'd10,			//for 점멸 신호
					EXTINGUISH_ALL_O	= 4'd11,		//for 점멸 신호
					EXTINGUISH_ALL_R	= 4'd12,		//for 점멸 신호
					EXTINGUISH_ALL_A	= 4'd13;		//for mode
	parameter	R	= 8'b0101_0010,
					E	= 8'b0100_0101,
					D	= 8'b0100_0100,
					L	= 8'b0100_1100,
					F	= 8'b0100_0110,
					T	= 8'b0101_0100,
					G	= 8'b0100_0111,
					N	= 8'b0100_1110,
					O	= 8'b0100_1111,
					A	= 8'b0100_0001;
					//PERIOD = 8'b0010_1110;	//마침표 (.)
	
	assign LCD_E = CLK_100Hz;
	assign startTimeMultiply100Minus100_A = startTimeMultiply100_A - 18'd100;
	assign startTimeMultiply100Minus100_B = startTimeMultiply100_B - 18'd100;
	assign startTimeMultiply100Minus100_C = startTimeMultiply100_C - 18'd100;
	
	always @(posedge Clock or negedge ResetN) begin
		if(!ResetN) begin
			LCD_RS <= 1'b1;
			LCD_RW <= 1'b1;
			LCD_DATA <= 8'b0000_0000;
		end
		else begin
			case(state)
				FUNCTION_SET: begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0011_1100;	//IF = 1 (8bits), N = 1(2Lines)
				end
				DISP_ONOFF: begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_1100;	//{D, C, B} = 100
				end
				ENTRY_MODE: begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0110;	//I/D = 1, S = 0
				end
				NUMBER_OUTPUT: begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin		//clear display
							LCD_RS <= 1'b0;
							LCD_RW <= 1'b0;
							LCD_DATA <= 8'b0000_0001;
						end
						1:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1000;	//Address setting: 0x08
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= {4'b0011, 4'd2};	//2 출력
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110;	//. 출력
						end
						4:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0000;	//Address setting: 0x40
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= {4'b0011, 4'd3};	//3 출력
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110;	//. 출력
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1000;	//Address setting: 0x48
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= {4'b0011, 4'd1};	//1 출력
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_1110;	//. 출력
						end
						default:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
					endcase
				end
				A_STATE:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						14:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						15:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						16:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						17:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= D;	// D 출력
						end
						18:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						19:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						20:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
			//주황불
						startTimeMultiply100Minus100_A:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						startTimeMultiply100Minus100_A + 1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						startTimeMultiply100Minus100_A + 2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						startTimeMultiply100Minus100_A + 3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						startTimeMultiply100Minus100_A + 4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						startTimeMultiply100Minus100_A + 5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						startTimeMultiply100Minus100_A + 6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						startTimeMultiply100Minus100_A + 7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						startTimeMultiply100Minus100_A + 8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						startTimeMultiply100Minus100_A + 9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						startTimeMultiply100Minus100_A + 10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						startTimeMultiply100Minus100_A + 11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						startTimeMultiply100Minus100_A + 12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						startTimeMultiply100Minus100_A + 13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				B_STATE:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= D;	// D 출력
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= D;	// D 출력
						end
						11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						14:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						15:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= L;	// L 출력
						end
						16:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						17:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= F;	// F 출력
						end
						18:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= T;	// T 출력
						end
						19:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						20:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
			//주황불
						startTimeMultiply100Minus100_B:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						startTimeMultiply100Minus100_B + 1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						startTimeMultiply100Minus100_B + 2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						startTimeMultiply100Minus100_B + 3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						startTimeMultiply100Minus100_B + 4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						startTimeMultiply100Minus100_B + 5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						startTimeMultiply100Minus100_B + 6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				C_STATE:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= L;	// L 출력
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= F;	// F 출력
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= T;	// T 출력
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= D;	// D 출력
						end
						11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						14:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						15:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						16:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						17:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= D;	// D 출력
						end
						18:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						19:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						20:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
			//주황불
						startTimeMultiply100Minus100_C:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						startTimeMultiply100Minus100_C + 1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						startTimeMultiply100Minus100_C + 2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						startTimeMultiply100Minus100_C + 3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						startTimeMultiply100Minus100_C + 4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						startTimeMultiply100Minus100_C + 5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						startTimeMultiply100Minus100_C + 6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				ADJUSTMENT: begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_0000;	//Address setting: 0x00//8
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= {4'b0011, min10};	//min10 출력
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= {4'b0011, min1};	//min1 출력
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0011_1010;	//colon 출력
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= {4'b0011, sec10};	//sec10 출력
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= {4'b0011, sec1};	//sec1 출력
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				ALL_ORANGE:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						14:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						15:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						16:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						17:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						18:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						19:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						20:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				ALL_RED:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= D;	// D 출력
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= D;	// D 출력
						end
						11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						14:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						15:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						16:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						17:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= D;	// D 출력
						end
						18:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						19:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						20:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				EXTINGUISH_ALL_O:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						14:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						15:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						16:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						17:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						18:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						19:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						20:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				EXTINGUISH_ALL_R:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						14:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						15:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						16:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						17:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						18:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						19:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						20:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				EXTINGUISH_ALL_A:
				begin
					LCD_RW <= 1'b0;
					case(CNT)
						0:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						1:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						2:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						3:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						4:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						5:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						6:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						7:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						8:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						9:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						10:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						11:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						12:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						13:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						14:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						15:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						16:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						17:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						18:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						19:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						20:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= 8'b0010_0000;	//(SPACE)
						end
						default:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b0100_0000;	//CG-RAM Adress, for Nothing do
						end
					endcase
				end
				default: begin
					LCD_RS <= 1'b1;
					LCD_RW <= 1'b1;
					LCD_DATA <= 8'b0000_0000;
				end
			endcase
		end
	end
	
	always @(posedge CLK_100Hz) begin
		case(select)
			2'b00: begin
				startTimeSecTemp <= startTimeSec_A;
				startTimeMinTemp <= startTimeMin_A;
			end
			2'b01: begin
				startTimeSecTemp <= startTimeSec_B;
				startTimeMinTemp <= startTimeMin_B;
			end
			2'b10: begin
				startTimeSecTemp <= startTimeSec_C;
				startTimeMinTemp <= startTimeMin_C;
			end
			default: begin
				startTimeSecTemp <= startTimeSec_A;
				startTimeMinTemp <= startTimeMin_A;
			end
		endcase
	end
	
	MC_DigitalClock_Separator sec_SEP(startTimeSecTemp, sec10, sec1);
	MC_DigitalClock_Separator min_SEP(startTimeMinTemp, min10, min1);
	
endmodule
