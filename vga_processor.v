module vga_processor(address, colorIn, 
							b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y,
							score, blockType,
							colorOut
							);
	input [18:0] address;
	input [23:0] colorIn;
	input [31:0] b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y;
	input [31:0] score, blockType;
	
	output [23:0] colorOut;
	reg [23:0] colorOut;
	reg [23:0] test;
//	wire [31:0] b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y;
	
	wire [9:0] curX, curY;
	addr_to_cart addrCoord(address, curX, curY);
	
//	assign colorOut = b1x == 32'd50 ? 24'h0000ff : 24'hff0000;
	
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
