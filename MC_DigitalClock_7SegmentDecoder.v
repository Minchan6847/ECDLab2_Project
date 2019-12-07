//MC_DigitalClock_7SegmentDecoder.v

module MC_DigitalClock_7SegmentDecoder(BCD, dot, SEG_DATA);
	
	input[3:0] BCD;
	input dot;
	output reg[7:0] SEG_DATA;
	
	always @(*)
	begin
		case(BCD)
			4'd0: SEG_DATA = {7'b1111110, dot};	//0
			4'd1: SEG_DATA = {7'b0110000, dot};	//1
			4'd2: SEG_DATA = {7'b1101101, dot};	//2
			4'd3: SEG_DATA = {7'b1111001, dot};	//3
			4'd4: SEG_DATA = {7'b0110011, dot};	//4
			4'd5: SEG_DATA = {7'b1011011, dot};	//5
			4'd6: SEG_DATA = {7'b1011111, dot};	//6
			4'd7: SEG_DATA = {7'b1110000, dot};	//7
			4'd8: SEG_DATA = {7'b1111111, dot};	//8
			4'd9: SEG_DATA = {7'b1111011, dot};	//9
			default: SEG_DATA = {7'b0000000, dot};	//NULL
		endcase
	end
	
endmodule
