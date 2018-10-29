module productblock(d, clk, start, ena, q, lsb);

	input [63:0] d;
	input clk, start, ena;
	
	output [63:0] q;
	output [1:0] lsb;
	
	wire [63:0] writeData, outData;
	wire helperTemp, helperIn, helperOut;
	
	genvar i;
	generate
		for(i = 0; i < 64; i = i+1) begin: loop1
			dffe_ref dffe(outData[i], writeData[i], clk, ena, 1'b0);
		end
	endgenerate
	
	
	blockshifter myshifter(d, outData, start, writeData, helperIn);
	dffe_ref helper(helperOut, helperIn, clk, ena, 1'b0);
	
	assign q = outData;
	assign lsb[1] = outData[0];
	assign lsb[0] = helperOut;

endmodule
