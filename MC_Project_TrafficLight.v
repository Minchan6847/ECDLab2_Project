//MC_Project_TrafficLight.v

module MC_Project_TrafficLight(Clock, ResetN,
											LCD_E, LCD_RS, LCD_RW, LCD_DATA,	//Vehicle Traffic Light (차량용 신호등)
											PTL_A, PTL_B, PTL_C, SEG_COM, SEG_DATA, PIEZO, PIEZO_onOff, 	//Pedestrian Traffic Light (보행자 신호등)
											POS, POS_LED, 
											STsecUp, STsecDown, STminUp, STminDown, mode, select, orangeFlickering, redFlickering);
	input Clock, ResetN;
	input PIEZO_onOff;
	input POS;		//pedestrian operation signal, B 신호등에 부착됨, Button switch 2
	input STsecUp, STsecDown, STminUp, STminDown;		//count down 시작 시간 조정
	input mode, orangeFlickering, redFlickering;
	input [1:0] select;
	
	output [1:0] PTL_A, PTL_B, PTL_C;	//Pedestrian Traffic Light (보행자 신호등)
	output [3:0] SEG_COM;		//보행자 신호등 남은 시간
	output [7:0] SEG_DATA;		//보행자 신호등 남은 시간
	//output [6:0] SEG_DATA;
	output LCD_E;
	output LCD_RS, LCD_RW;
	output [7:0] LCD_DATA;
	output PIEZO;
	output POS_LED;	//pedestrian operation signal LED, B 신호등에 부착됨, Button swich 2 누르면 LED on
	
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
					
	reg [3:0] state;
	reg CLK_100Hz;
	reg [12:0] CNT_100Hz;	//[2:0]
	reg [17:0] CNT;
	
	wire [5:0] startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C;	//신호등 count down 시작 시간
	wire [17:0] startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C;				//신호등 count down 시작 시간 * 100
	wire POS_flag;
	
	always @(posedge Clock or negedge ResetN)
	begin
		if(!ResetN) begin
			CNT_100Hz <= 0;
			CLK_100Hz <= 0;
		end
		
		//clock prescalser
