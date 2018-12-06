module opDecoder(in, r, j, bne, jal, jr, addi, blt, sw, lw, isw, ilw, ri, rtick, rsec, sfx, setx, bex);
	input[4:0] in;
	
	output r, j, bne, jal, jr, addi, blt, sw, lw, isw, ilw, ri, rtick, rsec, sfx, setx, bex;
	
	and and0(r, ~in[4], ~in[3], ~in[2], ~in[1], ~in[0]); 		// 00000	r
	and and1(j, ~in[4], ~in[3], ~in[2], ~in[1], in[0]); 		// 00001	j
	and and2(bne, ~in[4], ~in[3], ~in[2], in[1], ~in[0]);		// 00010	bne
	and and3(jal, ~in[4], ~in[3], ~in[2], in[1], in[0]);		// 00011	jal
	and and4(jr, ~in[4], ~in[3], in[2], ~in[1], ~in[0]);		// 00100	jr
	and and5(addi, ~in[4], ~in[3], in[2], ~in[1], in[0]);		// 00101	addi
	and and6(blt, ~in[4], ~in[3], in[2], in[1], ~in[0]);		// 00110	blt
	and and7(sw, ~in[4], ~in[3], in[2], in[1], in[0]);			// 00111	sw
	and and8(lw, ~in[4], in[3], ~in[2], ~in[1], ~in[0]);		// 01000	lw
	and and9(isw, ~in[4], in[3], ~in[2], ~in[1], in[0]);		// 01001 isw
	and and10(ilw, ~in[4], in[3], ~in[2], in[1], ~in[0]);		// 01010 ilw
	and and11(ri, ~in[4], in[3], ~in[2], in[1], in[0]);		// 01011 ri
	and and12(rtick, ~in[4], in[3], in[2], ~in[1], ~in[0]);	// 01100 rtick
	and and13(rsec, ~in[4], in[3], in[2], ~in[1], in[0]);		// 01101 rsec
	and and14(sfx, ~in[4], in[3], in[2], in[1], ~in[0]);		// 01110 sfx
//	and and15(w[15], ~in[4], in[3], in[2], in[1], in[0]);		// 01111
//	and and16(w[16], in[4], ~in[3], ~in[2], ~in[1], ~in[0]);	// 10000
//	and and17(w[17], in[4], ~in[3], ~in[2], ~in[1], in[0]);	// 10001
//	and and18(w[18], in[4], ~in[3], ~in[2], in[1], ~in[0]);	// 10010
//	and and19(w[19], in[4], ~in[3], ~in[2], in[1], in[0]);	// 10011
//	and and20(w[20], in[4], ~in[3], in[2], ~in[1], ~in[0]);	// 10100
	and and21(setx, in[4], ~in[3], in[2], ~in[1], in[0]);		// 10101	setx
	and and22(bex, in[4], ~in[3], in[2], in[1], ~in[0]);		// 10110	bex
//	and and23(w[23], in[4], ~in[3], in[2], in[1], in[0]);		// 10111
//	and and24(w[24], in[4], in[3], ~in[2], ~in[1], ~in[0]);	// 11000
//	and and25(w[25], in[4], in[3], ~in[2], ~in[1], in[0]);	// 11001
//	and and26(w[26], in[4], in[3], ~in[2], in[1], ~in[0]);	// 11010
//	and and27(w[27], in[4], in[3], ~in[2], in[1], in[0]);		// 11011
//	and and28(w[28], in[4], in[3], in[2], ~in[1], ~in[0]);	// 11100
//	and and29(w[29], in[4], in[3], in[2], ~in[1], in[0]);		// 11101
//	and and30(w[30], in[4], in[3], in[2], in[1], ~in[0]);		// 11110
//	and and31(w[31], in[4], in[3], in[2], in[1], in[0]);		// 11111

endmodule
