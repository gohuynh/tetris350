module dxLatch(clock, seqNextPcIn, inA, inB, opcodeIn, rdIn, shamtIn, aluopIn, immIn, tIn, inEnabled, reset, 
					seqNextPcOut, operandA, operandB, opcodeOut, rdOut, shamtOut, aluopOut, immOut, tOut);
	
	input clock, inEnabled, reset;
	input[11:0] seqNextPcIn;
	input[31:0] inA, inB;
	input[4:0] opcodeIn, rdIn, shamtIn, aluopIn, immIn, tIn;
	
	output[11:0] seqNextPcOut;
	output[31:0] operandA, operandB;
	output[4:0] opcodeOut, rdOut, shamtOut, aluopOut, immOut, tOut;
	
	
	// Latch Data
	pcLatch pc(clock, inEnabled, reset, seqNextPcIn, seqNextPcOut);
	reg32 a(clock, inEnabled, reset, inA, operandA);
	reg32 b(clock, inEnabled, reset, inB, operandB);
	reg5 opcodeReg(clock, inEnabled, reset, opcodeIn, opcodeOut);
	reg5 rdReg(clock, inEnabled, reset, rdIn, rdOut);
	reg5 shamtReg(clock, inEnabled, reset, shamtIn, shamtOut);
	reg5 aluopReg(clock, inEnabled, reset, aluopIn, aluopOut);
	reg5 immReg(clock, inEnabled, reset, immIn, immOut);
	reg5 tReg(clock, inEnabled, reset, tIn, tOut);
	
	
endmodule
