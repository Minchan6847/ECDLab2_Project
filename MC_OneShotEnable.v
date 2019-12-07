//MC_OneShotEnable.v

module MC_OneShotEnable(Clock, in, OSE);
	input Clock, in;
	output OSE;
	
	reg in_1, in_2;
	
	always @(negedge Clock) begin
		in_1 <= in;
		in_2 <= in_1;
	end

	assign OSE = in_1 && ~in_2;
	
endmodule
