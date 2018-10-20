module reg5(clk, inEnabled, reset, in, out);
	//Input: control bits
	input clk, inEnabled, reset;
	
	//Input: data
	input [4:0] in;
	
	//Output: data
	output [4:0] out;
	
	//Read enabled wire
	wire wr;
	
	//Check write enabled
	and and1(wr, clk, inEnabled);
	
	//Make edits to each bit if necessary
	genvar i;
	generate
		for (i = 0; i<5; i=i+1) begin: loop1
			dffe_ref dffe(.q(out[i]), .d(in[i]), .clk(clk), .en(inEnabled), .clr(reset));
		end
	endgenerate
	
endmodule
