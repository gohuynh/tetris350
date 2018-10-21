module decoder3to8 (in, en, out);
	input en;
	input [2:0]	in;
	
	output [7:0] out;
	
	and and0(out[0], ~in[0], ~in[1], ~in[2], en);
	and and1(out[1], in[0], ~in[1], ~in[2], en);
	and and2(out[2], ~in[0], in[1], ~in[2], en);
	and and3(out[3], in[0], in[1], ~in[2], en);
	and and4(out[4], ~in[0], ~in[1], in[2], en);
	and and5(out[5], in[0], ~in[1], in[2], en);
	and and6(out[6], ~in[0], in[1], in[2], en);
	and and7(out[7], in[0], in[1], in[2], en);
	
endmodule
