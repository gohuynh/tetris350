module lls2(out, in);
	input [31:0] in;
	
	output [31:0] out;
	
	genvar i;
	generate
		for(i = 2; i < 32; i=i+1) begin: loop1
			assign out[i] = in[i-2];
		end
	endgenerate
	assign out[0] = 1'b0;
	assign out[1] = 1'b0;
	
endmodule
