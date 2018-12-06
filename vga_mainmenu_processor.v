module vga_mainmenu_processor(curAddress,
										addrToRead,
										indexIn,
										indexOut,
										metadata
										);

	input [18:0] curAddress;
	input [7:0] indexIn;
	input [28:0] metadata;
	
	output [18:0] addrToRead;
	output [7:0] indexOut;
	reg [18:0] addrToRead;
	reg [7:0] indexOut;
	
	wire [9:0] curX, curY;
	addr_to_cart addrCoord(curAddress, curX, curY);
	wire [18:0] zero, logo;
	assign zero = 19'd307200;
	assign logo = 19'd25940;
	reg [18:0] logoOffset, op1Offset, op2Offset, op3Offset, op4Offset;
	reg [9:0] selX, selY;
	
	initial
	begin
		logoOffset <= 19'd0;
		op1Offset <= 19'd0;
		op2Offset <= 19'd0;
		op3Offset <= 19'd0;
		op4Offset <= 19'd0;
		selX <= 10'd0;
		selY <= 10'd0;
	end
	
	always @(curY or curX)
	begin
		logoOffset = curX - 10'd204 + ((curY - 10'd40)*10'd640);
		op1Offset = (curY - 10'd227)*10'd21;
		op2Offset = (curY - 10'd285)*10'd21;
		op3Offset = (curY - 10'd343)*10'd21;
		op4Offset = (curY - 10'd401)*10'd21;
	end
	
	always @(metadata)
	begin
		if (metadata[28:27] == 3'd0)
		begin
			selX = 10'd243;
			selY = 10'd224;
		end
		else if (metadata[28:27] == 3'd1)
		begin
			selX = 10'd243;
			selY = 10'd282;
		end
		else if (metadata[28:27] == 3'd2)
		begin
			selX = 10'd243;
			selY = 10'd340;
		end
		else
		begin
			selX = 10'd243;
			selY = 10'd398;
		end
	end
	
	always
	begin
	
		// Logo
		if (curX >= 10'd204 && curX < 10'd435 && curY >= 10'd40 && curY < 10'd196)
		begin
			addrToRead <= logo + logoOffset;
		end
		
		// Option One
		else if (curY >= 10'd227 && curY < 10'd252 && curX >= 10'd246 && curX < 10'd393)
		begin
			// C
			if (curX >= 10'd246 && curX < 10'd267)
				addrToRead <= zero + (19'd525 * 19'd12) + (curX - 10'd246) + op1Offset;
			// L
			else if (curX >= 10'd267 && curX < 10'd288)
				addrToRead <= zero + (19'd525 * 19'd21) + (curX - 10'd267) + op1Offset;
			// A
			else if (curX >= 10'd288 && curX < 10'd309)
				addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd288) + op1Offset;
			// S
			else if (curX >= 10'd309 && curX < 10'd330)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd309) + op1Offset;
			// S
			else if (curX >= 10'd330 && curX < 10'd351)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd330) + op1Offset;
			// I
			else if (curX >= 10'd351 && curX < 10'd372)
				addrToRead <= zero + (19'd525 * 19'd18) + (curX - 10'd351) + op1Offset;
			// C
			else if (curX >= 10'd372 && curX < 10'd393)
				addrToRead <= zero + (19'd525 * 19'd12) + (curX - 10'd372) + op1Offset;
			else
				addrToRead <= 19'd1923;
		end
		
		// Option Two
		else if (curY >= 10'd285 && curY < 10'd310 && curX >= 10'd246 && curX < 10'd393)
		begin
			// E
			if (curX >= 10'd246 && curX < 10'd267)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd246) + op2Offset;
			// N
			else if (curX >= 10'd267 && curX < 10'd288)
				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd267) + op2Offset;
			// D
			else if (curX >= 10'd288 && curX < 10'd309)
				addrToRead <= zero + (19'd525 * 19'd13) + (curX - 10'd288) + op2Offset;
			// L
			else if (curX >= 10'd309 && curX < 10'd330)
				addrToRead <= zero + (19'd525 * 19'd21) + (curX - 10'd309) + op2Offset;
			// E
			else if (curX >= 10'd330 && curX < 10'd351)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd330) + op2Offset;
			// S
			else if (curX >= 10'd351 && curX < 10'd372)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd351) + op2Offset;
			// S
			else if (curX >= 10'd372 && curX < 10'd393)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd372) + op2Offset;
			else
				addrToRead <= 19'd1923;
		end
		
		// Option Three
		else if (curY >= 10'd343 && curY < 10'd368 && curX >= 10'd246 && curX < 10'd393)
		begin
			// T
			if (curX >= 10'd246 && curX < 10'd267)
				addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd246) + op3Offset;
			// O
			else if (curX >= 10'd267 && curX < 10'd288)
				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd267) + op3Offset;
			// P
			else if (curX >= 10'd288 && curX < 10'd309)
				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd288) + op3Offset;
//			// Space
//			else if (curX >= 10'd309 && curX < 10'd330)
//				addrToRead <= 19'd1923;
			// C
			else if (curX >= 10'd330 && curX < 10'd351)
				addrToRead <= zero + (19'd525 * 19'd12) + (curX - 10'd330) + op3Offset;
			// L
			else if (curX >= 10'd351 && curX < 10'd372)
				addrToRead <= zero + (19'd525 * 19'd21) + (curX - 10'd351) + op3Offset;
			// A
			else if (curX >= 10'd372 && curX < 10'd393)
				addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd372) + op3Offset;
		
			else
				addrToRead <= 19'd1923;
		end
				
		// Option Four
		else if (curY >= 10'd401 && curY < 10'd426 && curX >= 10'd246 && curX < 10'd393)
		begin
			// T
			if (curX >= 10'd246 && curX < 10'd267)
				addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd246) + op4Offset;
			// O
			else if (curX >= 10'd267 && curX < 10'd288)
				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd267) + op4Offset;
			// P
			else if (curX >= 10'd288 && curX < 10'd309)
				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd288) + op4Offset;
