module pcLatch (clk, inEnabled, reset, in, out);
	//Input: control bits
	input clk, inEnabled, reset;
	
	//Input: data
	input [11:0] in;
	
	//Output: data
	output [11:0] out;
	
	//Make edits to each bit if necessary
	genvar i;
	generate
		for (i = 0; i<12; i=i+1) begin: loop1
			dffe_ref dffe(.q(out[i]), .d(in[i]), .clk(clk), .en(inEnabled), .clr(reset));
		end
	endgenerate
	
endmodule
