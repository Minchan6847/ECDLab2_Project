//MC_MC_Project_TrafficLight.v

module MC_MC_Project_TrafficLight(Clock, ResetN,
											LCD_E, LCD_RS, LCD_RW, LCD_DATA,	//Vehicle Traffic Light (차량용 신호등)
											PTL_A, PTL_B, PTL_C, SEG_DATA, PIEZO,	//Pedestrian Traffic Light (보행자 신호등)
											POS, POS_LED);
	input Clock, ResetN;
	input POS;		//pedestrian operation signal, B 신호등에 부착됨, Button switch 2
	
	output [1:0] PTL_A, PTL_B, PTL_C;	//Pedestrian Traffic Light (보행자 신호등)
	output [6:0] SEG_DATA;	//보행자 신호등 남은 시간
	output LCD_E;
	output LCD_RS, LCD_RW;
	output [7:0] LCD_DATA;
	output PIEZO;
	output POS_LED;	//pedestrian operation signal LED, B 신호등에 부착됨, Button swich 2 누르면 LED on
	
	parameter 	DELAY				= 4'd0,
					FUNCTION_SET	= 4'd1,
					ENTRY_MODE		= 4'd2,
					DISP_ONOFF		= 4'd3,
					NUMBER_OUTPUT	= 4'd4,
					A_STATE			= 4'd5,
					B_STATE			= 4'd6,
					C_STATE			= 4'd7;
					
	reg [3:0] state;
	reg 		 CLK_100Hz;
	reg [12:0] CNT_100Hz;	//[2:0]
	reg [8:0] CNT;
	wire POS_flag;
	
	always @(posedge Clock or negedge ResetN)
	begin
		if(!ResetN) begin
			CNT_100Hz <= 0;
			CLK_100Hz <= 0;
		end
		
		//clock prescalser
		else if(CNT_100Hz >= 13'd5000) begin	//3'd4
			CNT_100Hz <= 0;
			CLK_100Hz <= ~CLK_100Hz; // 100Hz clock
		end
		else
			CNT_100Hz <= CNT_100Hz + 1'b1;
	end
	
	always @(posedge CLK_100Hz or negedge ResetN)
	begin
		if(!ResetN)
			state <= NUMBER_OUTPUT;
		else begin
			case(state)
				DELAY						: state <= (CNT >= 69) ? FUNCTION_SET : DELAY;
				FUNCTION_SET			: state <= (CNT >= 29) ? DISP_ONOFF : FUNCTION_SET;
				ENTRY_MODE				: state <= (CNT >= 29) ? ENTRY_MODE : DISP_ONOFF;
				DISP_ONOFF				: state <= (CNT >= 29) ? NUMBER_OUTPUT : ENTRY_MODE;
				NUMBER_OUTPUT			: state <= (CNT >= 9) ? A_STATE : NUMBER_OUTPUT;
				A_STATE					: state <= (CNT >= 499) ? B_STATE : A_STATE;
				B_STATE					: state <= (CNT >= 499) ? (POS_flag == 1'b1 ? A_STATE : C_STATE) : B_STATE;
				C_STATE					: state <= (CNT >= 499) ? (POS_LED == 1'b1 ? B_STATE : A_STATE) : C_STATE;	//보행자 작동 신호 있을 때, B로 아니면 A로
				default					: state <= DELAY;
			endcase
		end
	end
	
	always @(posedge CLK_100Hz or negedge ResetN)
	begin
		if(!ResetN)
			CNT <= 0;
		else begin
			case(state)
				DELAY						: CNT <= (CNT >= 69) ? 0 : CNT + 1'b1;
				FUNCTION_SET			: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				ENTRY_MODE				: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				DISP_ONOFF				: CNT <= (CNT >= 29) ? 0 : CNT + 1'b1;
				NUMBER_OUTPUT			: CNT <= (CNT >= 9) ? 0 : CNT + 1'b1;
				A_STATE					: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;	//5secons
				B_STATE					: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;	//5secons
				C_STATE					: CNT <= (CNT >= 499) ? 0 : CNT + 1'b1;	//5secons
				default					: CNT <= 0;
			endcase
		end
	end
	
	MC_VehicleTrafficLight M1(CLK_100Hz, ResetN, LCD_E, LCD_RS, LCD_RW, LCD_DATA, state, CNT);
	MC_PedestrianTrafficLight M2(Clock, CLK_100Hz, ResetN, state, CNT, PTL_A, PTL_B, PTL_C, SEG_DATA, PIEZO, POS, POS_LED, POS_flag);
	//MC_Clock(Clock, ResetN, sec);
	
endmodule
