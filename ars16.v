module ars16(out, in);
	input [31:0] in;
	
	output [31:0] out;
	
	genvar i;
	generate
		for(i = 15; i >= 0; i=i-1) begin: loop1
			assign out[i] = in[i+16];
		end
	endgenerate
	generate
		for(i = 31; i >15; i=i-1) begin: loop2
			assign out[i] = in[31];
		end
	endgenerate
	
endmodule
