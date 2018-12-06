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
	 
	 // Imem
    address_imgmem,                   // O: The address of the data to get or put from/to imgmem
    data_imgmem,                      // O: The data to write to imgmem
    wren_imgmem,                      // O: Write enable for imgmem
    q_imgmem,                         // I: The data from imgmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for regfile
    ctrl_writeReg,                  // O: Register to write to in regfile
    ctrl_readRegA,                  // O: Register to read from port A of regfile
    ctrl_readRegB,                  // O: Register to read from port B of regfile
    data_writeReg,                  // O: Data to write to for regfile
    data_readRegA,                  // I: Data from port A of regfile
    data_readRegB,                   // I: Data from port B of regfile
	 
	 // Controller Inputs
	 io_left,
	 io_right,
	 io_down,
	 io_rotate_cw,
	 
	 // In Game Timing
	 counter,
	 seconds,
	 
	 // Sound
	 sfx_play,
	 sfx_freq
	 
	
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
	 
	 // IMGmem
    output [18:0] address_imgmem;
    output [7:0] data_imgmem;
    output wren_imgmem;
    input [7:0] q_imgmem;

    // Regfile
    output ctrl_writeEnable;
    output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
    output [31:0] data_writeReg;
    input [31:0] data_readRegA, data_readRegB;
	 
	 // Controller Inputs
	 input io_left, io_right, io_down, io_rotate_cw;
	 
	 // In Game Timing
	 input [25:0] counter;
	 input [15:0] seconds;
	 
	 // Sound
	 output sfx_play;
	 output [31:0] sfx_freq;

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
	 wire fCout, branchBool, running, start;
	 
	 dffe_ref dffStart0(start, 1'b1, clock, 1'b1, reset);
	 
	 and andRunning(running, ~pcStall, start);
	 
	 // Changes every cycle for now i.e. no stalling yet
	 pcLatch pc(clock, running, reset, nextPC, curPC);
	 
	 assign address_imem = curPC;
	 
	 assign extendedCur[11:0] = curPC;
	 assign extendedCur[31:12] = 20'd0;
	 
	 claAdder pcAdder(extendedCur, 32'd1, 1'b0, seqNextPC, fCout);
	 
	 assign nextPC = branchBool ? branchPC : 12'dz;
	 assign nextPC = ~branchBool ? seqNextPC[11:0] : 12'dz;
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 D logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire[4:0] dOpcode, rawRd, dRd, rawRs, rs, rawRt, rt, dShamt, dAluOp, adRs, adRt;
	 wire[16:0] dImm;
	 wire[26:0] dT;
	 wire[11:0] fdSeqNextPC;
	 wire[31:0] instOut;
	 wire readRd, rsToRd, noRs, yesRt;
	 // Changes every cycle for now i.e. no stalling yet
	 fdLatch fd(clock, q_imem, seqNextPC[11:0], ~fdStall, fdReset, 
					dOpcode, rawRd, rawRs, rawRt, dShamt, dAluOp, dImm, dT, fdSeqNextPC, instOut);
	 
	 // Decode
	 wire dR, dJ, dBne, dJal, dJr, dAddi, dBlt, dSw, dLw, dIsw, dIlw, dRi, dRtick, dRsec, dSfx, dSetx, dBex;
	 opDecoder dOpDecoder(dOpcode, dR, dJ, dBne, dJal, dJr, dAddi, dBlt, dSw, dLw, dIsw, dIlw, dRi, dRtick, dRsec, dSfx, dSetx, dBex);
	 
	 // Reassign register read sources and destination if needed
	 or rdOr(readRd, dBne, dJr, dBlt, dSfx);
	 or rtOr(rsToRd, dBne, dBlt);
	 
	 wire useRawRd, useRawRs, useRawRt, dswisw;
	 
	 and andUserRawRd(useRawRd, ~dSetx, ~dJal);
	 and andUserRawRs(useRawRs, ~readRd, ~dBex);
	 and andUserRawRt(useRawRt, ~dSw, ~rsToRd, ~dIsw);
	 or orDswisw(dswisw, dSw, dIsw);
	 assign dRd = dSetx ? 5'd30 : 5'dz;
	 assign dRd = dJal ? 5'd31 : 5'dz;
	 assign dRd = useRawRd ? rawRd : 5'dz;
	 assign adRs = readRd ? rawRd : 5'dz;
	 assign adRs = dBex ? 5'd30 : 5'dz;
	 assign adRs = useRawRs ? rawRs : 5'dz;
	 assign adRt = dswisw ? rawRd : 5'dz;
	 assign adRt = rsToRd ? rawRs : 5'dz;
	 assign adRt = useRawRt ? rawRt : 5'dz;
	 
