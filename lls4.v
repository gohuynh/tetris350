module lls4(out, in);
	input [31:0] in;
	
	output [31:0] out;
	
	genvar i;
	generate
		for(i = 4; i < 32; i=i+1) begin: loop1
			assign out[i] = in[i-4];
		end
	endgenerate
	generate
		for(i = 0; i < 4; i=i+1) begin: loop2
			assign out[i] = 1'b0;
		end
	endgenerate
	
endmodule