/*		else begin
			CNT_100Hz <= (CNT_100Hz >= 13'd4999) ? 13'd0 : CNT_100Hz + 1'b1;
			CLK_100Hz <= (CNT_100Hz >= 13'd4999) ? ~CLK_100Hz : CLK_100Hz;
		end*/
		else if(CNT_100Hz >= 13'd5000) begin	//3'd4
			CNT_100Hz <= 0;
			CLK_100Hz <= ~CLK_100Hz; // 100Hz clock
		end
		else
			CNT_100Hz <= CNT_100Hz + 1'b1;
	end
	
	always @(posedge CLK_100Hz or negedge ResetN) begin
		if(!ResetN)
			state <= DISP_ONOFF;
		else begin
			case(state)
				DELAY						: state <= (CNT >= 69) ? FUNCTION_SET : DELAY;
				FUNCTION_SET			: state <= (CNT >= 29) ? DISP_ONOFF : FUNCTION_SET;
				DISP_ONOFF				: state <= (CNT >= 29) ? ENTRY_MODE : DISP_ONOFF;
				ENTRY_MODE				: state <= (CNT >= 29) ? NUMBER_OUTPUT : ENTRY_MODE;
				NUMBER_OUTPUT			: state <= (CNT >= 9) ? A_STATE : NUMBER_OUTPUT;
				A_STATE					: begin
			/*		case({mode, orangeFlickering, redFlickering})
						//3'b000: state <= state <= (CNT >= startTimeMultiply100_A) ? B_STATE : A_STATE;	//CNT >= 499
						3'b100: state <= ADJUSTMENT;
						3'b010: state <= ALL_ORANGE;
						3'b001: state <= ALL_RED;
						default: state <= state <= (CNT >= startTimeMultiply100_A) ? B_STATE : A_STATE;	//CNT >= 499
					endcase*/
					if(mode == 1'b1)
						state <= EXTINGUISH_ALL_A;
					else if(orangeFlickering == 1'b1)
						state <= ALL_ORANGE;
					else if(redFlickering == 1'b1)
						state <= ALL_RED;
					else
						state <= (CNT >= startTimeMultiply100_A) ? B_STATE : A_STATE;	//CNT >= 499
				end
				B_STATE					: begin
			/*		case({mode, orangeFlickering, redFlickering})
						//3'b000: state <= (CNT >= startTimeMultiply100_B) ? (POS_flag == 1'b1 ? A_STATE : C_STATE) : B_STATE;
						3'b100: state <= ADJUSTMENT;
						3'b010: state <= ALL_ORANGE;
						3'b001: state <= ALL_RED;
						default: state <= (CNT >= startTimeMultiply100_B) ? (POS_flag == 1'b1 ? A_STATE : C_STATE) : B_STATE;
					endcase*/
					if(mode == 1'b1)
						state <= EXTINGUISH_ALL_A;
					else if(orangeFlickering == 1'b1)
						state <= ALL_ORANGE;
					else if(redFlickering == 1'b1)
						state <= ALL_RED;
					else
						state <= (CNT >= startTimeMultiply100_B) ? (POS_flag == 1'b1 ? A_STATE : C_STATE) : B_STATE;
				end
				C_STATE					: begin
			/*		case({mode, orangeFlickering, redFlickering})
						//3'b000: state <= (CNT >= startTimeMultiply100_C) ? (POS_LED == 1'b1 ? B_STATE : A_STATE) : C_STATE;	//보행자 작동 신호 있을 때, B로 아니면 A로
						3'b100: state <= ADJUSTMENT;
						3'b010: state <= ALL_ORANGE;
						3'b001: state <= ALL_RED;
						default: state <= (CNT >= startTimeMultiply100_C) ? (POS_LED == 1'b1 ? B_STATE : A_STATE) : C_STATE;	//보행자 작동 신호 있을 때, B로 아니면 A로
					endcase*/
					if(mode == 1'b1)
						state <= EXTINGUISH_ALL_A;
					else if(orangeFlickering == 1'b1)
						state <= ALL_ORANGE;
					else if(redFlickering == 1'b1)
						state <= ALL_RED;
					else
						state <= (CNT >= startTimeMultiply100_C) ? (POS_LED == 1'b1 ? B_STATE : A_STATE) : C_STATE;	//보행자 작동 신호 있을 때, B로 아니면 A로
				end
				ADJUSTMENT				: state <= (mode == 1'b0) ? DISP_ONOFF : ADJUSTMENT;
				ALL_ORANGE				: state <= (CNT == 98) ? EXTINGUISH_ALL_O : ((orangeFlickering == 1'b0) ? DISP_ONOFF : ALL_ORANGE);
				ALL_RED					: state <= (CNT == 98) ? EXTINGUISH_ALL_R : ((redFlickering == 1'b0) ? DISP_ONOFF : ALL_RED);
				EXTINGUISH_ALL_O		: state <= (CNT == 98) ? ALL_ORANGE : ((orangeFlickering == 1'b0) ? DISP_ONOFF : EXTINGUISH_ALL_O);
				EXTINGUISH_ALL_R		: state <= (CNT == 98) ? ALL_RED : ((redFlickering == 1'b0) ? DISP_ONOFF : EXTINGUISH_ALL_R);
				EXTINGUISH_ALL_A		: state <= (CNT == 20) ? ADJUSTMENT : EXTINGUISH_ALL_A;
				default					: state <= DISP_ONOFF;
			endcase
		end
	end
	
	always @(posedge CLK_100Hz or negedge ResetN) begin
		if(!ResetN)
			CNT <= 0;
		else begin
			case(state)
				DELAY						: CNT <= (CNT >= 69) ? 0 : CNT + 1'b1;
				FUNCTION_SET			: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				ENTRY_MODE				: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				DISP_ONOFF				: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				NUMBER_OUTPUT			: CNT <= (CNT >= 9) ? 0 : CNT + 1'b1;
				A_STATE					: CNT <= (CNT >= startTimeMultiply100_A) ? 0 : CNT + 1'b1;
				B_STATE					: CNT <= (CNT >= startTimeMultiply100_B) ? 0 : CNT + 1'b1;
				C_STATE					: CNT <= (CNT >= startTimeMultiply100_C) ? 0 : CNT + 1'b1;
				ADJUSTMENT				: CNT <= (CNT >= 5) ? 0 : CNT + 1'b1;
				ALL_ORANGE				: CNT <= (CNT >= 98) ? 0 : CNT + 1'b1;
				ALL_RED					: CNT <= (CNT >= 98) ? 0 : CNT + 1'b1;
				EXTINGUISH_ALL_O		: CNT <= (CNT >= 98) ? 0 : CNT + 1'b1;
				EXTINGUISH_ALL_R		: CNT <= (CNT >= 98) ? 0 : CNT + 1'b1;
				EXTINGUISH_ALL_A		: CNT <= (CNT >= 20) ? 0 : CNT + 1'b1;
				default					: CNT <= 0;
			endcase
		end
	end
	
	MC_AdjustInitialTime AIT(Clock, ResetN, startTimeSec_A, startTimeMin_A, startTimeSec_B, startTimeMin_B, 
										startTimeSec_C, startTimeMin_C, startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C, 
										STsecUp, STsecDown, STminUp, STminDown, select);
	MC_VehicleTrafficLight VTL(CLK_100Hz, Clock, ResetN, LCD_E, LCD_RS, LCD_RW, LCD_DATA, state, CNT, startTimeSec_A, startTimeMin_A, 
										startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C, startTimeMultiply100_A, startTimeMultiply100_B, startTimeMultiply100_C, select);
	MC_PedestrianTrafficLight PTL(Clock, CLK_100Hz, ResetN, state, CNT, startTimeSec_A, startTimeMin_A, 
											startTimeSec_B, startTimeMin_B, startTimeSec_C, startTimeMin_C, PTL_A, PTL_B, PTL_C, SEG_COM, SEG_DATA, PIEZO, PIEZO_onOff, POS, POS_LED, POS_flag);
	//MC_Clock(Clock, ResetN, sec);
	
endmodule
