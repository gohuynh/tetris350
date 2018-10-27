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
	 ----------------------------------------------------------------------------------------------
	 Wire stuff
	 ----------------------------------------------------------------------------------------------
	 */
	 
	 wire pcStall, fdStall;
	 wire fdReset;
	 
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 F logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire [31:0] extendedCur, seqNextPC;
	 wire [11:0] nextPC, curPC, branchPC;
	 wire fCout, branchBool;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 pcLatch pc(clock, ~pcStall, reset, nextPC, curPC);
	 
	 assign address_imem = curPC;
	 
	 assign extendedCur[11:0] = curPC;
	 assign extendedCur[31:12] = 20'd0;
	 
	 claAdder pcAdder(extendedCur, 32'd1, 1'b0, seqNextPC, fCout);
	 
	 assign nextPC = branchBool ? branchPC : seqNextPC[11:0];
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 D logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire[4:0] dOpcode, rawRd, dRd, rawRs, rs, rawRt, rt, dShamt, dAluOp, rsOut, rtOut;
	 wire[16:0] dImm;
	 wire[26:0] dT;
	 wire[11:0] fdSeqNextPC;
	 wire readRd, rsToRd, noRs;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 fdLatch fd(clock, q_imem, seqNextPC[11:0], ~fdStall, fdReset, 
					dOpcode, rawRd, rsOut, rtOut, dShamt, dAluOp, dImm, dT, fdSeqNextPC);
	 
	 // Decode
	 wire dR, dJ, dBne, dJal, dJr, dAddi, dBlt, dSw, dLw, dSetx, dBex;
	 opDecoder dOpDecoder(dOpcode, dR, dJ, dBne, dJal, dJr, dAddi, dBlt, dSw, dLw, dSetx, dBex);
	 
	 // Filter out unintended source registers
	 or orNoRs(noRs, dJ, dJal, dJr, dBex, dSetx);
	 assign rawRs = noRs ? 5'd0 : rsOut;
	 assign rawRt = dR ? rtOut : 5'd0;
	 
	 // Reassign register read sources and destination if needed
	 or rdOr(readRd, dBne, dJr, dBlt);
	 or rtOr(rsToRd, dBne, dBlt);
	 
	 assign dRd = dSetx ? 5'd30 : (dJal ? 5'd31 : rawRd);
	 assign rs = readRd ? rawRd : (dBex ? 5'd30 : rawRs);
	 assign rt = dSw ? rawRd : (rsToRd ? rawRs : rawRt);
	 
	 assign ctrl_readRegA = rs;
	 assign ctrl_readRegB = rt;
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 X logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire[11:0] dxSeqNextPC;
	 wire[4:0] xOpcode, xRd, xShamt, xAluOp, xRs, xRt;
	 wire[16:0] xImm;
	 wire[26:0] xT;
	 wire[31:0] operandA, operandB;
	 wire dxReset;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 dxLatch dx(clock, fdSeqNextPC, data_readRegA, data_readRegB, dOpcode, dRd, dShamt, dAluOp, dImm, dT, rs, rt, 1'd1, dxReset, 
					dxSeqNextPC, operandA, operandB, xOpcode, xRd, xShamt, xAluOp, xImm, xT, xRs, xRt);
	 
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
	 wire[31:0] aluInA, aluInB, aluOut, mBypass, wBypass, xD;
	 wire[4:0] aluOp, shamt;
	 wire xINE, xILT, xOVF, mBypassABool, mBypassBBool, wBypassABool, wBypassBBool;
	 
	 alu mainAlu(aluInA, aluInB, aluOp, shamt, aluOut, xINE, xILT, xOVF);
	 
	 // Set up input A
	 assign aluInA = mBypassABool ? mBypass : (wBypassABool ? wBypass : operandA);
	 
	 // Set up input B
	 wire useImm;
	 
	 or orUseImm(useImm, xAddi, xSw, xLw);
	 
	 assign xD = mBypassBBool ? mBypass : (wBypassBBool ? wBypass : operandB);
	 assign aluInB = xBex ? 32'd0 : (useImm ? extendedImm : xD);
	 
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
	 wire[31:0] extDXSeqNextPC, xBranchPC;
	 wire xCout, xIType, xJIType;
	 
	 assign extDXSeqNextPC[11:0] = dxSeqNextPC;
	 assign extDXSeqNextPC[31:12] = 20'd0;
	 
	 claAdder xAdder(extDXSeqNextPC, extendedImm, 1'b0, xBranchPC, xCout);
	 
	 or orI(xIType, xBne, xBlt);
	 or orJI(xJIType, xJ, xJal, xBex);
	 
	 assign branchPC = xIType ? xBranchPC[11:0] : (xJIType ? xT[11:0] : operandA[11:0]);
	 
	 // Determine whether to jump or not
	 wire isBNE, isBLT, isBex;
	 
	 and andBNE(isBNE, xBne, xINE);
	 and andNLT(isBLT, xBlt, xILT);
	 and andBexNE(isBex, xBex, xINE);
	 
	 or orBranchBool(branchBool, isBNE, isBLT, xJ, xJal, xJr, isBex);
	 
	 /*
	 ======================
	 Set up for M
	 ======================
	 */
	 
	 wire[31:0] xO, extendedT;
	 wire xWReg;
	 
	 signExtenderJI sxT(xT, extendedT);
	 assign xO = xSetx ? extendedT : (xJal ? dxSeqNextPC : aluOut);
	 
	 or orXWReg(xWReg, xR, xAddi, xLw, xJal, xSetx);
	 
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 M logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire[31:0] mO, mD, dmemData;
	 wire[4:0] mRd, mRs;
	 wire mWReg, mSw, mLw;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 xmLatch xm(clock, xO, xD, xSw, xWReg, xLw, xRd, xRs, 1'b1, reset, 
					mO, mD, mSw, mWReg, mLw, mRd, mRs);
	 
	 assign address_dmem = mO[11:0];
	 assign wren = mSw;
	 assign data = dmemData;
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 W logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire[31:0] wO, wD;
	 wire[4:0] wRd;
	 wire wWReg, wLw;
	 
	 mwLatch mw(clock, mO, q_dmem, mWReg, mLw, mRd, 1'b1, reset,
				   wO, wD, wWReg, wLw, wRd);
					
	 wire[31:0] wRegData;
	 assign wRegData = wLw ? wD : wO;
	 
	 assign ctrl_writeEnable = wWReg;
	 assign ctrl_writeReg = wRd;
	 assign data_writeReg = wRegData;
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 Flushing
	 ----------------------------------------------------------------------------------------------
	 */
	 or orFDReset(fdReset, reset, branchBool);
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 Bypasses
	 ----------------------------------------------------------------------------------------------
	 */
	 
	 /*
	 ======================
	 Bypasses for X
	 ======================
	 */
	 wire xmRDRSMatch, xmRDRTMatch, xmRDZero;
	 
	 regEqual regEqualXMZero(mRd, 5'd0, xmRDZero);
	 regEqual regEqualXMRS(xRs, mRd, xmRDRSMatch);
	 regEqual regEqualXMRT(xRt, mRd, xmRDRTMatch);
	 
	 and andMBypassA(mBypassABool, xmRDRSMatch, mWReg, ~xmRDZero);
	 and andMBypassB(mBypassBBool, xmRDRTMatch, mWReg, ~xmRDZero);
	 
	 assign mBypass = mO;
	 
	 wire xwRDRSMatch, xwRDRTMatch, xwRDZero;
	 
	 regEqual regEqualXWZero(wRd, 5'd0, xwRDZero);
	 regEqual regEqualXWRS(xRs, wRd, xwRDRSMatch);
	 regEqual regEqualXWRT(xRt, wRd, xwRDRTMatch);
	 
	 and andWBypassA(wBypassABool, xwRDRSMatch, wWReg, ~xwRDZero);
	 and andWBypassB(wBypassBBool, xwRDRTMatch, wWReg, ~xwRDZero);
	 
	 assign wBypass = wRegData;
	 
	 /*
	 ======================
	 Bypasses for M
	 ======================
	 */
	 wire wmBypass, wmRDMatch, wmRDZero;
	 
	 regEqual regEqualZero(wRd, 5'd0, wmRDZero);
	 regEqual regEqualWMRD(wRd, mRd, wmRDMatch);
	 and andWMBypass(wmBypass, wmRDMatch, mSw, ~wmRDZero);
	 
	 assign dmemData = wmBypass ? wRegData : mD;
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 Stalling
	 ----------------------------------------------------------------------------------------------
	 */
	 wire dxRsMatch, dxRtMatch, dxRsNotStore, dxRdMatch, dxRDZero, stall;
	 
	 regEqual regEqualDXZero(xRd, 5'd0, dxRDZero);
	 regEqual regEqualDXRS(xRd, rs, dxRsMatch);
	 regEqual regEqualDXRT(xRd, rt, dxRtMatch);
	 
	 and andDXRSNotStore(dxRsNotStore, dxRtMatch, ~dSw);
	 or orDXRDMatch(dxRdMatch, dxRsMatch, dxRsNotStore);
	 and andLwStall(lwStall, xLw, dxRdMatch, ~dxRDZero);
	 
	 dffe_ref regStall(stall, lwStall, clock, 1'd1, 1'd0);
	 
	 or orFdStall(fdStall, branchBool, stall);
	 assign pcStall = lwStall;
	 or orDxReset(dxReset, lwStall, reset, branchBool);

endmodule
