module counter(start, clk, interrupt, out);

	input start, clk, interrupt;
	
	output out;
	
	wire [32:0] regIn, regOut;
	wire reset;
	
	or orReset(reset, start, interrupt);
	
	assign regIn[0] = start;
	
	genvar i;
	
	generate
		for(i = 1; i < 33; i = i+1) begin: loop1
			assign regIn[i] = reset ? 1'b0 : regOut[i-1];
		end
	endgenerate
	
	generate
		for(i = 0; i < 33; i = i+1) begin: loop2
			dffe_ref mydff(regOut[i], regIn[i], clk, 1'b1, 1'b0);
		end
	endgenerate
	
	gatedSlaveLatch outputLatch(clk, regOut[32], ~regOut[32], out);
	
endmodule
