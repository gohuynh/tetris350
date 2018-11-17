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
//	reg [23:0] colorOut;
	reg [23:0] test;
//	wire [31:0] b1x, b1y, b2x, b2y, b3x, b3y, b4x, b4y;
	
	wire [9:0] curX, curY;
	addr_to_cart addrCoord(address, curX, curY);
	
	assign colorOut = b1x == 32'd50 ? 24'h0000ff : 24'hff0000;
	
//	always
//	begin
//		if (curX >= b1x[9:0] && curX < b1x[9:0] + 10'd20 && curY >= b1y[9:0] && curY < b1y[9:0] + 10'd20)
////		if (curX >= 10'd50 && curX < 10'd50 + 10'd20 && curY >= 10'd50 && curY < 10'd50 + 10'd20)
////		if (b1x === 31'd0)
//			colorOut <= 24'h0000ff;
//		else
//			colorOut <= colorIn;
//	end

endmodule
