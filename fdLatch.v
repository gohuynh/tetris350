module fdLatch(clock, inst, seqNextPcIn, inEnabled, reset, 
					opcode, rd, rs, rt, shamt, aluOp, imm, t, seqNextPcOut);
	input[31:0] inst;
	input[11:0] seqNextPcIn;
	input clock, inEnabled, reset;
	
	output[4:0] opcode, rd, rs, rt, shamt, aluOp;
	output[16:0] imm;
	output[26:0] t;
	output[11:0] seqNextPcOut;
	
	wire[31:0] curInst, instSave;
	
	assign instSave = inEnabled ? inst : curInst;
	
	// Latch data
	pcLatch pc(clock, inEnabled, reset, seqNextPcIn, seqNextPcOut);
	reg32 instReg(clock, 1'b1, reset, instSave, curInst);
	
	assign opcode = inEnabled ? inst[31:27] : curInst[31:27];
	assign rd = inEnabled ? inst[26:22] : curInst[26:22];
	assign rs = inEnabled ? inst[21:17] : curInst[21:17];
	assign rt = inEnabled ? inst[16:12] : curInst[16:12];
	assign shamt = inEnabled ? inst[11:7] : curInst[11:7];
	assign aluOp = inEnabled ? inst[6:2] : curInst[6:2];
	assign imm = inEnabled ? inst[16:0] : curInst[16:0];
	assign t = inEnabled ? inst[26:0] : curInst[26:0];


endmodule
