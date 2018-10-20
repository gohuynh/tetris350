module decoder5to32 (in, en, out);
	input en;
	input [4:0]	in;
	
	wire [31:0] w;
	wire [3:0] we;
	
	output [31:0] out;
	
	and and0(w[0], ~in[4], ~in[3], ~in[2], ~in[1], ~in[0], en);
	and and1(w[1], ~in[4], ~in[3], ~in[2], ~in[1], in[0], en);
	and and2(w[2], ~in[4], ~in[3], ~in[2], in[1], ~in[0], en);
	and and3(w[3], ~in[4], ~in[3], ~in[2], in[1], in[0], en);
	and and4(w[4], ~in[4], ~in[3], in[2], ~in[1], ~in[0], en);
	and and5(w[5], ~in[4], ~in[3], in[2], ~in[1], in[0], en);
	and and6(w[6], ~in[4], ~in[3], in[2], in[1], ~in[0], en);
	and and7(w[7], ~in[4], ~in[3], in[2], in[1], in[0], en);
	and and8(w[8], ~in[4], in[3], ~in[2], ~in[1], ~in[0], en);
	and and9(w[9], ~in[4], in[3], ~in[2], ~in[1], in[0], en);
	and and10(w[10], ~in[4], in[3], ~in[2], in[1], ~in[0], en);
	and and11(w[11], ~in[4], in[3], ~in[2], in[1], in[0], en);
	and and12(w[12], ~in[4], in[3], in[2], ~in[1], ~in[0], en);
	and and13(w[13], ~in[4], in[3], in[2], ~in[1], in[0], en);
	and and14(w[14], ~in[4], in[3], in[2], in[1], ~in[0], en);
	and and15(w[15], ~in[4], in[3], in[2], in[1], in[0], en);
	and and16(w[16], in[4], ~in[3], ~in[2], ~in[1], ~in[0], en);
	and and17(w[17], in[4], ~in[3], ~in[2], ~in[1], in[0], en);
	and and18(w[18], in[4], ~in[3], ~in[2], in[1], ~in[0], en);
	and and19(w[19], in[4], ~in[3], ~in[2], in[1], in[0], en);
	and and20(w[20], in[4], ~in[3], in[2], ~in[1], ~in[0], en);
	and and21(w[21], in[4], ~in[3], in[2], ~in[1], in[0], en);
	and and22(w[22], in[4], ~in[3], in[2], in[1], ~in[0], en);
	and and23(w[23], in[4], ~in[3], in[2], in[1], in[0], en);
	and and24(w[24], in[4], in[3], ~in[2], ~in[1], ~in[0], en);
	and and25(w[25], in[4], in[3], ~in[2], ~in[1], in[0], en);
	and and26(w[26], in[4], in[3], ~in[2], in[1], ~in[0], en);
	and and27(w[27], in[4], in[3], ~in[2], in[1], in[0], en);
	and and28(w[28], in[4], in[3], in[2], ~in[1], ~in[0], en);
	and and29(w[29], in[4], in[3], in[2], ~in[1], in[0], en);
	and and30(w[30], in[4], in[3], in[2], in[1], ~in[0], en);
	and and31(w[31], in[4], in[3], in[2], in[1], in[0], en);
	
	assign out = w;
	
	
endmodule