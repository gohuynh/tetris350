module addr_to_cart(addr, x, y);
	input [18:0] addr;
	output [9:0] x, y;
	
	wire [18:0] tx, ty;
	
	assign tx = addr % 19'd640;
	assign ty = addr / 19'd640;
	
	assign x = tx[9:0];
	assign y = ty[9:0];
endmodule
