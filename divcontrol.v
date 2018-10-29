module divcontrol(start, clk, interrupt, done);

	input start, clk, interrupt;
	
	output done;
	
	counter counter32(start, clk, interrupt, done);

endmodule
