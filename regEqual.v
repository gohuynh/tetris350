module regEqual(reg1, reg2, out);
	input[4:0] reg1, reg2;
	
	output out;
	
	wire[4:0] w;
	genvar i;
	generate
		for (i = 0; i<5; i=i+1) begin: loop1
			xnor myxnor(w[i], reg1[i], reg2[i]);
		end
	endgenerate
	
	and myand(out, w[0], w[1], w[2], w[3], w[4]);

endmodule
