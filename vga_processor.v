module vga_processor(curAddress,
							addrToRead,
							colorIn,
							colorOut,
							b1x,
							b1y,
							b2x,
							b2y,
							b3x,
							b3y,
							b4x,
							b4y,
							score,
							blockType
							);
	input [18:0] curAddress;
	input [23:0] colorIn;
	input [31:0] b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y;
	input [31:0] score, blockType;
	
	output [18:0] addrToRead;
	output [23:0] colorOut;
	reg [18:0] addrToRead;
	reg [23:0] colorOut;
	
	wire [9:0] curX, curY;
	addr_to_cart addrCoord(curAddress, curX, curY);
	
	wire [18:0] zero, one, two, three, four, five, six, seven, eight, nine;
	assign zero = 19'd307200;
	assign one = 19'd307725;
	assign two = 19'd308250;
	assign three = 19'd308775;
	assign four = 19'd309300;
	assign five = 19'd309825;
	assign six = 19'd310350;
	assign seven = 19'd310875;
	assign eight = 19'd311400;
	assign nine = 19'd311925;
	reg [13:0] thousands, hundreds, tens, ones;
	reg [18:0] offsetL0, offsetL1, offsetL2, offsetL3;
	
	initial
	begin
		thousands <= 14'd0;
		hundreds <= 14'd0;
		tens <= 14'd0;
		ones <= 14'd0;
		offsetL0 <= 19'd0;
		offsetL1 <= 19'd0;
		offsetL2 <= 19'd0;
		offsetL3 <= 19'd0;
	end
	
	always @(score)
	begin
		thousands <= (score[13:0] / 14'd1000) % 14'd10;
		hundreds <= (score[13:0] / 14'd100) % 14'd10;
		tens <= (score[13:0] / 14'd10) % 14'd10;
		ones <= score[13:0] % 14'd10;
	end
	
	always @(curY or curX)
	begin
		offsetL3 = curX - 10'd415 + ((curY - 10'd300)*10'd640);
		offsetL2 = curX - 10'd436 + ((curY - 10'd300)*10'd640);
		offsetL1 = curX - 10'd457 + ((curY - 10'd300)*10'd640);
		offsetL0 = curX - 10'd478 + ((curY - 10'd300)*10'd640);
	end
	
	always
	begin
		// Lines Left Area
		if (curY >= 10'd300 && curY < 10'd325)
		begin
			if(curX >= 10'd415 && curX < 10'd436)
			begin
				addrToRead <= thousands == 14'd0 ? zero + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd1 ? one + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd2 ? two + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd3 ? three + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd4 ? four + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd5 ? five + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd6 ? six + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd7 ? seven + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd8 ? eight + offsetL3: 19'dz;
				addrToRead <= thousands == 14'd9 ? nine + offsetL3: 19'dz;
			end
			else if(curX >= 10'd436 && curX < 10'd457)
			begin
				addrToRead <= hundreds == 14'd0 ? zero + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd1 ? one + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd2 ? two + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd3 ? three + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd4 ? four + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd5 ? five + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd6 ? six + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd7 ? seven + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd8 ? eight + offsetL2: 19'dz;
				addrToRead <= hundreds == 14'd9 ? nine + offsetL2: 19'dz;
			end
			else if(curX >= 10'd457 && curX < 10'd478)
			begin
				addrToRead <= tens == 14'd0 ? zero + offsetL1: 19'dz;
				addrToRead <= tens == 14'd1 ? one + offsetL1: 19'dz;
				addrToRead <= tens == 14'd2 ? two + offsetL1: 19'dz;
				addrToRead <= tens == 14'd3 ? three + offsetL1: 19'dz;
				addrToRead <= tens == 14'd4 ? four + offsetL1: 19'dz;
				addrToRead <= tens == 14'd5 ? five + offsetL1: 19'dz;
				addrToRead <= tens == 14'd6 ? six + offsetL1: 19'dz;
				addrToRead <= tens == 14'd7 ? seven + offsetL1: 19'dz;
				addrToRead <= tens == 14'd8 ? eight + offsetL1: 19'dz;
				addrToRead <= tens == 14'd9 ? nine + offsetL1: 19'dz;
			end
			else if(curX >= 10'd478 && curX < 10'd499)
			begin
				addrToRead <= ones == 14'd0 ? zero + offsetL0: 19'dz;
				addrToRead <= ones == 14'd1 ? one + offsetL0: 19'dz;
				addrToRead <= ones == 14'd2 ? two + offsetL0: 19'dz;
				addrToRead <= ones == 14'd3 ? three + offsetL0: 19'dz;
				addrToRead <= ones == 14'd4 ? four + offsetL0: 19'dz;
				addrToRead <= ones == 14'd5 ? five + offsetL0: 19'dz;
				addrToRead <= ones == 14'd6 ? six + offsetL0: 19'dz;
				addrToRead <= ones == 14'd7 ? seven + offsetL0: 19'dz;
				addrToRead <= ones == 14'd8 ? eight + offsetL0: 19'dz;
				addrToRead <= ones == 14'd9 ? nine + offsetL0: 19'dz;
			end
			else
				addrToRead <= curAddress;
		end
		// Time Area
		else if (curY >= 10'd415 && curY < 10'd440)
		begin
			addrToRead <= curAddress;
		end
		else
			addrToRead <= curAddress;
	end
	
	always
	begin
		if (curX >= b1x[9:0] && curX < b1x[9:0] + 10'd20 && curY >= b1y[9:0] && curY < b1y[9:0] + 10'd20)
			colorOut <= blockType[23:0];
		else if (curX >= b2x[9:0] && curX < b2x[9:0] + 10'd20 && curY >= b2y[9:0] && curY < b2y[9:0] + 10'd20)
			colorOut <= blockType[23:0];
		else if (curX >= b3x[9:0] && curX < b3x[9:0] + 10'd20 && curY >= b3y[9:0] && curY < b3y[9:0] + 10'd20)
			colorOut <= blockType[23:0];
		else if (curX >= b4x[9:0] && curX < b4x[9:0] + 10'd20 && curY >= b4y[9:0] && curY < b4y[9:0] + 10'd20)
			colorOut <= blockType[23:0];
		else
			colorOut <= colorIn;
	end

endmodule
