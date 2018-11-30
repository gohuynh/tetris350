module vga_mainmenu_processor(curAddress,
										addrToRead,
										indexIn,
										indexOut,
										colorIn,
										colorOut,
										score,
										metadata
										);

	input [18:0] curAddress;
	input [7:0] indexIn;
	input [23:0] colorIn;
	input [31:0] score;
	input [28:0] metadata;
	
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
	reg [18:0] logoOffset, op1Offset, op2Offset, op3Offset;
	reg [9:0] selX, selY;
	
	initial
	begin
		logoOffset <= 19'd0;
		op1Offset <= 19'd0;
		op2Offset <= 19'd0;
		op3Offset <= 19'd0;
		selX <= 10'd0;
		selY <= 10'd0;
	end
	
	always @(curY or curX)
	begin
		logoOffset = curX - 10'd204 + ((curY - 10'd40)*10'd640);
		op1Offset = (curY - 10'd227)*10'd21;
		op2Offset = (curY - 10'd285)*10'd21;
		op3Offset = (curY - 10'd343)*10'd21;
	end
	
	always @(metadata)
	begin
		if (metadata[28:26] == 3'd0)
		begin
			selX = 10'd130;
			selY = 10'd224;
		end
		else if (metadata[28:26] == 3'd1)
		begin
			selX = 10'd130;
			selY = 10'd282;
		end
		else if (metadata[28:26] == 3'd2)
		begin
			selX = 10'd130;
			selY = 10'd340;
		end
		else if (metadata[28:26] == 3'd3)
		begin
			selX = 10'd357;
			selY = 10'd224;
		end
		else
		begin
			selX = 10'd357;
			selY = 10'd282;
		end
	end
	
	always
	begin
	
		// Logo
		if (curX >= 10'd204 && curX < 10'd435 && curY >= 10'd40 && curY < 10'd196)
		begin
			addrToRead <= logo + logoOffset;
		end
		
//		// Option One (Play 1P) and Option Four (Top 1P)
//		else if (curY >= 10'd227 && curY < 10'd252)
//		begin
//			// P
//			if (curX >= 10'd133 && curX < 10'd154)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd133) + op1Offset;
//			// L
//			else if (curX >= 10'd154 && curX < 10'd175)
//				addrToRead <= zero + (19'd525 * 19'd21) + (curX - 10'd154) + op1Offset;
//			// A
//			else if (curX >= 10'd175 && curX < 10'd196)
//				addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd175) + op1Offset;
//			// Y
//			else if (curX >= 10'd196 && curX < 10'd217)
//				addrToRead <= zero + (19'd525 * 19'd34) + (curX - 10'd196) + op1Offset;
//			// Space
//			else if (curX >= 10'd217 && curX < 10'd238)
//				addrToRead <= 19'd1923;
//			// 1
//			else if (curX >= 10'd238 && curX < 10'd259)
//				addrToRead <= zero + (19'd525 * 19'd1) + (curX - 10'd238) + op1Offset;
//			// P
//			else if (curX >= 10'd259 && curX < 10'd380)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd259) + op1Offset;
//			
//			
//			// T
//			else if (curX >= 10'd360 && curX < 10'd381)
//				addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd360) + op1Offset;
//			// O
//			else if (curX >= 10'd381 && curX < 10'd402)
//				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd381) + op1Offset;
//			// P
//			else if (curX >= 10'd402 && curX < 10'd423)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd402) + op1Offset;
//			// Space
//			else if (curX >= 10'd423 && curX < 10'd444)
//				addrToRead <= 19'd1923;
//			// 1
//			else if (curX >= 10'd444 && curX < 10'd465)
//				addrToRead <= zero + (19'd525 * 19'd1) + (curX - 10'd444) + op1Offset;
//			// P
//			else if (curX >= 10'd465 && curX < 10'd486)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd465) + op1Offset;
//			// Space
//			else if (curX >= 10'd486 && curX < 10'd507)
//				addrToRead <= 19'd1923;
//			else
//				addrToRead <= 19'd1923;
//		end
//		// Option Two (Endless) and Option Five (Top end)
//		else if (curY >= 10'd285 && curY < 10'd247)
//		begin
//			// E
//			if (curX >= 10'd133 && curX < 10'd154)
//				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd133) + op2Offset;
//			// N
//			else if (curX >= 10'd154 && curX < 10'd175)
//				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd154) + op2Offset;
//			// D
//			else if (curX >= 10'd175 && curX < 10'd196)
//				addrToRead <= zero + (19'd525 * 19'd13) + (curX - 10'd175) + op2Offset;
//			// L
//			else if (curX >= 10'd196 && curX < 10'd217)
//				addrToRead <= zero + (19'd525 * 19'd21) + (curX - 10'd196) + op2Offset;
//			// E
//			else if (curX >= 10'd217 && curX < 10'd238)
//				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd217) + op2Offset;
//			// S
//			else if (curX >= 10'd238 && curX < 10'd259)
//				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd238) + op2Offset;
//			// S
//			else if (curX >= 10'd259 && curX < 10'd380)
//				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd259) + op2Offset;
//			
//			
//			// T
//			else if (curX >= 10'd360 && curX < 10'd381)
//				addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd360) + op2Offset;
//			// O
//			else if (curX >= 10'd381 && curX < 10'd402)
//				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd381) + op2Offset;
//			// P
//			else if (curX >= 10'd402 && curX < 10'd423)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd402) + op2Offset;
//			// Space
//			else if (curX >= 10'd423 && curX < 10'd444)
//				addrToRead <= 19'd1923;
//			// E
//			else if (curX >= 10'd444 && curX < 10'd465)
//				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd444) + op2Offset;
//			// N
//			else if (curX >= 10'd465 && curX < 10'd486)
//				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd465) + op2Offset;
//			// D
//			else if (curX >= 10'd486 && curX < 10'd507)
//				addrToRead <= zero + (19'd525 * 19'd13) + (curX - 10'd486) + op2Offset;
//			else
//				addrToRead <= 19'd1923;
//		end
//		// Option Three (Play 2P)
//		else if (curY >= 10'd343 && curY < 10'd368)
//		begin
//			// P
//			if (curX >= 10'd133 && curX < 10'd154)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd133) + op3Offset;
//			// L
//			else if (curX >= 10'd154 && curX < 10'd175)
//				addrToRead <= zero + (19'd525 * 19'd21) + (curX - 10'd154) + op3Offset;
//			// A
//			else if (curX >= 10'd175 && curX < 10'd196)
//				addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd175) + op3Offset;
//			// Y
//			else if (curX >= 10'd196 && curX < 10'd217)
//				addrToRead <= zero + (19'd525 * 19'd34) + (curX - 10'd196) + op3Offset;
//			// Space
//			else if (curX >= 10'd217 && curX < 10'd238)
//				addrToRead <= 19'd1923;
//			// 1
//			else if (curX >= 10'd238 && curX < 10'd259)
//				addrToRead <= zero + (19'd525 * 19'd2) + (curX - 10'd238) + op3Offset;
//			// P
//			else if (curX >= 10'd259 && curX < 10'd380)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd259) + op3Offset;
//			else
//				addrToRead <= 19'd1923;
//		end
		else
			addrToRead <= 19'd1923;
	end
	
	always
		indexOut <= indexIn;
	
	always
		// Set up Border
		if (curY < 10'd3 || curY > 10'd476 || curX < 10'd3 || curX > 10'd636)
			colorOut <= 24'hffffff;
		// Set up selected option
		// Left
		else if (curX >= selX && curX < selX + 10'd3 && curY >= selY && curY < selY + 10'd31)
			colorOut <= 24'hffffff;
		// Right
		else if (curX >= selX + 10'd150 && curX < selX + 10'd153 && curY >= selY && curY < selY + 10'd31)
			colorOut <= 24'hffffff;
		// Top
		else if (curX >= selX && curX < selX + 10'd153 && curY >= selY && curY < selY + 10'd3)
			colorOut <= 24'hffffff;
		// Bottom
		else if (curX >= selX && curX < selX + 10'd153 && curY >= selY + 10'd28 && curY < selY + 10'd31)
			colorOut <= 24'hffffff;
		else
			colorOut <= colorIn;
	
endmodule
