module xmLatch(clock, oIn, dIn, wMemIn, wRegIn, lwIn, rdIn, rsIn, inEnabled, reset, 
					oOut, dOut, wMemOut, wRegOut, lwOut, rdOut, rsOut);
	
	input[31:0] oIn, dIn;
	input[4:0] rdIn, rsIn;
	input clock, wMemIn, wRegIn, lwIn, inEnabled, reset;
	
	output[31:0] oOut, dOut;
	output[4:0] rdOut, rsOut;
	output wMemOut, wRegOut, lwOut;
	
	// Latch Data
	reg32 o(clock, inEnabled, reset, oIn, oOut);
	reg32 d(clock, inEnabled, reset, dIn, dOut);
	reg5 rdReg(clock, inEnabled, reset, rdIn, rdOut);
	reg5 rsReg(clock, inEnabled, reset, rsIn, rsOut);
	dffe_ref wMem(wMemOut, wMemIn, clock, inEnabled, reset);
	dffe_ref wReg(wRegOut, wRegIn, clock, inEnabled, reset);
	dffe_ref lw(lwOut, lwIn, clock, inEnabled, reset);
	
endmodule
