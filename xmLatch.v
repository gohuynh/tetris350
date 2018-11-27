module xmLatch(clock, oIn, dIn, wMemIn, wImemIn, wRegIn, lwIn, ilwIn, rdIn, rsIn, inEnabled, reset, 
					oOut, dOut, wMemOut, wImemOut, wRegOut, lwOut, ilwOut, rdOut, rsOut);
	
	input[31:0] oIn, dIn;
	input[4:0] rdIn, rsIn;
	input clock, wMemIn, wImemIn, wRegIn, lwIn, ilwIn, inEnabled, reset;
	
	output[31:0] oOut, dOut;
	output[4:0] rdOut, rsOut;
	output wMemOut, wImemOut, wRegOut, lwOut, ilwOut;
	
	// Latch Data
	reg32 o(clock, inEnabled, reset, oIn, oOut);
	reg32 d(clock, inEnabled, reset, dIn, dOut);
	reg5 rdReg(clock, inEnabled, reset, rdIn, rdOut);
	reg5 rsReg(clock, inEnabled, reset, rsIn, rsOut);
	dffe_ref wMem(wMemOut, wMemIn, clock, inEnabled, reset);
	dffe_ref wImem(wImemOut, wImemIn, clock, inEnabled, reset);
	dffe_ref wReg(wRegOut, wRegIn, clock, inEnabled, reset);
	dffe_ref lw(lwOut, lwIn, clock, inEnabled, reset);
	dffe_ref ilw(ilwOut, ilwIn, clock, inEnabled, reset);
	
endmodule
