//MC_VehicleTrafficLight.v

module MC_VehicleTrafficLight(CLK_100Hz, ResetN, LCD_E, LCD_RS, LCD_RW, LCD_DATA, state, CNT);
	
	input CLK_100Hz, ResetN;
	input [3:0] state;
	input [8:0] CNT;
	
	output LCD_E;
	output reg LCD_RS, LCD_RW;
	output reg [7:0] LCD_DATA;
	
	parameter 	DELAY				= 4'd0,
					FUNCTION_SET	= 4'd1,
					ENTRY_MODE		= 4'd2,
					DISP_ONOFF		= 4'd3,
					NUMBER_OUTPUT	= 4'd4,
					A_STATE			= 4'd5,
					B_STATE			= 4'd6,
					C_STATE			= 4'd7;
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
	
	always @(posedge CLK_100Hz or negedge ResetN)
	begin
		if(!ResetN)
		begin
			LCD_RS <= 1'b1;
			LCD_RW <= 1'b1;
			LCD_DATA <= 8'b0000_0000;
		end
		else
		begin
			case(state)
				FUNCTION_SET:
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0011_1100;	//DL = 1 (8bits), N = 1(2Lines)
				end
				ENTRY_MODE:
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_0110;	//I/D = 1, S = 0
				end
				DISP_ONOFF:
				begin
					LCD_RS <= 1'b0;
					LCD_RW <= 1'b0;
					LCD_DATA <= 8'b0000_1111;	//{D, C, B} = 111
				end
				NUMBER_OUTPUT:
				begin
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
						400:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						401:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						402:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						403:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						404:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						405:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						406:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= E;	// E 출력
						end
						407:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_0010;	//Address setting: 0x42, 3.
						end
						408:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						409:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						410:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						411:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						412:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						413:
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
						400:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1100_1010;	//Address setting: 0x4A, 1.
						end
						401:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						402:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						403:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						404:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						405:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						406:
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
						400:
						begin
							LCD_RS <= 1'b0;
							LCD_DATA <= 8'b1000_1010;	//Address setting: 0x0A, 2.
						end
						401:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= O;	// O 출력
						end
						402:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= R;	// R 출력
						end
						403:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= A;	// A 출력
						end
						404:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= N;	// N 출력
						end
						405:
						begin
							LCD_RS <= 1'b1;
							LCD_DATA <= G;	// G 출력
						end
						406:
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
			endcase
		end
	end
	
	//MC_DigitalClock_Action DCA1(Clock, ResetN, sec10, sec1, min10, min1, hour10, hour1, mode, secUp, minUp, hourUp);
	
endmodule

