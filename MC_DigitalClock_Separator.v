//MC_DigitalClock_Separator.v

module MC_DigitalClock_Separator(num, separate10, separate1);
	
	input [5:0] num;
	output reg [3:0] separate10, separate1;
	
	always @(num)
	begin
		if(num < 10)
		begin
			separate10 <= 4'd0;
			separate1 <= num;
		end
		else if(num < 20)
		begin
			separate10 <= 4'd1;
			separate1 <= num - 10;
		end
		else if(num < 30)
		begin
			separate10 <= 4'd2;
			separate1 <= num - 20;
		end
		else if(num < 40)
		begin
			separate10 <= 4'd3;
			separate1 <= num - 30;
		end
		else if(num < 50)
		begin
			separate10 <= 4'd4;
			separate1 <= num - 40;
		end
		else if(num < 60)
		begin
			separate10 <= 4'd5;
			separate1 <= num - 50;
		end
		else
		begin
			separate10 <= 4'd0;
			separate1 <= 4'd0;
		end
	end
	
endmodule
