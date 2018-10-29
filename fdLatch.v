module fdLatch(clock, inst, seqNextPcIn, inEnabled, reset, 
					opcode, rd, rs, rt, shamt, aluOp, imm, t, seqNextPcOut, instOut);
	input[31:0] inst;
	input[11:0] seqNextPcIn;
	input clock, inEnabled, reset;
	
	output[4:0] opcode, rd, rs, rt, shamt, aluOp;
	output[16:0] imm;
	output[26:0] t;
	output[11:0] seqNextPcOut;
	output[31:0] instOut;
	
	wire[31:0] curInst;
	
	// Latch data
	pcLatch pc(clock, inEnabled, reset, seqNextPcIn, seqNextPcOut);
	reg32 instReg(clock, inEnabled, reset, inst, curInst);
	
	assign opcode = curInst[31:27];
	assign rd = curInst[26:22];
	assign rs = curInst[21:17];
	assign rt = curInst[16:12];
	assign shamt = curInst[11:7];
	assign aluOp = curInst[6:2];
	assign imm = curInst[16:0];
	assign t = curInst[26:0];
	
	assign instOut = inst;
	
endmodule
