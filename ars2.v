module ars2(out, in);
	input [31:0] in;
	
	output [31:0] out;
	
	genvar i;
	generate
		for(i = 29; i >= 0; i=i-1) begin: loop1
			assign out[i] = in[i+2];
		end
	endgenerate
	assign out[31] = in[31];
	assign out[30] = in[31];

endmodule
