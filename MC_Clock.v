//MC_Clock.v

module MC_Clock(Clock, ResetN, sec);
	
	input Clock, ResetN;
	output reg [3:0] sec;

	reg [9:0] cnt;

	always @(posedge Clock)
	begin
		if(!ResetN)
		begin
			cnt <= 10'd0;
			sec <= 4'd5;
		end
		else	//1ÃÊ¸¶´Ù Count up
		begin
			cnt <= (cnt == 10'd999) ? 10'd0 : cnt + 1'b1;
			sec <= (cnt == 10'd999) ? ((sec <= 4'd1) ? 4'd5 : sec - 1'd1) : sec;	//5~1
		end
	end

endmodule
