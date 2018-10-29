module multOverflow(in, out);
	input [63:0] in;
	
	output out;
	
	wire msb, mb;
	
	xor xormb(mb, in[32], in[31]);
	xor xormsb(msb, in[63], in[62], in[61], in[60], in[59], in[58], in[57], in[56],
					    in[55], in[54], in[53], in[52], in[51], in[50], in[49], in[48],
						 in[47], in[46], in[45], in[44], in[43], in[42], in[41], in[40],
						 in[39], in[38], in[37], in[36], in[35], in[34], in[33], in[32]);
	
	xor xorout(out, mb, msb);
	
endmodule
