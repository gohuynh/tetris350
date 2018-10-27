module fdLatch(clock, instIn, seqNextPcIn, inEnabled, reset, 
					opcode, rd, rs, rt, shamt, aluOp, imm, t, seqNextPcOut);
	input[31:0] instIn;
	input[11:0] seqNextPcIn;
	input clock, inEnabled, reset;
	
	output[4:0] opcode, rd, rs, rt, shamt, aluOp;
	output[16:0] imm;
	output[26:0] t;
	output[11:0] seqNextPcOut;
	
	wire[31:0] outInst, curInst, inst;
	wire resetLatch, enableLatch, enable;
	
	assign inst = ~resetLatch ? instIn : 32'd0;
	and andEnable(enable, enableLatch, inEnabled);
	
	// Latch data
	pcLatch pc(clock, inEnabled, reset, seqNextPcIn, seqNextPcOut);
	reg32 instReg(clock, enable, reset, inst, outInst);
	
	// Reset register
	dffe_ref dffReset(resetLatch, reset, clock, 1'd1, 1'd0);
	dffe_ref dffEnable(enableLatch, inEnabled, ~clock, 1'd1, 1'd0);
	
	assign curInst = reset ? 32'd0 : outInst;
	
	assign opcode = enable ? inst[31:27] : curInst[31:27];
	assign rd = enable ? inst[26:22] : curInst[26:22];
	assign rs = enable ? inst[21:17] : curInst[21:17];
	assign rt = enable ? inst[16:12] : curInst[16:12];
	assign shamt = enable ? inst[11:7] : curInst[11:7];
	assign aluOp = enable ? inst[6:2] : curInst[6:2];
	assign imm = enable ? inst[16:0] : curInst[16:0];
	assign t = enable ? inst[26:0] : curInst[26:0];
	

endmodule
