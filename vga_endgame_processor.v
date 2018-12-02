module vga_endgame_processor(curAddress,
									  addrToRead,
									  indexIn,
									  indexOut,
									  score,
									  metadata
									  );


	input [18:0] curAddress;
	input [7:0] indexIn;
	input [31:0] score;
	input [28:0] metadata;
	
	output [18:0] addrToRead;
	output [7:0] indexOut;
	reg [18:0] addrToRead;
	reg [7:0] indexOut;
	
	// Decode Metadata
	wire [1:0] resultTitle;
	assign resultTitle = metadata[28:27];
	wire scoreType;
	assign scoreType = metadata[26];
	wire [2:0] optionSel;
	assign optionSel = metadata[25:23];
	wire [5:0] char2, char1, char0;
	assign char2 = metadata[17:12];
	assign char1 = metadata[11:6];
	assign char0 = metadata[5:0];
	
	// Decode Score
	wire [3:0] digit3, digit2, digit1, digit0;
	assign digit3 = score[15:12];
	assign digit2 = score[11:8];
	assign digit1 = score[7:4];
	assign digit0 = score[3:0];
	
	wire [9:0] curX, curY;
	addr_to_cart addrCoord(curAddress, curX, curY);
	wire [18:0] zero;
	assign zero = 19'd307200;
	reg [18:0] titleOffset;
	reg [18:0] scoreLabelOffset, scoreOffset, colonOffset;
	reg [18:0] screenOpOffset;
	reg [18:0] nameLabelOffset, nameOffset;
	reg [9:0] selX, selY, selW;
	
	
	initial
	begin
		titleOffset <= 19'd0;
		scoreLabelOffset <= 19'd0;
		scoreOffset <= 19'd0;
		colonOffset <= 19'd0;
		screenOpOffset <= 19'd0;
		nameLabelOffset <= 19'd0;
		nameOffset <= 19'd0;
		selX <= 10'd0;
		selY <= 10'd0;
		selW <= 10'd0;
	end
	
	always @(curY or curX)
	begin
		titleOffset 		= (curY - 10'd100)*10'd21;
		scoreLabelOffset 	= (curY - 10'd180)*10'd21;
		scoreOffset 		= (curY - 10'd230)*10'd21;
		colonOffset 		= (curY - 10'd230)*10'd640;
		screenOpOffset 	= (curY - 10'd325)*10'd21;
		nameLabelOffset	= (curY - 10'd300)*10'd21;
		nameOffset			= (curY - 10'd350)*10'd21;
	end
	
	always @(optionSel)
	begin
		if (optionSel == 3'd0)
		begin
			selX = 10'd100;
			selY = 10'd322;
			selW = 10'd192;
		end
		else if (optionSel == 3'd1)
		begin
			selX = 10'd345;
			selY = 10'd322;
			selW = 10'd192;
		end
		else if (optionSel == 3'd2)
		begin
			selX = 10'd222;
			selY = 10'd347;
			selW = 10'd24;
		end
		else if (optionSel == 3'd3)
		begin
			selX = 10'd264;
			selY = 10'd347;
			selW = 10'd24;
		end
		else if (optionSel == 3'd4)
		begin
			selX = 10'd306;
			selY = 10'd347;
			selW = 10'd24;
		end
		else
		begin
			selX = 10'd348;
			selY = 10'd347;
			selW = 10'd87;
		end
	end
	
	always
	begin
		
		// Title
		if (curY >= 10'd100 && curY < 10'd125 && curX >= 10'd225 && curX < 10'd414)
		begin
			// Game Over
			if (resultTitle == 2'd0)
			begin
				// G
				if (curX >= 10'd225 && curX < 10'd246)
					addrToRead <= zero + (19'd525 * 19'd16) + (curX - 10'd225) + titleOffset;
				// A
				else if (curX >= 10'd246 && curX < 10'd267)
					addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd246) + titleOffset;
				// M
				else if (curX >= 10'd267 && curX < 10'd288)
					addrToRead <= zero + (19'd525 * 19'd22) + (curX - 10'd267) + titleOffset;
				// E
				else if (curX >= 10'd288 && curX < 10'd309)
					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd288) + titleOffset;
//				// Space
//				else if (curX >= 10'd309 && curX < 10'd330)
//					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd309) + titleOffset;
				// O
				else if (curX >= 10'd330 && curX < 10'd351)
					addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd330) + titleOffset;
				// V
				else if (curX >= 10'd351 && curX < 10'd372)
					addrToRead <= zero + (19'd525 * 19'd31) + (curX - 10'd351) + titleOffset;
				// E
				else if (curX >= 10'd372 && curX < 10'd393)
					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd372) + titleOffset;
				// R
				else if (curX >= 10'd393 && curX < 10'd414)
					addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd393) + titleOffset;
				else
					addrToRead <= 19'd1923;					
			end
			
			// You Win
			else if (resultTitle == 2'd1)
			begin
//				// Space
//				if (curX >= 10'd225 && curX < 10'd246)
//					addrToRead <= zero + (19'd525 * 19'd16) + (curX - 10'd225) + titleOffset;
//				// Y
				if (curX >= 10'd246 && curX < 10'd267)
					addrToRead <= zero + (19'd525 * 19'd34) + (curX - 10'd246) + titleOffset;
				// O
				else if (curX >= 10'd267 && curX < 10'd288)
					addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd267) + titleOffset;
				// U
				else if (curX >= 10'd288 && curX < 10'd309)
					addrToRead <= zero + (19'd525 * 19'd30) + (curX - 10'd288) + titleOffset;
//				// Space
//				else if (curX >= 10'd309 && curX < 10'd330)
//					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd309) + titleOffset;
				// W
				else if (curX >= 10'd330 && curX < 10'd351)
					addrToRead <= zero + (19'd525 * 19'd32) + (curX - 10'd330) + titleOffset;
				// I
				else if (curX >= 10'd351 && curX < 10'd372)
					addrToRead <= zero + (19'd525 * 19'd18) + (curX - 10'd351) + titleOffset;
				// N
				else if (curX >= 10'd372 && curX < 10'd393)
					addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd372) + titleOffset;
//				// Space
//				else if (curX >= 10'd393 && curX < 10'd414)
//					addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd393) + titleOffset;
				else
					addrToRead <= 19'd1923;					
			end
			
			// Top Score
			else if (resultTitle == 2'd2)
			begin
				// T
				if (curX >= 10'd225 && curX < 10'd246)
					addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd225) + titleOffset;
				// O
				else if (curX >= 10'd246 && curX < 10'd267)
					addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd246) + titleOffset;
				// P
				else if (curX >= 10'd267 && curX < 10'd288)
					addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd267) + titleOffset;
//				// Space
//				else if (curX >= 10'd288 && curX < 10'd309)
//					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd288) + titleOffset;
				// S
				else if (curX >= 10'd309 && curX < 10'd330)
					addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd309) + titleOffset;
				// C
				else if (curX >= 10'd330 && curX < 10'd351)
					addrToRead <= zero + (19'd525 * 19'd12) + (curX - 10'd330) + titleOffset;
				// O
				else if (curX >= 10'd351 && curX < 10'd372)
					addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd351) + titleOffset;
				// R
				else if (curX >= 10'd372 && curX < 10'd393)
					addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd372) + titleOffset;
				// E
				else if (curX >= 10'd393 && curX < 10'd414)
					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd393) + titleOffset;
				else
					addrToRead <= 19'd1923;					
			end
			
			else
				addrToRead <= 19'd1923;
		end
		
		// Score Label
		else if (curY >= 10'd180 && curY < 10'd205 && curX >= 10'd204 && curX < 10'd435 && (resultTitle[0] || resultTitle[1]))
		begin
			// F
			if (curX >= 10'd204 && curX < 10'd225)
				addrToRead <= zero + (19'd525 * 19'd15) + (curX - 10'd204) + scoreLabelOffset;
			// I
			else if (curX >= 10'd225 && curX < 10'd246)
				addrToRead <= zero + (19'd525 * 19'd18) + (curX - 10'd225) + scoreLabelOffset;
			// N
			else if (curX >= 10'd246 && curX < 10'd267)
				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd246) + scoreLabelOffset;
			// A
			else if (curX >= 10'd267 && curX < 10'd288)
				addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd267) + scoreLabelOffset;
			// L
			else if (curX >= 10'd288 && curX < 10'd309)
				addrToRead <= zero + (19'd525 * 19'd21) + (curX - 10'd288) + scoreLabelOffset;
//			// Space
//			else if (curX >= 10'd309 && curX < 10'd330)
//				addrToRead <= zero + (19'd525 * 19'd18) + (curX - 10'd309) + scoreLabelOffset;
			// S
			else if (curX >= 10'd330 && curX < 10'd351)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd330) + scoreLabelOffset;
			// C
			else if (curX >= 10'd351 && curX < 10'd372)
				addrToRead <= zero + (19'd525 * 19'd12) + (curX - 10'd351) + scoreLabelOffset;
			// O
			else if (curX >= 10'd372 && curX < 10'd393)
				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd372) + scoreLabelOffset;
			// R
			else if (curX >= 10'd393 && curX < 10'd414)
				addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd393) + scoreLabelOffset;
			// E
			else if (curX >= 10'd414 && curX < 10'd435)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd414) + scoreLabelOffset;
			
			else
				addrToRead <= 19'd1923;
		end
		
		// Actual Score
		else if (curY >= 10'd230 && curY < 10'd255 && curX >= 10'd267 && curX < 10'd372 && (resultTitle[0] || resultTitle[1]))
		begin
			// Time Score
			if (scoreType == 1'd0)
			begin
				// digit3
				if (curX >= 10'd267 && curX < 10'd288)
					addrToRead <= zero + (19'd525 * digit3) + (curX - 10'd267) + scoreOffset;
				// digit2
				if (curX >= 10'd288 && curX < 10'd309)
					addrToRead <= zero + (19'd525 * digit2) + (curX - 10'd288) + scoreOffset;
				// colon
				if (curX >= 10'd314 && curX < 10'd325)
					addrToRead <= 19'd266052 + (curX - 10'd314) + colonOffset;
				// digit1
				if (curX >= 10'd330 && curX < 10'd351)
					addrToRead <= zero + (19'd525 * digit1) + (curX - 10'd330) + scoreOffset;
				// digit0
				if (curX >= 10'd351 && curX < 10'd372)
					addrToRead <= zero + (19'd525 * digit0) + (curX - 10'd351) + scoreOffset;
				else
					addrToRead <= 19'd1923;
			end
			
			// Line Score
			else if (scoreType == 1'd1)
			begin
				// 0
				if (curX >= 10'd267 && curX < 10'd288)
					addrToRead <= zero + (curX - 10'd267) + scoreOffset;
				// digit3
				if (curX >= 10'd288 && curX < 10'd309)
					addrToRead <= zero + (19'd525 * digit3) + (curX - 10'd288) + scoreOffset;
				// digit2
				if (curX >= 10'd309 && curX < 10'd330)
					addrToRead <= zero + (19'd525 * digit2) + (curX - 10'd288) + scoreOffset;
				// digit1
				if (curX >= 10'd330 && curX < 10'd351)
					addrToRead <= zero + (19'd525 * digit1) + (curX - 10'd330) + scoreOffset;
				// digit0
				if (curX >= 10'd351 && curX < 10'd372)
					addrToRead <= zero + (19'd525 * digit0) + (curX - 10'd351) + scoreOffset;
				else
					addrToRead <= 19'd1923;
			end
			
			else
				addrToRead <= 19'd1923;
		end
		
		// Screen Options
		else if (curY >= 10'd325 && curY < 10'd350 && curX >= 10'd103 && curX < 10'd537 && ~resultTitle[1])
		begin
			// Main Menu Option
			if (curX >= 10'd103 && curX < 10'd292)
			begin
				// M
				if (curX >= 10'd103 && curX < 10'd124)
					addrToRead <= zero + (19'd525 * 19'd22) + (curX - 10'd103) + screenOpOffset;
				// A
				else if (curX >= 10'd124 && curX < 10'd145)
					addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd124) + screenOpOffset;
				// I
				else if (curX >= 10'd145 && curX < 10'd166)
					addrToRead <= zero + (19'd525 * 19'd18) + (curX - 10'd145) + screenOpOffset;
				// N
				else if (curX >= 10'd166 && curX < 10'd187)
					addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd166) + screenOpOffset;
//				// Space
//				else if (curX >= 10'd187 && curX < 10'd208)
//					addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd187) + screenOpOffset;
				// M
				else if (curX >= 10'd208 && curX < 10'd229)
					addrToRead <= zero + (19'd525 * 19'd22) + (curX - 10'd208) + screenOpOffset;
				// E
				else if (curX >= 10'd229 && curX < 10'd250)
					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd229) + screenOpOffset;
				// N
				else if (curX >= 10'd250 && curX < 10'd271)
					addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd250) + screenOpOffset;
				// U
				else if (curX >= 10'd271 && curX < 10'd292)
					addrToRead <= zero + (19'd525 * 19'd30) + (curX - 10'd271) + screenOpOffset;
				
				else
					addrToRead <= 10'd1923;
			end
			
			// Restart Option
			else if (curX >= 10'd369 && curX < 10'd516)
			begin
				// R
				if (curX >= 10'd369 && curX < 10'd390)
					addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd369) + screenOpOffset;
				// E
				else if (curX >= 10'd390 && curX < 10'd411)
					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd390) + screenOpOffset;
				// S
				else if (curX >= 10'd411 && curX < 10'd432)
					addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd411) + screenOpOffset;
				// T
				else if (curX >= 10'd432 && curX < 10'd453)
					addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd432) + screenOpOffset;
				// A
				else if (curX >= 10'd453 && curX < 10'd474)
					addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd453) + screenOpOffset;
				// R
				else if (curX >= 10'd474 && curX < 10'd495)
					addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd474) + screenOpOffset;
				// T
				else if (curX >= 10'd495 && curX < 10'd516)
					addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd495) + screenOpOffset;
				
				else
					addrToRead <= 10'd1923;
			end
			
			else
				addrToRead <= 19'd1923;
			
		end
		
		// High Score Input Label
		else if (curY >= 10'd300 && curY < 10'd325 && curX >= 10'd225 && curX < 10'd414 && resultTitle[1])
		begin
			// Y
			if (curX >= 10'd225 && curX < 10'd246)
				addrToRead <= zero + (19'd525 * 19'd34) + (curX - 10'd225) + nameLabelOffset;
			// O
			else if (curX >= 10'd246 && curX < 10'd267)
				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd246) + nameLabelOffset;
			// U
			else if (curX >= 10'd267 && curX < 10'd288)
				addrToRead <= zero + (19'd525 * 19'd30) + (curX - 10'd267) + nameLabelOffset;
			// R
			else if (curX >= 10'd288 && curX < 10'd309)
				addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd288) + nameLabelOffset;
//				// Space
//				else if (curX >= 10'd309 && curX < 10'd330)
//					addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd309) + nameLabelOffset;
			// N
			else if (curX >= 10'd330 && curX < 10'd351)
				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd330) + nameLabelOffset;
			// A
			else if (curX >= 10'd351 && curX < 10'd372)
				addrToRead <= zero + (19'd525 * 19'd10) + (curX - 10'd351) + nameLabelOffset;
			// M
			else if (curX >= 10'd372 && curX < 10'd393)
				addrToRead <= zero + (19'd525 * 19'd22) + (curX - 10'd372) + nameLabelOffset;
			// E
			else if (curX >= 10'd393 && curX < 10'd414)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd393) + nameLabelOffset;
				
			else
				addrToRead <= 19'd1923;	
		end
		
		
		// High Score Input
		else if (curY >= 10'd350 && curY < 10'd375 && curX >= 10'd225 && curX < 10'd435 && resultTitle[1])
		begin
			// char2
			if (curX >= 10'd225 && curX < 10'd246)
				addrToRead <= zero + (19'd525 * char2) + (curX - 10'd225) + nameOffset;
//			// Space
//			else if (curX >= 10'd246 && curX < 10'd267)
//				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd246) + nameOffset;
			// char1
			else if (curX >= 10'd267 && curX < 10'd288)
				addrToRead <= zero + (19'd525 * char1) + (curX - 10'd267) + nameOffset;
//			// Space
//			else if (curX >= 10'd288 && curX < 10'd309)
//				addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd288) + nameOffset;
			// char0
			else if (curX >= 10'd309 && curX < 10'd330)
				addrToRead <= zero + (19'd525 * char0) + (curX - 10'd309) + nameOffset;
//			// Space
//			else if (curX >= 10'd330 && curX < 10'd351)
//				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd330) + nameOffset;
			// D
			else if (curX >= 10'd351 && curX < 10'd372)
				addrToRead <= zero + (19'd525 * 19'd13) + (curX - 10'd351) + nameOffset;
			// O
			else if (curX >= 10'd372 && curX < 10'd393)
				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd372) + nameOffset;
			// N
			else if (curX >= 10'd393 && curX < 10'd414)
				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd393) + nameOffset;
			// E
			else if (curX >= 10'd414 && curX < 10'd435)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd414) + nameOffset;
				
			else
				addrToRead <= 19'd1923;	
		end
		
		
		
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
		else if (curX >= selX + selW && curX < selX + selW + 10'd3 && curY >= selY && curY < selY + 10'd31)
			indexOut <= 8'd7;
		// Top
		else if (curX >= selX && curX < selX + selW + 10'd3 && curY >= selY && curY < selY + 10'd3)
			indexOut <= 8'd7;
		// Bottom
		else if (curX >= selX && curX < selX + selW + 10'd3 && curY >= selY + 10'd28 && curY < selY + 10'd31)
			indexOut <= 8'd7;
		else
		indexOut <= indexIn;
	end
endmodule