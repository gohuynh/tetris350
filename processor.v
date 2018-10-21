/**
 * READ THIS DESCRIPTION!
 *
 * The processor takes in several inputs from a skeleton file.
 *
 * Inputs
 * clock: this is the clock for your processor at 50 MHz
 * reset: we should be able to assert a reset to start your pc from 0 (sync or
 * async is fine)
 *
 * Imem: input data from imem
 * Dmem: input data from dmem
 * Regfile: input data from regfile
 *
 * Outputs
 * Imem: output control signals to interface with imem
 * Dmem: output control signals and data to interface with dmem
 * Regfile: output control signals and data to interface with regfile
 *
 * Notes
 *
 * Ultimately, your processor will be tested by subsituting a master skeleton, imem, dmem, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file acts as a small wrapper around your processor for this purpose.
 *
 * You will need to figure out how to instantiate two memory elements, called
 * "syncram," in Quartus: one for imem and one for dmem. Each should take in a
 * 12-bit address and allow for storing a 32-bit value at each address. Each
 * should have a single clock.
 *
 * Each memory element should have a corresponding .mif file that initializes
 * the memory element to certain value on start up. These should be named
 * imem.mif and dmem.mif respectively.
 *
 * Importantly, these .mif files should be placed at the top level, i.e. there
 * should be an imem.mif and a dmem.mif at the same level as process.v. You
 * should figure out how to point your generated imem.v and dmem.v files at
 * these MIF files.
 *
 * imem
 * Inputs:  12-bit address, 1-bit clock enable, and a clock
 * Outputs: 32-bit instruction
 *
 * dmem
 * Inputs:  12-bit address, 1-bit clock, 32-bit data, 1-bit write enable
 * Outputs: 32-bit data at the given address
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB                   // I: Data from port B of regfile
);
    // Control signals
    input clock, reset;

    // Imem
    output [11:0] address_imem;
    input [31:0] q_imem;

    // Dmem
    output [11:0] address_dmem;
    output [31:0] data;
    output wren;
    input [31:0] q_dmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;

    /* YOUR CODE STARTS HERE */
	 
	 /*
	 -----------------------------------------------
	 F logic
	 -----------------------------------------------
	 */
	 wire [11:0] nextPC, curPC, seqNextPC, branchPC;
	 wire fCout, branchBool;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 pcLatch pc(clock, 1'b1, reset, nextPC, curPC);
	 
	 assign address_imem = curPC;
	 
	 claAdder pcAdder(curPC, 32'd12, 1'b0, seqNextPC, fCout);
	 
	 assign nextPC = branchBool ? branchPC : seqNextPC;
	 
	 /*
	 -----------------------------------------------
	 D logic
	 -----------------------------------------------
	 */
	 wire[4:0] dOpcode, rawRd, dRd, rawRs, rs, rawRt, rt, dShamt, dAluOp;
	 wire[16:0] dImm;
	 wire[26:0] dT;
	 wire[11:0] fdSeqNextPC;
	 wire readRd, rsToRd;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 fdLatch fd(clock, q_imem, seqNextPC, 1'b1, reset, 
					dOpcode, rawRd, rawRs, rt, dShamt, dAluOp, dImm, dT, fdSeqNextPC);
	 
	 // Decode
	 wire dR, dJ, dBne, dJal, dJr, dAddi, dBlt, dSw, dLw, dSetx, dBex;
	 opDecoder dOpDecoder(dOpcode, dR, dJ, dBne, dJal, dJr, dAddi, dBlt, dSw, dLw, dSetx, dBex);
	 
	 // Reassign register read sources and destination if needed
	 or rdOr(readRd, dSw, dBne, dJr, dBlt);
	 or rtOr(rsToRd, dBne, dBlt);
	 
	 assign dRd = dSw ? rawRs : (dSetx ? 5'd30 : (dJal ? 5'd31 : rawRd));
	 assign rs = readRd ? rawRd : (dBex ? 5'd30 : rawRs);
	 assign rt = rsToRd ? rawRs : rawRt;
	 
	 assign ctrl_readRegA = rs;
	 assign ctrl_readRegB = rt;
	 
	 /*
	 -----------------------------------------------
	 X logic
	 -----------------------------------------------
	 */
	 wire[11:0] dxSeqNextPC;
	 wire[4:0] xOpcode, xRd, xShamt, xAluOp, xImm, xT;
	 wire[31:0] operandA, operandB;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 dxLatch dx(clock, fdSeqNextPC, data_readRegA, data_readRegB, dOpcode, dRd, dShamt, dAluOp, dImm, dT, 1'b1, reset, 
					dxSeqNextPC, operandA, operandB, xOpcode, xRd, xShamt, xAluOp, xImm, xT);
	 
	 // Decode
	 wire xR, xJ, xBne, xJal, xJr, xAddi, xBlt, xSw, xLw, xSetx, xBex;
	 opDecoder xOpDecoder(xOpcode, xR, xJ, xBne, xJal, xJr, xAddi, xBlt, xSw, xLw, xSetx, xBex);
	 
	 // Sign extend for imm
	 wire[31:0] extendedImm;
	 
	 signExtender sxImm(xImm, extendedImm);
	 
	 /*
	 ======================
	 ALU stuff
	 ======================
	 */
	 
	 // Set up ALU
	 wire[31:0] aluInA, aluInB, aluOut;
	 wire[4:0] aluOp, shamt;
	 wire xINE, xILT, xOVF;
	 
	 alu mainAlu(aluInA, aluInB, aluOp, shamt, aluOut, xINE, xILT, xOVF);
	 
	 // Set up input A
	 assign aluInA = operandA;
	 
	 // Set up input B
	 wire useImm;
	 
	 or orUseImm(useImm, xAddi, xSw, xLw);
	 
	 assign aluInB = xBex ? 32'd0 : (useImm ? extendedImm : operandB);
	 
	 // Set up alu opcode
	 
	 assign aluOp = xR ? xAluOp : 5'd0;
	 
	 // Set up alu shamt
	 
	 assign shamt = xShamt;
	 
	 /*
	 ======================
	 Flow control
	 ======================
	 */
	 // Choose correct next PC
	 wire[31:0] xBranchPC;
	 wire xCout, xIType, xJIType;
	 
	 claAdder xAdder(dxSeqNextPC, extendedImm, 1'b0, xBranchPC, xCout);
	 
	 or orI(xIType, xBne, xBlt);
	 or orJI(xJIType, xJ, xJal, xBex);
	 
	 assign branchPC = xIType ? xBranchPC[11:0] : (xJIType ? xT[11:0] : operandA[11:0]);
	 
	 // Determine whether to jump or not
	 wire isBNE, isBLT;
	 
	 and andBNE(isBNE, xBne, xINE);
	 and andNLT(isBLT, xBlt, xILT);
	 
	 or orBranchBool(branchBool, isBNE, isBLT, xJ, xJal, xJr, xBex);
	 
	 /*
	 ======================
	 Set up for M
	 ======================
	 */
	 
	 wire[31:0] xO, extendedT;
	 wire xWReg;
	 
	 signExtenderJI sxT(extendedT, xT);
	 assign xO = xSetx ? extendedT : (xJal ? dxSeqNextPC : aluOut);
	 
	 or orXWReg(xWReg, xR, xAddi, xLw, xJal, xSetx);
	 
	 
	 /*
	 -----------------------------------------------
	 M logic
	 -----------------------------------------------
	 */
	 wire[31:0] mO, mMemQ;
	 wire[4:0] mRd;
	 wire mWReg, mLw;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 xmLatch xm(clock, xO, operandA, xSw, xWReg, xLw, xRd, 1'b1, reset, 
					mO, data, wren, mWReg, mLw, mRd);
	 
	 assign address_dmem = mO[11:0];
	 assign mMemQ = q_dmem;
	 
	 /*
	 -----------------------------------------------
	 W logic
	 -----------------------------------------------
	 */
	 wire[31:0] wO, wD;
	 wire wWReg, wRd, wLw;
	 
	 mwLatch mw(clock, mO, q_dmem, mWReg, mLw, mRd, 1'b1, reset,
				   wO, wD, wWReg, wLw, wRd);
					
	 wire[31:0] wRegData;
	 assign wRegData = mLw ? wD : wO;
	 
	 assign ctrl_writeEnable = wWReg;
	 assign ctrl_writeReg = wRd;
	 assign data_writeReg = wRegData;

endmodule
