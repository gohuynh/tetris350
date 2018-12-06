module vga_processor(seconds,
							curAddress,
							addrToRead,
							indexIn,
							indexOut,
							b1x,
							b1y,
							b2x,
							b2y,
							b3x,
							b3y,
							b4x,
							b4y,
							score,
							blockType,
							metadata
							);
	input [15:0] seconds;
	input [18:0] curAddress;
	input [7:0] indexIn;
	input [31:0] b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y;
	input [31:0] score, blockType, metadata;
	
	output [18:0] addrToRead;
	output [7:0] indexOut;
	reg [18:0] addrToRead;
	reg [7:0] indexOut;
	
	wire [9:0] curX, curY;
	addr_to_cart addrCoord(curAddress, curX, curY);
	
	wire [18:0] zero, one, two, three, four, five, six, seven, eight, nine, label;
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
	assign label = 19'd326100;
	reg [13:0] thousands, hundreds, tens, ones;
	reg [18:0] offsetL0, offsetL1, offsetL2, offsetL3;
	reg [13:0] min1, min0, sec1, sec0;
	reg [18:0] offsetT0, offsetT1, offsetT2, offsetT3;
	reg [18:0] labelOffset;
	
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
		min1 <= 14'd0;
		min0 <= 14'd0;
		sec1 <= 14'd0;
		sec0 <= 14'd0;
		offsetT0 <= 19'd0;
		offsetT1 <= 19'd0;
		offsetT2 <= 19'd0;
		offsetT3 <= 19'd0;
		labelOffset <= 19'd0;
	end
	
	always @(score)
	begin
		thousands <= (score[13:0] / 14'd1000) % 14'd10;
		hundreds <= (score[13:0] / 14'd100) % 14'd10;
		tens <= (score[13:0] / 14'd10) % 14'd10;
		ones <= score[13:0] % 14'd10;
	end
	
	always @(seconds)
	begin
		sec0 <= (seconds[13:0] % 14'd60) % 14'd10;
		sec1 <= (seconds[13:0] % 14'd60) / 14'd10;
		min0 <= (seconds[13:0] / 14'd60) % 14'd10;
		min1 <= (seconds[13:0] / 14'd60) / 14'd10;
	end
	
	always @(curY or curX)
	begin
		offsetL3 = curX - 10'd415 + ((curY - 10'd300)*10'd21);
		offsetL2 = curX - 10'd436 + ((curY - 10'd300)*10'd21);
		offsetL1 = curX - 10'd457 + ((curY - 10'd300)*10'd21);
		offsetL0 = curX - 10'd478 + ((curY - 10'd300)*10'd21);
		
		offsetT3 = curX - 10'd410 + ((curY - 10'd415)*10'd21);
		offsetT2 = curX - 10'd431 + ((curY - 10'd415)*10'd21);
		offsetT1 = curX - 10'd463 + ((curY - 10'd415)*10'd21);
		offsetT0 = curX - 10'd484 + ((curY - 10'd415)*10'd21);
		
		labelOffset = curX - 10'd336 + ((curY - 10'd243)*10'd242);
	end
	
	always
	begin
		// Lines Left Area
		if (curY >= 10'd300 && curY < 10'd325)
		begin
			if(curX >= 10'd415 && curX < 10'd436)
			begin
				addrToRead <= thousands == 14'd0 ? zero + offsetL3 : 
								  thousands == 14'd1 ? one + offsetL3:
								  thousands == 14'd2 ? two + offsetL3:
								  thousands == 14'd3 ? three + offsetL3:
								  thousands == 14'd4 ? four + offsetL3:
								  thousands == 14'd5 ? five + offsetL3:
								  thousands == 14'd6 ? six + offsetL3:
								  thousands == 14'd7 ? seven + offsetL3:
								  thousands == 14'd8 ? eight + offsetL3:
								  thousands == 14'd9 ? nine + offsetL3: curAddress;
			end
			else if(curX >= 10'd436 && curX < 10'd457)
			begin
				addrToRead <= hundreds == 14'd0 ? zero + offsetL2:
								  hundreds == 14'd1 ? one + offsetL2:
								  hundreds == 14'd2 ? two + offsetL2: 
								  hundreds == 14'd3 ? three + offsetL2:
								  hundreds == 14'd4 ? four + offsetL2: 
								  hundreds == 14'd5 ? five + offsetL2: 
								  hundreds == 14'd6 ? six + offsetL2: 
								  hundreds == 14'd7 ? seven + offsetL2: 
								  hundreds == 14'd8 ? eight + offsetL2: 
								  hundreds == 14'd9 ? nine + offsetL2: curAddress;
			end
			else if(curX >= 10'd457 && curX < 10'd478)
			begin
				addrToRead <= tens == 14'd0 ? zero + offsetL1: 
								  tens == 14'd1 ? one + offsetL1: 
								  tens == 14'd2 ? two + offsetL1: 
								  tens == 14'd3 ? three + offsetL1:
								  tens == 14'd4 ? four + offsetL1: 
								  tens == 14'd5 ? five + offsetL1: 
								  tens == 14'd6 ? six + offsetL1: 
								  tens == 14'd7 ? seven + offsetL1: 
								  tens == 14'd8 ? eight + offsetL1: 
								  tens == 14'd9 ? nine + offsetL1: curAddress;
			end
			else if(curX >= 10'd478 && curX < 10'd499)
			begin
				addrToRead <= ones == 14'd0 ? zero + offsetL0: 
								  ones == 14'd1 ? one + offsetL0: 
								  ones == 14'd2 ? two + offsetL0: 
								  ones == 14'd3 ? three + offsetL0:
								  ones == 14'd4 ? four + offsetL0:
								  ones == 14'd5 ? five + offsetL0: 
								  ones == 14'd6 ? six + offsetL0: 
								  ones == 14'd7 ? seven + offsetL0: 
								  ones == 14'd8 ? eight + offsetL0:
								  ones == 14'd9 ? nine + offsetL0: curAddress;
			end
			else
				addrToRead <= curAddress;
		end
		// Time Area
		else if (curY >= 10'd415 && curY < 10'd440)
		begin
			if(curX >= 10'd410 && curX < 10'd431)
			begin
				addrToRead <= min1 == 14'd0 ? zero + offsetT3 : 
								  min1 == 14'd1 ? one + offsetT3:
								  min1 == 14'd2 ? two + offsetT3:
								  min1 == 14'd3 ? three + offsetT3:
								  min1 == 14'd4 ? four + offsetT3:
								  min1 == 14'd5 ? five + offsetT3:
								  min1 == 14'd6 ? six + offsetT3:
								  min1 == 14'd7 ? seven + offsetT3:
								  min1 == 14'd8 ? eight + offsetT3:
								  min1 == 14'd9 ? nine + offsetT3: curAddress;
			end
			else if(curX >= 10'd431 && curX < 10'd452)
			begin
				addrToRead <= min0 == 14'd0 ? zero + offsetT2:
								  min0 == 14'd1 ? one + offsetT2:
								  min0 == 14'd2 ? two + offsetT2: 
								  min0 == 14'd3 ? three + offsetT2:
								  min0 == 14'd4 ? four + offsetT2: 
								  min0 == 14'd5 ? five + offsetT2: 
								  min0 == 14'd6 ? six + offsetT2: 
								  min0 == 14'd7 ? seven + offsetT2: 
								  min0 == 14'd8 ? eight + offsetT2: 
								  min0 == 14'd9 ? nine + offsetT2: curAddress;
			end
			else if(curX >= 10'd463 && curX < 10'd484)
			begin
				addrToRead <= sec1 == 14'd0 ? zero + offsetT1: 
								  sec1 == 14'd1 ? one + offsetT1: 
								  sec1 == 14'd2 ? two + offsetT1: 
								  sec1 == 14'd3 ? three + offsetT1:
								  sec1 == 14'd4 ? four + offsetT1: 
								  sec1 == 14'd5 ? five + offsetT1: 
								  sec1 == 14'd6 ? six + offsetT1: 
								  sec1 == 14'd7 ? seven + offsetT1: 
								  sec1 == 14'd8 ? eight + offsetT1: 
								  sec1 == 14'd9 ? nine + offsetT1: curAddress;
			end
			else if(curX >= 10'd484 && curX < 10'd505)
			begin
				addrToRead <= sec0 == 14'd0 ? zero + offsetT0: 
								  sec0 == 14'd1 ? one + offsetT0: 
								  sec0 == 14'd2 ? two + offsetT0: 
								  sec0 == 14'd3 ? three + offsetT0:
								  sec0 == 14'd4 ? four + offsetT0:
								  sec0 == 14'd5 ? five + offsetT0: 
								  sec0 == 14'd6 ? six + offsetT0: 
								  sec0 == 14'd7 ? seven + offsetT0: 
								  sec0 == 14'd8 ? eight + offsetT0:
								  sec0 == 14'd9 ? nine + offsetT0: curAddress;
			end
			else
				addrToRead <= curAddress;
		end
		
		else if (curX >= 10'd336 && curX < 10'd578 && curY >= 10'd243 && curY < 10'd269 && metadata[0])
		begin
			addrToRead <= label + labelOffset;
		end
		
		else
			addrToRead <= curAddress;
	end
	
	
	always
	begin
		if (blockType[7:0] != 8'd0)
		begin
			if (curX >= b1x[9:0] && curX < b1x[9:0] + 10'd20 && curY >= b1y[9:0] && curY < b1y[9:0] + 10'd20)
				indexOut <= blockType[7:0];
			else if (curX >= b2x[9:0] && curX < b2x[9:0] + 10'd20 && curY >= b2y[9:0] && curY < b2y[9:0] + 10'd20)
				indexOut <= blockType[7:0];
			else if (curX >= b3x[9:0] && curX < b3x[9:0] + 10'd20 && curY >= b3y[9:0] && curY < b3y[9:0] + 10'd20)
				indexOut <= blockType[7:0];
			else if (curX >= b4x[9:0] && curX < b4x[9:0] + 10'd20 && curY >= b4y[9:0] && curY < b4y[9:0] + 10'd20)
				indexOut <= blockType[7:0];
			else
				indexOut <= indexIn;
		end
		else
			indexOut <= indexIn;
	end

endmodule
