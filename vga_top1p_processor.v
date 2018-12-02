module vga_top1p_processor(curAddress,
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
	reg [18:0] titleOffset;
	reg [18:0] entry1Offset, entry2Offset, entry3Offset;	
	
	initial
	begin
		logoOffset <= 19'd0;
		titleOffset <= 19'd0;
		entry1Offset <= 19'd0;
		entry2Offset <= 19'd0;
		entry3Offset <= 19'd0;
	end
	
	always @(curY or curX)
	begin
		logoOffset = curX - 10'd35 + ((curY - 10'd160)*10'd640);
		titleOffset = (curY - 10'd114)*10'd21;
	end
	
	always
	begin
		// Logo
		if (curY >= 10'd160 && curY < 10'd316 && curX >= 10'd35 && curX < 10'd266)
			addrToRead <= logo + logoOffset;
		
		// Title
		else if (curY >= 10'd114 && curY < 10'd139 && curX >= 10'd302 && curX < 10'd596)
		begin
			// B
			if (curX >= 10'd302 && curX < 10'd323)
				addrToRead <= zero + (19'd525 * 19'd11) + (curX - 10'd302) + titleOffset;
			// E
			else if (curX >= 10'd323 && curX < 10'd344)
				addrToRead <= zero + (19'd525 * 19'd14) + (curX - 10'd323) + titleOffset;
			// S
			else if (curX >= 10'd344 && curX < 10'd365)
				addrToRead <= zero + (19'd525 * 19'd28) + (curX - 10'd344) + titleOffset;
			// T
			else if (curX >= 10'd365 && curX < 10'd386)
				addrToRead <= zero + (19'd525 * 19'd29) + (curX - 10'd365) + titleOffset;
		end
		
		else
			addrToRead <= 19'd1923;
	end
	
	always
	begin
		// Set up Border
		if (curY < 10'd3 || curY > 10'd476 || curX < 10'd3 || curX > 10'd636)
			indexOut <= 8'd7;
		else
			indexOut <= indexIn;
	end

endmodule
