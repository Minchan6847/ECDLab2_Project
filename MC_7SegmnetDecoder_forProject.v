//MC_7SegmnetDecoder_forProject.v

module MC_7SegmnetDecoder_forProject(BCD, SEG_DATA);
	
	input[3:0] BCD;
	//output reg a, b, c, d, e, f, g;
	output reg[6:0] SEG_DATA;
	
	always @(BCD)
	begin
		case(BCD)
			4'b0000: SEG_DATA = 7'b1111110;	//0
			4'b0001: SEG_DATA = 7'b0110000;	//1
			4'b0010: SEG_DATA = 7'b1101101;	//2
			4'b0011: SEG_DATA = 7'b1111001;	//3
			4'b0100: SEG_DATA = 7'b0110011;	//4
			4'b0101: SEG_DATA = 7'b1011011;	//5
			4'b0110: SEG_DATA = 7'b1011111;	//6
			4'b0111: SEG_DATA = 7'b1110000;	//7
			4'b1000: SEG_DATA = 7'b1111111;	//8
			4'b1001: SEG_DATA = 7'b1111011;	//9
			default: SEG_DATA = 7'b0000000;	//NULL
		endcase
	end
	
endmodule
