module ars1(out, in);
	input [31:0] in;
	
	output [31:0] out;
	
	genvar i;
	generate
		for(i = 30; i >= 0; i=i-1) begin: loop1
			assign out[i] = in[i+1];
		end
	endgenerate
	assign out[31] = in[31];

endmodule
