module vga_topend_processor(curAddress,
									 addrToRead,
									 indexIn,
									 indexOut,
									 name1,
									 score1,
									 name2,
									 score2,
									 name3,
									 score3,
									 metadata
									 );

	input [18:0] curAddress;
	input [7:0] indexIn;
	input [31:0] name1, name2, name3;
	input [31:0] score1, score2, score3;
	input [28:0] metadata;
	
	output [18:0] addrToRead;
	output [7:0] indexOut;
	reg [18:0] addrToRead;
	reg [7:0] indexOut;
	
	// Decode names and scores
	wire [5:0] name1char2, name1char1, name1char0;
	wire [5:0] name2char2, name2char1, name2char0;
	wire [5:0] name3char2, name3char1, name3char0;
	wire [3:0] score1dig3, score1dig2, score1dig1, score1dig0;
	wire [3:0] score2dig3, score2dig2, score2dig1, score2dig0;
	wire [3:0] score3dig3, score3dig2, score3dig1, score3dig0;
	
	assign name1char2 = name1[17:12];
	assign name1char1 = name1[11:6];
	assign name1char0 = name1[5:0];
	assign name2char2 = name2[17:12];
	assign name2char1 = name2[11:6];
	assign name2char0 = name2[5:0];
	assign name3char2 = name3[17:12];
	assign name3char1 = name3[11:6];
	assign name3char0 = name3[5:0];
	
	assign score1dig3 = score1[15:12];
	assign score1dig2 = score1[11:8];
	assign score1dig1 = score1[7:4];
	assign score1dig0 = score1[3:0];
	assign score2dig3 = score2[15:12];
	assign score2dig2 = score2[11:8];
	assign score2dig1 = score2[7:4];
	assign score2dig0 = score2[3:0];
	assign score3dig3 = score3[15:12];
	assign score3dig2 = score3[11:8];
	assign score3dig1 = score3[7:4];
	assign score3dig0 = score3[3:0];
	
	// Stuff for visuals
	wire [9:0] curX, curY;
	addr_to_cart addrCoord(curAddress, curX, curY);
	wire [18:0] zero, logo;
	assign zero = 19'd307200;
	assign logo = 19'd25940;
	reg [18:0] logoOffset;
	reg [18:0] title1Offset, title2Offset;
	reg [18:0] entry1Offset, entry2Offset, entry3Offset;
	reg [18:0] colon1Offset, colon2Offset, colon3Offset;
	
	initial
	begin
		logoOffset <= 19'd0;
		title1Offset <= 19'd0;
		title2Offset <= 19'd0;
		entry1Offset <= 19'd0;
		entry2Offset <= 19'd0;
		entry3Offset <= 19'd0;
		colon1Offset <= 19'd0;
		colon2Offset <= 19'd0;
		colon3Offset <= 19'd0;
	end
	
	always @(curY or curX)
	begin
		logoOffset = curX - 10'd35 + ((curY - 10'd160)*10'd640);
		title1Offset = (curY - 10'd83)*10'd21;
		title2Offset = (curY - 10'd114)*10'd21;
		entry1Offset = (curY - 10'd186)*10'd21;
		colon1Offset = (curY - 10'd186)*10'd640;
		entry2Offset = (curY - 10'd251)*10'd21;
		colon2Offset = (curY - 10'd251)*10'd640;
		entry3Offset = (curY - 10'd316)*10'd21;
		colon3Offset = (curY - 10'd316)*10'd640;
	end
	
	always
	begin
		// Logo
		if (curY >= 10'd160 && curY < 10'd316 && curX >= 10'd35 && curX < 10'd266)
			addrToRead <= logo + logoOffset;
			
		// Title Line 1
		else if (curY >= 10'd83 && curY < 10'd108 && curX >= 10'd407 && curX < 10'd491)
		begin
			// B
			if (curX >= 10'd407 && curX < 10'd428)
				addrToRead <= zero + (19'd525 * 19'd11) + (curX - 10'd407) + title1Offset;
			// E
			else if (curX >= 10'd428 && curX < 10'd449)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd428) + title1Offset;
			// S
			else if (curX >= 10'd449 && curX < 10'd470)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd449) + title1Offset;
			// T
			else if (curX >= 10'd470 && curX < 10'd491)
				addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd470) + title1Offset;
				
			else
				addrToRead <= 19'd1923;
		end
		
		// Title Line 2
		else if (curY >= 10'd114 && curY < 10'd139 && curX >= 10'd302 && curX < 10'd596)
		begin
			// E
			if (curX >= 10'd302 && curX < 10'd323)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd302) + title2Offset;
			// N
			else if (curX >= 10'd323 && curX < 10'd344)
				addrToRead <= zero + (19'd525 * 19'd23) + (curX - 10'd323) + title2Offset;
			// D
			else if (curX >= 10'd344 && curX < 10'd365)
				addrToRead <= zero + (19'd525 * 19'd13) + (curX - 10'd344) + title2Offset;
			// L
			else if (curX >= 10'd365 && curX < 10'd386)
				addrToRead <= zero + (19'd525 * 19'd21) + (curX - 10'd365) + title2Offset;
			// E
			else if (curX >= 10'd386 && curX < 10'd407)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd386) + title2Offset;
			// S
			else if (curX >= 10'd407 && curX < 10'd428)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd407) + title2Offset;
			// S
			else if (curX >= 10'd428 && curX < 10'd449)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd428) + title2Offset;
//			// Space
//			else if (curX >= 10'd449 && curX < 10'd470)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd449) + title2Offset;
			// S
			else if (curX >= 10'd470 && curX < 10'd491)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd470) + title2Offset;
			// C
			else if (curX >= 10'd491 && curX < 10'd512)
				addrToRead <= zero + (19'd525 * 19'd12) + (curX - 10'd491) + title2Offset;
			// O
			else if (curX >= 10'd512 && curX < 10'd533)
				addrToRead <= zero + (19'd525 * 19'd24) + (curX - 10'd512) + title2Offset;
			// R
			else if (curX >= 10'd533 && curX < 10'd554)
				addrToRead <= zero + (19'd525 * 19'd27) + (curX - 10'd533) + title2Offset;
			// E
			else if (curX >= 10'd554 && curX < 10'd575)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd554) + title2Offset;
			// s
			else if (curX >= 10'd575 && curX < 10'd596)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd575) + title2Offset;
			
			else
				addrToRead <= 19'd1923;
		end
		
		// Entry 1
		else if (curY >= 10'd186 && curY < 10'd211 && curX >= 10'd302 && curX < 10'd596)
		begin
			// 1
			if (curX >= 10'd302 && curX < 10'd323)
				addrToRead <= zero + (19'd525 * 19'd1) + (curX - 10'd302) + entry1Offset;
//			// Space
//			else if (curX >= 10'd323 && curX < 10'd344)
//				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd323) + entry1Offset;
//			// Space
//			else if (curX >= 10'd344 && curX < 10'd365)
//				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd344) + entry1Offset;
			// name1char2
			else if (curX >= 10'd365 && curX < 10'd386)
				addrToRead <= zero + (19'd525 * name1char2) + (curX - 10'd365) + entry1Offset;
			// name1char1
			else if (curX >= 10'd386 && curX < 10'd407)
				addrToRead <= zero + (19'd525 * name1char1) + (curX - 10'd386) + entry1Offset;
			// name1char0
			else if (curX >= 10'd407 && curX < 10'd428)
				addrToRead <= zero + (19'd525 * name1char0) + (curX - 10'd407) + entry1Offset;
//			// Space
//			else if (curX >= 10'd428 && curX < 10'd449)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd428) + entry1Offset;
//			// Space
//			else if (curX >= 10'd449 && curX < 10'd470)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd449) + entry1Offset;
//			// Space
//			else if (curX >= 10'd470 && curX < 10'd491)
//				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd470) + entry1Offset;
//			// Space
//			else if (curX >= 10'd491 && curX < 10'd512)
//				addrToRead <= zero + (19'd525 * score1dig3) + (curX - 10'd491) + entry1Offset;
			// score1dig3
			else if (curX >= 10'd512 && curX < 10'd533)
				addrToRead <= zero + (19'd525 * score1dig3) + (curX - 10'd512) + entry1Offset;
			// score1dig2
			else if (curX >= 10'd533 && curX < 10'd554)
				addrToRead <= zero + (19'd525 * score1dig2) + (curX - 10'd533) + entry1Offset;
			// score1dig1
			else if (curX >= 10'd554 && curX < 10'd575)
				addrToRead <= zero + (19'd525 * score1dig1) + (curX - 10'd554) + entry1Offset;
			// score1dig0
			else if (curX >= 10'd575 && curX < 10'd596)
				addrToRead <= zero + (19'd525 * score1dig0) + (curX - 10'd575) + entry1Offset;
			
			else
				addrToRead <= 19'd1923;
		end
		
		// Entry 2
		else if (curY >= 10'd251 && curY < 10'd276 && curX >= 10'd302 && curX < 10'd596)
		begin
			// 2
			if (curX >= 10'd302 && curX < 10'd323)
				addrToRead <= zero + (19'd525 * 19'd2) + (curX - 10'd302) + entry2Offset;
//			// Space
//			else if (curX >= 10'd323 && curX < 10'd344)
//				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd323) + entry1Offset;
//			// Space
//			else if (curX >= 10'd344 && curX < 10'd365)
//				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd344) + entry1Offset;
			// name2char2
			else if (curX >= 10'd365 && curX < 10'd386)
				addrToRead <= zero + (19'd525 * name2char2) + (curX - 10'd365) + entry2Offset;
			// name2char1
			else if (curX >= 10'd386 && curX < 10'd407)
				addrToRead <= zero + (19'd525 * name2char1) + (curX - 10'd386) + entry2Offset;
			// name2char0
			else if (curX >= 10'd407 && curX < 10'd428)
				addrToRead <= zero + (19'd525 * name2char0) + (curX - 10'd407) + entry2Offset;
//			// Space
//			else if (curX >= 10'd428 && curX < 10'd449)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd428) + entry1Offset;
//			// Space
//			else if (curX >= 10'd449 && curX < 10'd470)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd449) + entry1Offset;
//			// Space
//			else if (curX >= 10'd470 && curX < 10'd491)
//				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd470) + entry1Offset;
//			// Space
//			else if (curX >= 10'd491 && curX < 10'd512)
//				addrToRead <= zero + (19'd525 * score2dig3) + (curX - 10'd491) + entry2Offset;
			// score2dig3
			else if (curX >= 10'd512 && curX < 10'd533)
				addrToRead <= zero + (19'd525 * score2dig3) + (curX - 10'd512) + entry2Offset;
			// score2dig2
			else if (curX >= 10'd533 && curX < 10'd554)
				addrToRead <= zero + (19'd525 * score2dig2) + (curX - 10'd533) + entry2Offset;
			// score2dig1
			else if (curX >= 10'd554 && curX < 10'd575)
				addrToRead <= zero + (19'd525 * score2dig1) + (curX - 10'd554) + entry2Offset;
			// score2dig0
			else if (curX >= 10'd575 && curX < 10'd596)
				addrToRead <= zero + (19'd525 * score2dig0) + (curX - 10'd575) + entry2Offset;
			
			else
				addrToRead <= 19'd1923;
		end
				
		// Entry 3
		else if (curY >= 10'd316 && curY < 10'd341 && curX >= 10'd302 && curX < 10'd596)
		begin
			// 3
			if (curX >= 10'd302 && curX < 10'd323)
				addrToRead <= zero + (19'd525 * 19'd3) + (curX - 10'd302) + entry3Offset;
//			// Space
//			else if (curX >= 10'd323 && curX < 10'd344)
//				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd323) + entry1Offset;
//			// Space
//			else if (curX >= 10'd344 && curX < 10'd365)
//				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd344) + entry1Offset;
			// name3char2
			else if (curX >= 10'd365 && curX < 10'd386)
				addrToRead <= zero + (19'd525 * name3char2) + (curX - 10'd365) + entry3Offset;
			// name3char1
			else if (curX >= 10'd386 && curX < 10'd407)
				addrToRead <= zero + (19'd525 * name3char1) + (curX - 10'd386) + entry3Offset;
			// name3char0
			else if (curX >= 10'd407 && curX < 10'd428)
				addrToRead <= zero + (19'd525 * name3char0) + (curX - 10'd407) + entry3Offset;
//			// Space
//			else if (curX >= 10'd428 && curX < 10'd449)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd428) + entry1Offset;
//			// Space
//			else if (curX >= 10'd449 && curX < 10'd470)
//				addrToRead <= zero + (19'd525 * 19'd25) + (curX - 10'd449) + entry1Offset;
//			// Space
//			else if (curX >= 10'd470 && curX < 10'd491)
//				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd470) + entry1Offset;
//			// Space
//			else if (curX >= 10'd491 && curX < 10'd512)
//				addrToRead <= zero + (19'd525 * score3dig3) + (curX - 10'd491) + entry3Offset;
			// score3dig3
			else if (curX >= 10'd512 && curX < 10'd533)
				addrToRead <= zero + (19'd525 * score3dig3) + (curX - 10'd512) + entry3Offset;
			// score3dig2
			else if (curX >= 10'd533 && curX < 10'd554)
				addrToRead <= zero + (19'd525 * score3dig2) + (curX - 10'd533) + entry3Offset;
			// score3dig1
			else if (curX >= 10'd554 && curX < 10'd575)
				addrToRead <= zero + (19'd525 * score3dig1) + (curX - 10'd554) + entry3Offset;
			// score3dig0
			else if (curX >= 10'd575 && curX < 10'd596)
				addrToRead <= zero + (19'd525 * score3dig0) + (curX - 10'd575) + entry3Offset;
			
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
		// Underline for title
		else if (curY >= 10'd139 && curY < 10'd142 && curX >= 10'd305 && curX < 10'd593)
			indexOut <= 8'd7;
		else
			indexOut <= indexIn;
	end

endmodule
