module mwLatch(clock, oIn, dIn, wRegIn, lwIn, rdIn, inEnabled, reset, 
					oOut, dOut, wRegOut, lwOut, rdOut);
	
	input[31:0] oIn, dIn;
	input[4:0] rdIn;
	input clock, wRegIn, lwIn, inEnabled, reset;
	
	output[31:0] oOut, dOut;
	output[4:0] rdOut;
	output wRegOut, lwOut;
	
	// Latch Data
	reg32 o(clock, inEnabled, reset, oIn, oOut);
	reg32 d(clock, inEnabled, reset, dIn, dOut);
//	assign dOut = dIn;
	reg5 rdReg(clock, inEnabled, reset, rdIn, rdOut);
	dffe_ref wReg(wRegOut, wRegIn, clock, inEnabled, reset);
	dffe_ref lw(lwOut, lwIn, clock, inEnabled, reset);
	
endmodule