//			// Space
//			else if (curX >= 10'd309 && curX < 10'd330)
//				addrToRead <= 19'd1923;
			// E
			else if (curX >= 10'd330 && curX < 10'd351)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd330) + op4Offset;
			// N
			else if (curX >= 10'd351 && curX < 10'd372)
				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd351) + op4Offset;
			// D
			else if (curX >= 10'd372 && curX < 10'd393)
				addrToRead <= zero + (19'd525 * 19'd13) + (curX - 10'd372) + op4Offset;
			else
				addrToRead <= 19'd1923;
		end
		
		// Currently selected option
		else if (curY >= selY && curY < selY + 10'd31 && curX >= selX + 10'd153 && curX < selX + 10'd177)
			addrToRead <= 19'd332392 + (curX - selX - 10'd153) + ((curY - selY)*10'd24);
		
		else
			addrToRead <= 19'd1923;
	end
	
	always
	begin
		// Set up Border
		if (curY < 10'd3 || curY > 10'd476 || curX < 10'd3 || curX > 10'd636)
			indexOut <= 8'd7;
		// Set up selected option
		// Left
		else if (curX >= selX && curX < selX + 10'd3 && curY >= selY && curY < selY + 10'd31)
			indexOut <= 8'd7;
		// Right
		else if (curX >= selX + 10'd150 && curX < selX + 10'd153 && curY >= selY && curY < selY + 10'd31)
			indexOut <= 8'd7;
		// Top
		else if (curX >= selX && curX < selX + 10'd153 && curY >= selY && curY < selY + 10'd3)
			indexOut <= 8'd7;
		// Bottom
		else if (curX >= selX && curX < selX + 10'd153 && curY >= selY + 10'd28 && curY < selY + 10'd31)
			indexOut <= 8'd7;
		else
		indexOut <= indexIn;
	end
	
	
endmodule
