module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB,
	 block1x, block1y,
	 block2x, block2y,
	 block3x, block3y,
	 block4x, block4y,
	 score,
	 blockType,
	 screenMode
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;
	output [31:0] block1x, block1y, block2x, block2y, block3x, block3y, block4x, block4y;
	output [31:0] score, blockType, screenMode;

   /* YOUR CODE HERE */
	// Writing wires
	wire [31:0] writeDecode, readA, readB;
	
	// Demux write destination
	decoder5to32 wDecode(ctrl_writeReg, ctrl_writeEnable, writeDecode);
	
	// 32 32 bit wires for each register :(
	wire [31:0] r0, r1, r2, r3, r4, r5, r6, r7,
	r8, r9, r10, r11, r12, r13, r14, r15,
	r16, r17, r18, r19, r20, r21, r22, r23,
	r24, r25, r26, r27, r28, r29, r30, r31;
	
	// 32 32 bit registers :(
	// $0 has hardcoded 0 for write enabled bit, can never write in $0
	reg32 reg0(clock, 1'b0, ctrl_reset, data_writeReg, r0);
	reg32 reg1(clock, writeDecode[1], ctrl_reset, data_writeReg, r1);
	reg32 reg2(clock, writeDecode[2], ctrl_reset, data_writeReg, r2);
	reg32 reg3(clock, writeDecode[3], ctrl_reset, data_writeReg, r3);
	reg32 reg4(clock, writeDecode[4], ctrl_reset, data_writeReg, r4);
	reg32 reg5(clock, writeDecode[5], ctrl_reset, data_writeReg, r5);
	reg32 reg6(clock, writeDecode[6], ctrl_reset, data_writeReg, r6);
	reg32 reg7(clock, writeDecode[7], ctrl_reset, data_writeReg, r7);
	reg32 reg8(clock, writeDecode[8], ctrl_reset, data_writeReg, r8);
	reg32 reg9(clock, writeDecode[9], ctrl_reset, data_writeReg, r9);
	reg32 reg10(clock, writeDecode[10], ctrl_reset, data_writeReg, r10);
	reg32 reg11(clock, writeDecode[11], ctrl_reset, data_writeReg, r11);
	reg32 reg12(clock, writeDecode[12], ctrl_reset, data_writeReg, r12);
	reg32 reg13(clock, writeDecode[13], ctrl_reset, data_writeReg, r13);
	reg32 reg14(clock, writeDecode[14], ctrl_reset, data_writeReg, r14);
	reg32 reg15(clock, writeDecode[15], ctrl_reset, data_writeReg, r15);
	reg32 reg16(clock, writeDecode[16], ctrl_reset, data_writeReg, r16);
	reg32 reg17(clock, writeDecode[17], ctrl_reset, data_writeReg, r17);
	reg32 reg18(clock, writeDecode[18], ctrl_reset, data_writeReg, r18);
	reg32 reg19(clock, writeDecode[19], ctrl_reset, data_writeReg, r19);
	reg32 reg20(clock, writeDecode[20], ctrl_reset, data_writeReg, r20);
	reg32 reg21(clock, writeDecode[21], ctrl_reset, data_writeReg, r21);
	reg32 reg22(clock, writeDecode[22], ctrl_reset, data_writeReg, r22);
	reg32 reg23(clock, writeDecode[23], ctrl_reset, data_writeReg, r23);
	reg32 reg24(clock, writeDecode[24], ctrl_reset, data_writeReg, r24);
	reg32 reg25(clock, writeDecode[25], ctrl_reset, data_writeReg, r25);
	reg32 reg26(clock, writeDecode[26], ctrl_reset, data_writeReg, r26);
	reg32 reg27(clock, writeDecode[27], ctrl_reset, data_writeReg, r27);
	reg32 reg28(clock, writeDecode[28], ctrl_reset, data_writeReg, r28);
	reg32 reg29(clock, writeDecode[29], ctrl_reset, data_writeReg, r29);
	reg32 reg30(clock, writeDecode[30], ctrl_reset, data_writeReg, r30);
	reg32 reg31(clock, writeDecode[31], ctrl_reset, data_writeReg, r31);
	
	decoder5to32 rDecodeA(ctrl_readRegA, 1'b1, readA);
	decoder5to32 rDecodeB(ctrl_readRegB, 1'b1, readB);
	
	wire[31:0] outDataA, outDataB;
	
	assign outDataA = readA[0] ? r0 : 32'dz;
	assign outDataA = readA[1] ? r1 : 32'dz;
	assign outDataA = readA[2] ? r2 : 32'dz;
	assign outDataA = readA[3] ? r3 : 32'dz;
	assign outDataA = readA[4] ? r4 : 32'dz;
	assign outDataA = readA[5] ? r5 : 32'dz;
	assign outDataA = readA[6] ? r6 : 32'dz;
	assign outDataA = readA[7] ? r7 : 32'dz;
	assign outDataA = readA[8] ? r8 : 32'dz;
	assign outDataA = readA[9] ? r9 : 32'dz;
	assign outDataA = readA[10] ? r10 : 32'dz;
	assign outDataA = readA[11] ? r11 : 32'dz;
	assign outDataA = readA[12] ? r12 : 32'dz;
	assign outDataA = readA[13] ? r13 : 32'dz;
	assign outDataA = readA[14] ? r14 : 32'dz;
	assign outDataA = readA[15] ? r15 : 32'dz;
	assign outDataA = readA[16] ? r16 : 32'dz;
	assign outDataA = readA[17] ? r17 : 32'dz;
	assign outDataA = readA[18] ? r18 : 32'dz;
	assign outDataA = readA[19] ? r19 : 32'dz;
	assign outDataA = readA[20] ? r20 : 32'dz;
	assign outDataA = readA[21] ? r21 : 32'dz;
	assign outDataA = readA[22] ? r22 : 32'dz;
	assign outDataA = readA[23] ? r23 : 32'dz;
	assign outDataA = readA[24] ? r24 : 32'dz;
	assign outDataA = readA[25] ? r25 : 32'dz;
	assign outDataA = readA[26] ? r26 : 32'dz;
	assign outDataA = readA[27] ? r27 : 32'dz;
	assign outDataA = readA[28] ? r28 : 32'dz;
	assign outDataA = readA[29] ? r29 : 32'dz;
	assign outDataA = readA[30] ? r30 : 32'dz;
	assign outDataA = readA[31] ? r31 : 32'dz;
	
	assign outDataB = readB[0] ? r0 : 32'dz;
	assign outDataB = readB[1] ? r1 : 32'dz;
	assign outDataB = readB[2] ? r2 : 32'dz;
	assign outDataB = readB[3] ? r3 : 32'dz;
	assign outDataB = readB[4] ? r4 : 32'dz;
	assign outDataB = readB[5] ? r5 : 32'dz;
	assign outDataB = readB[6] ? r6 : 32'dz;
	assign outDataB = readB[7] ? r7 : 32'dz;
	assign outDataB = readB[8] ? r8 : 32'dz;
	assign outDataB = readB[9] ? r9 : 32'dz;
	assign outDataB = readB[10] ? r10 : 32'dz;
	assign outDataB = readB[11] ? r11 : 32'dz;
	assign outDataB = readB[12] ? r12 : 32'dz;
	assign outDataB = readB[13] ? r13 : 32'dz;
	assign outDataB = readB[14] ? r14 : 32'dz;
	assign outDataB = readB[15] ? r15 : 32'dz;
	assign outDataB = readB[16] ? r16 : 32'dz;
	assign outDataB = readB[17] ? r17 : 32'dz;
	assign outDataB = readB[18] ? r18 : 32'dz;
	assign outDataB = readB[19] ? r19 : 32'dz;
	assign outDataB = readB[20] ? r20 : 32'dz;
	assign outDataB = readB[21] ? r21 : 32'dz;
	assign outDataB = readB[22] ? r22 : 32'dz;
	assign outDataB = readB[23] ? r23 : 32'dz;
	assign outDataB = readB[24] ? r24 : 32'dz;
	assign outDataB = readB[25] ? r25 : 32'dz;
	assign outDataB = readB[26] ? r26 : 32'dz;
	assign outDataB = readB[27] ? r27 : 32'dz;
	assign outDataB = readB[28] ? r28 : 32'dz;
	assign outDataB = readB[29] ? r29 : 32'dz;
	assign outDataB = readB[30] ? r30 : 32'dz;
	assign outDataB = readB[31] ? r31 : 32'dz;
	
	wire aBypass, bBypass, aMatch, bMatch;
	
	regEqual regEqualABypass(ctrl_readRegA, ctrl_writeReg, aMatch);
	regEqual regEqualBBypass(ctrl_readRegB, ctrl_writeReg, bMatch);
	
	and andABypass(aBypass, ctrl_writeEnable, aMatch);
	and andBBypass(bBypass, ctrl_writeEnable, bMatch);
	
	assign data_readRegA = aBypass ? data_writeReg : outDataA;
	assign data_readRegB = bBypass ? data_writeReg : outDataB;
	
	assign screenMode = r15;
	assign blockType = r20;
	assign score = r21;
	assign block1x = r22;
	assign block1y = r23;
	assign block2x = r24;
	assign block2y = r25;
	assign block3x = r26;
	assign block3y = r27;
	assign block4x = r28;
	assign block4y = r29;

endmodule
