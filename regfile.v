module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

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
	
//	mux32 read1(ctrl_readRegA, r0, r1, r2, r3, r4, r5, r6, r7,
//	r8, r9, r10, r11, r12, r13, r14, r15,
//	r16, r17, r18, r19, r20, r21, r22, r23,
//	r24, r25, r26, r27, r28, r29, r30, r31, data_readRegA);
//	
//	mux32 read2(ctrl_readRegB, r0, r1, r2, r3, r4, r5, r6, r7,
//	r8, r9, r10, r11, r12, r13, r14, r15,
//	r16, r17, r18, r19, r20, r21, r22, r23,
//	r24, r25, r26, r27, r28, r29, r30, r31, data_readRegB);
	
	decoder5to32 rDecodeA(ctrl_readRegA, 1'b1, readA);
	decoder5to32 rDecodeB(ctrl_readRegB, 1'b1, readB);
	
	assign data_readRegA = readA[0] ? r0 : 32'dz;
	assign data_readRegA = readA[1] ? r1 : 32'dz;
	assign data_readRegA = readA[2] ? r2 : 32'dz;
	assign data_readRegA = readA[3] ? r3 : 32'dz;
	assign data_readRegA = readA[4] ? r4 : 32'dz;
	assign data_readRegA = readA[5] ? r5 : 32'dz;
	assign data_readRegA = readA[6] ? r6 : 32'dz;
	assign data_readRegA = readA[7] ? r7 : 32'dz;
	assign data_readRegA = readA[8] ? r8 : 32'dz;
	assign data_readRegA = readA[9] ? r9 : 32'dz;
	assign data_readRegA = readA[10] ? r10 : 32'dz;
	assign data_readRegA = readA[11] ? r11 : 32'dz;
	assign data_readRegA = readA[12] ? r12 : 32'dz;
	assign data_readRegA = readA[13] ? r13 : 32'dz;
	assign data_readRegA = readA[14] ? r14 : 32'dz;
	assign data_readRegA = readA[15] ? r15 : 32'dz;
	assign data_readRegA = readA[16] ? r16 : 32'dz;
	assign data_readRegA = readA[17] ? r17 : 32'dz;
	assign data_readRegA = readA[18] ? r18 : 32'dz;
	assign data_readRegA = readA[19] ? r19 : 32'dz;
	assign data_readRegA = readA[20] ? r20 : 32'dz;
	assign data_readRegA = readA[21] ? r21 : 32'dz;
	assign data_readRegA = readA[22] ? r22 : 32'dz;
	assign data_readRegA = readA[23] ? r23 : 32'dz;
	assign data_readRegA = readA[24] ? r24 : 32'dz;
	assign data_readRegA = readA[25] ? r25 : 32'dz;
	assign data_readRegA = readA[26] ? r26 : 32'dz;
	assign data_readRegA = readA[27] ? r27 : 32'dz;
	assign data_readRegA = readA[28] ? r28 : 32'dz;
	assign data_readRegA = readA[29] ? r29 : 32'dz;
	assign data_readRegA = readA[30] ? r30 : 32'dz;
	assign data_readRegA = readA[31] ? r31 : 32'dz;
	
	assign data_readRegB = readB[0] ? r0 : 32'dz;
	assign data_readRegB = readB[1] ? r1 : 32'dz;
	assign data_readRegB = readB[2] ? r2 : 32'dz;
	assign data_readRegB = readB[3] ? r3 : 32'dz;
	assign data_readRegB = readB[4] ? r4 : 32'dz;
	assign data_readRegB = readB[5] ? r5 : 32'dz;
	assign data_readRegB = readB[6] ? r6 : 32'dz;
	assign data_readRegB = readB[7] ? r7 : 32'dz;
	assign data_readRegB = readB[8] ? r8 : 32'dz;
	assign data_readRegB = readB[9] ? r9 : 32'dz;
	assign data_readRegB = readB[10] ? r10 : 32'dz;
	assign data_readRegB = readB[11] ? r11 : 32'dz;
	assign data_readRegB = readB[12] ? r12 : 32'dz;
	assign data_readRegB = readB[13] ? r13 : 32'dz;
	assign data_readRegB = readB[14] ? r14 : 32'dz;
	assign data_readRegB = readB[15] ? r15 : 32'dz;
	assign data_readRegB = readB[16] ? r16 : 32'dz;
	assign data_readRegB = readB[17] ? r17 : 32'dz;
	assign data_readRegB = readB[18] ? r18 : 32'dz;
	assign data_readRegB = readB[19] ? r19 : 32'dz;
	assign data_readRegB = readB[20] ? r20 : 32'dz;
	assign data_readRegB = readB[21] ? r21 : 32'dz;
	assign data_readRegB = readB[22] ? r22 : 32'dz;
	assign data_readRegB = readB[23] ? r23 : 32'dz;
	assign data_readRegB = readB[24] ? r24 : 32'dz;
	assign data_readRegB = readB[25] ? r25 : 32'dz;
	assign data_readRegB = readB[26] ? r26 : 32'dz;
	assign data_readRegB = readB[27] ? r27 : 32'dz;
	assign data_readRegB = readB[28] ? r28 : 32'dz;
	assign data_readRegB = readB[29] ? r29 : 32'dz;
	assign data_readRegB = readB[30] ? r30 : 32'dz;
	assign data_readRegB = readB[31] ? r31 : 32'dz;

endmodule
