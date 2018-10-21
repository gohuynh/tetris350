module ars8(out, in);
	input [31:0] in;
	
	output [31:0] out;
	
	genvar i;
	generate
		for(i = 23; i >= 0; i=i-1) begin: loop1
			assign out[i] = in[i+8];
		end
	endgenerate
	generate
		for(i = 31; i >23; i=i-1) begin: loop2
			assign out[i] = in[31];
		end
	endgenerate
	
endmodule
