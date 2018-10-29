module regEqual(reg1, reg2, out);
	input[4:0] reg1, reg2;
	
	output out;
	
	wire[4:0] w;
//	genvar i;
//	generate
//		for (i = 0; i<5; i=i+1) begin: loop1
//			xnor myxnor(w[i], reg1[i], reg2[i]);
//		end
//	endgenerate
	xnor myxnor0(w[0], reg1[0], reg2[0]);
	xnor myxnor1(w[1], reg1[1], reg2[1]);
	xnor myxnor2(w[2], reg1[2], reg2[2]);
	xnor myxnor3(w[3], reg1[3], reg2[3]);
	xnor myxnor4(w[4], reg1[4], reg2[4]);
	
	and myand(out, w[0], w[1], w[2], w[3], w[4]);

endmodule
