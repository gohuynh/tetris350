module signExtenderJI(in, out);
	input[26:0] in;
	
	output[31:0] out;
	
	assign out[26:0] = in;
	genvar i;
	generate
		for (i = 27; i<32; i=i+1) begin: loop1
			assign out[i] = in[26];
		end
	endgenerate

endmodule