//	 assign dRd = dSetx ? 5'd30 : (dJal ? 5'd31 : rawRd);
//	 assign adRs = readRd ? rawRd : (dBex ? 5'd30 : rawRs);
//	 assign adRt = dSw ? rawRd : (rsToRd ? rawRs : rawRt);
	 
	 // Filter out unintended source registers
	 or orNoRs(noRs, dJ, dJal, dSetx, dRi, dRtick, dRsec);
	 or orNeedRt(yesRt, dR, rsToRd, dSw, dIsw);
	 assign rs = noRs ? 5'd0 : adRs;
	 assign rt = yesRt ? adRt : 5'd0;
	 
	 assign ctrl_readRegA = rs;
	 assign ctrl_readRegB = rt;
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 X logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire[11:0] dxSeqNextPC;
	 wire[4:0] xOpcode, xRd, xShamt, xAluOp, xRs, xRt, xRdOriginal;
	 wire[16:0] xImm;
	 wire[26:0] xT;
	 wire[31:0] operandA, operandB;
	 wire dxReset, dxStall;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 dxLatch dx(clock, fdSeqNextPC, data_readRegA, data_readRegB, dOpcode, dRd, dShamt, dAluOp, dImm, dT, rs, rt, ~dxStall, dxReset, 
					dxSeqNextPC, operandA, operandB, xOpcode, xRdOriginal, xShamt, xAluOp, xImm, xT, xRs, xRt);
	 
	 // Decode
	 wire xR, xJ, xBne, xJal, xJr, xAddi, xBlt, xSw, xLw, xIsw, xIlw, xRi, xRtick, xRsec, xSfx, xSetx, xBex;
	 opDecoder xOpDecoder(xOpcode, xR, xJ, xBne, xJal, xJr, xAddi, xBlt, xSw, xLw, xIsw, xIlw, xRi, xRtick, xRsec, xSfx, xSetx, xBex);
	 
	 // Sign extend for imm
	 wire[31:0] extendedImm;
	 
	 signExtender sxImm(xImm, extendedImm);
	 
	 /*
	 ======================
	 ALU stuff
	 ======================
	 */
	 
	 // Set up ALU
	 wire[31:0] aluInA, aluInB, aluOut, mBypass, wBypass, xD, aluOutOriginal;
	 wire[4:0] aluOp, shamt;
	 wire xINE, xILT, xOVF, mBypassABool, mBypassBBool, wBypassABool, wBypassBBool, noABypass, noBBypass, useBRegData;
	 
	 alu mainAlu(aluInA, aluInB, aluOp, shamt, aluOutOriginal, xINE, xILT, xOVF);
	 
	 // Set up input A
//	 assign aluInA = mBypassABool ? mBypass : (wBypassABool ? wBypass : operandA);
	 and andNoABypass(noABypass, ~mBypassABool, ~wBypassABool);
	 assign aluInA = mBypassABool ? mBypass : 32'dz;
	 assign aluInA = wBypassABool ? wBypass : 32'dz;
	 assign aluInA = noABypass ? operandA : 32'dz;
	 
	 // Set up input B
	 wire useImm;
	 
	 or orUseImm(useImm, xAddi, xSw, xLw, xIsw, xIlw);
	 
//	 assign xD = mBypassBBool ? mBypass : (wBypassBBool ? wBypass : operandB);
	 and andNoBBypass(noBBypass, ~mBypassBBool, ~wBypassBBool);
	 assign xD = mBypassBBool ? mBypass : 32'dz;
	 assign xD = wBypassBBool ? wBypass : 32'dz;
	 assign xD = noBBypass ? operandB : 32'dz;
	 
	 and andUseRegData(useBRegData, ~xBex, ~useImm);
	 assign aluInB = xBex ? 32'd0 : 32'dz;
	 assign aluInB = useImm ? extendedImm : 32'dz;
	 assign aluInB = useBRegData ? xD : 32'dz;
