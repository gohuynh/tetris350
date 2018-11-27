module vga_mainmenu_processor(curAddress,
										addrToRead,
										indexIn,
										indexOut,
										colorIn,
										colorOut,
										score
										);

	input [18:0] curAddress;
	input [7:0] indexIn;
	input [23:0] colorIn;
	input [31:0] score;
	
	output [18:0] addrToRead;
	output [7:0] indexOut;
	output [23:0] colorOut;
	reg [18:0] addrToRead;
	reg [7:0] indexOut;
	reg [23:0] colorOut;
	
	wire [9:0] curX, curY;
	addr_to_cart addrCoord(curAddress, curX, curY);
	wire [18:0] zero, logo;
	assign zero = 19'd307200;
	assign logo = 19'd25940;
	reg [18:0] logoOffset, op1Offset;
	reg [13:0] thousands, hundreds, tens, ones;
	reg [18:0] offsetL1, offsetL2, offsetL3;
	reg [13:0] min1, min0, sec1, sec0;
	
	initial
	begin
		logoOffset <= 19'd0;
		op1Offset <= 19'd0;
		thousands <= 14'd0;
		hundreds <= 14'd0;
		tens <= 14'd0;
		ones <= 14'd0;
		offsetL2 <= 19'd0;
		offsetL3 <= 19'd0;
		min1 <= 14'd0;
		min0 <= 14'd0;
		sec1 <= 14'd0;
		sec0 <= 14'd0;
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
		sec0 <= (seconds % 16'd60) % 16'd10;
		sec1 <= (seconds % 16'd60) / 16'd10;
		min0 <= (seconds / 16'd60) % 16'd10;
		min1 <= (seconds / 16'd60) / 16'd10;
	end
	
	always @(curY or curX)
	begin
		logoOffset = curX - 10'd204 + ((curY - 10'd40)*10'd640);
		op1Offset = (curY - 10'd227)*10'd21;
	end
	
	always
	begin
		// Logo
		if (curX >= 10'd204 && curX < 10'd435 && curY >= 10'd40 && curY < 10'd121)
		begin
			addrToRead <= logo + logoOffset;
		end
		// Option One (Play 1P)
		else if (curY >= 10'd227 && curY < 10'd252)
		begin
			// P
			if (curX >= 10'd246 && curX < 10'd267)
			begin
				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd246) + op1Offset;
			end
			else
				addrToRead <= curAddress;
		end
		else
			addrToRead <= curAddress;
	end
	
	always
		indexOut <= indexIn;
	
	always
		colorOut <= colorIn;
	
endmodule
