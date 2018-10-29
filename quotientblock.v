module quotientblock(d, clk, start, ena, shiftIn, q);

	input [63:0] d;
	input clk, start, ena, shiftIn;
	
	output [63:0] q;
	
	wire [63:0] writeData, outData;
	
	genvar i;
	generate
		for(i = 0; i < 64; i = i+1) begin: loop1
			dffe_ref dffe(outData[i], writeData[i], clk, ena, 1'b0);
		end
	endgenerate
	
//	in, cur, shiftIn, start, out
	quotientshifter myshifter(d, outData, shiftIn, start, writeData);
	
	assign q = outData;

endmodule