//	 assign aluInB = xBex ? 32'd0 : (useImm ? extendedImm : xD);
	 
	 
	 // Set up alu opcode
	 
	 assign aluOp = xR ? xAluOp : 5'd0;
	 
	 // Set up alu shamt
	 
	 assign shamt = xShamt;
	 
	 /*
	 ======================
	 Mult/Div stuff
	 ======================
	 */
	 wire xMult, xDiv, xMultOp, xDivOp, xMDOVF, xMDReady, xMulDiv, xMDException, mdStall, mdCalculating;
	 wire[31:0] xMDOut;
	 
	 assign xMultOp = aluOp === 5'b00110 ? 1'b1 : 1'b0;
	 assign xDivOp = aluOp === 5'b00111 ? 1'b1 : 1'b0;
	 
	 dffe_ref xMDCalculating(mdCalculating, mdStall, clock, 1'b1, reset);
	 
	 and andXMult(xMult, xMultOp, xR, ~mdCalculating);
	 and andXDiv(xDiv, xDivOp, xR, ~mdCalculating);
	 or orXMulDiv(xMulDiv, xMult, xDiv, mdCalculating);
	 
	 multdiv xMultDiv(aluInA, aluInB, xMult, xDiv, clock, xMDOut, xMDOVF, xMDReady);
	 
	 /*
	 ======================
	 Input stuff
	 ======================
	 */
	 wire[31:0] xInputRead;
	 assign xInputRead[0] = io_left;
	 assign xInputRead[1] = io_right;
	 assign xInputRead[2] = io_down;
	 assign xInputRead[3] = io_rotate_cw;
	 assign xInputRead[31:4] = 28'd0;
	 
	 /*
	 ======================
	 Check for exceptions
	 ======================
	 */
//	 errorControl xExceptions(xOVF, xR, xAluOp, xRdOriginal, aluOutOriginal, xRd, aluOut);
	 wire xAluOvf;
	 wire[31:0] xExceptionDataIn;
	 
	 and andXMDException(xMDException, xMDOVF, xMDReady);
	 assign xExceptionDataIn = xMulDiv ? xMDOut : aluOutOriginal;
	 or orXAlueOvf(xAluOvf, xOVF, xMDException);
	 errorControl xExceptions(xAluOvf, xR, xAluOp, xRdOriginal, xExceptionDataIn, xRd, aluOut);
	 
	 /*
	 ======================
	 Flow control
	 ======================
	 */
	 // Choose correct next PC
	 wire[31:0] extDXSeqNextPC, xBranchPC;
	 wire xCout, xIType, xJIType, regType;
	 
	 assign extDXSeqNextPC[11:0] = dxSeqNextPC;
	 assign extDXSeqNextPC[31:12] = 20'd0;
	 
	 claAdder xAdder(extDXSeqNextPC, extendedImm, 1'b0, xBranchPC, xCout);
	 
	 or orI(xIType, xBne, xBlt);
	 or orJI(xJIType, xJ, xJal, xBex);
	 
	 and andRegType(regType, ~xIType, ~xJIType);
	 assign branchPC = xIType ? xBranchPC[11:0] : 12'dz;
	 assign branchPC = xJIType ? xT[11:0] : 12'dz;
	 assign branchPC = regType ? operandA[11:0] : 12'dz;
	 
	 // Determine whether to jump or not
	 wire isBNE, isBLT, isBex, isOther;
	 
	 and andBNE(isBNE, xBne, xINE);
	 and andNLT(isBLT, xBlt, xILT);
	 and andBexNE(isBex, xBex, xINE);
	 or orIsOther(isOther, xJ, xJal, xJr);
	 
	 or orBranchBool(branchBool, isBNE, isBLT, isOther, isBex);
	 
	 /*
	 ======================
	 Set up for M
	 ======================
	 */
	 
	 wire[31:0] xO, extendedT;
	 wire xWReg;
	 wire xUseAlu;
	 
	 and andXUseAlu(xUseAlu, ~xSetx, ~xJal, ~xRi, ~xRtick, ~xRsec);	 
	 signExtenderJI sxT(xT, extendedT);
	 assign xO = xSetx ? extendedT : 32'dz;
	 assign xO = xJal ? dxSeqNextPC : 32'dz;
	 assign xO = xRi ? xInputRead : 32'dz;
	 assign xO = xRtick ? counter : 32'dz;
	 assign xO = xRsec ? seconds : 32'dz;
	 assign xO = xUseAlu ? aluOut : 32'dz;
	 
	 or orXWReg(xWReg, xR, xAddi, xLw, xJal, xRi, xRtick, xRsec, xSetx, xIlw);
	 
	 wire[4:0] x2mRd;
	 wire xSwIns;
	 
	 or orXSWIns(xSwIns, xSw, xIsw);
	 assign x2mRd = xSwIns ? 5'd0 : xRd;
	 
	 /*
	 ======================
	 Sound Stuff
	 ======================
	 */
	 
	 assign sfx_play = xSfx;
	 assign sfx_freq = xSfx ? aluInA : 32'd0;
	 
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 M logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire[31:0] mO, dmemData, imemData, mD;
	 wire[4:0] mRd, mRs;
	 wire mWReg, mSw, mIsw, mLw, mIlw, xmStall, xmReset;
	 
	 // Changes every cycle for now i.e. no stalling yet
	 xmLatch xm(clock, xO, xD, xSw, xIsw, xWReg, xLw, xIlw, x2mRd, xRs, ~xmStall, xmReset, 
					mO, mD, mSw, mIsw, mWReg, mLw, mIlw, mRd, mRs);
	 
	 assign address_dmem = mO[11:0];
	 assign address_imgmem = mO[18:0];
	 assign wren = mSw;
	 assign wren_imgmem = mIsw;
	 assign data = dmemData;
	 assign data_imgmem = imemData[7:0];
	 
	 wire[31:0] mRamOut;
	 wire[31:0] mQ_imgmemExt;
	 assign mQ_imgmemExt[7:0] = q_imgmem;
	 assign mQ_imgmemExt[31:8] = 16'd0;
	 assign mRamOut = mIlw ? mQ_imgmemExt : q_dmem;
	 
	 wire mLoadInst;
	 or orMLoadInst(mLoadInst, mLw, mIlw);
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 W logic
	 ----------------------------------------------------------------------------------------------
	 */
	 wire[31:0] wO, wD;
	 wire[4:0] wRd;
	 wire wWReg, wLw;
	 
	 mwLatch mw(clock, mO, mRamOut, mWReg, mLoadInst, mRd, 1'b1, reset,
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
	 
	 and andWBypassA(wBypassABool, xwRDRSMatch, wWReg, ~xwRDZero, ~mBypassABool);
	 and andWBypassB(wBypassBBool, xwRDRTMatch, wWReg, ~xwRDZero, ~mBypassBBool);
	 
	 assign wBypass = wRegData;
	 
	 /*
	 ======================
	 Bypasses for M
	 ======================
	 */
	 wire wmBypass, wmRDMatch, wmRDZero, wmStore;
	 
	 regEqual regEqualZero(wRd, 5'd0, wmRDZero);
	 regEqual regEqualWMRD(wRd, mRd, wmRDMatch);
	 or orWMStore(wmStore, mSw, mIsw);
	 and andWMBypass(wmBypass, wmRDMatch, wmStore, ~wmRDZero);
	 
	 assign dmemData = wmBypass ? wRegData : mD;
	 assign imemData = wmBypass ? wRegData : mD;
	 
	 /*
	 ----------------------------------------------------------------------------------------------
	 Stalling
	 ----------------------------------------------------------------------------------------------
	 */
	 
	 /*
	 ======================
	 Stalling for Mult/Div
	 ======================
	 */	 
	 and andMDStall(mdStall, xMulDiv, ~xMDReady);
	 assign xmStall = mdStall;
	 or orXmReset(xmReset, reset, mdStall);
	 /*
	 
	 ======================
	 Stalling for Loads
	 ======================
	 */
	 wire dxRsMatch, dxRtMatch, dxRsNotStore, dxRdMatch, dxRDZero, lwStall, nonZeroLW, stallLoad, stallStore;
	 
	 regEqual regEqualDXZero(xRd, 5'd0, dxRDZero);
	 regEqual regEqualDXRS(xRd, adRs, dxRsMatch);
	 regEqual regEqualDXRT(xRd, adRt, dxRtMatch);
	 
	 or orStallLoad(stallLoad, xLw, xIlw);
	 or orStallStore(stallStore, dSw, dIsw);
	 
	 and andNonZeroLW(nonZeroLW , stallLoad, ~dxRDZero);
	 and andDXRSNotStore(dxRsNotStore, dxRtMatch, ~stallStore);
	 or orDXRDMatch(dxRdMatch, dxRsMatch, dxRsNotStore);
	 and andLwStall(lwStall, dxRdMatch, nonZeroLW);
	 
	 or orFdStall(fdStall, branchBool, lwStall, mdStall);
	 or orPcStall(pcStall, lwStall, mdStall);
	 or orDxReset(dxReset, lwStall, reset, branchBool);
	 assign dxStall = mdStall;

endmodule
