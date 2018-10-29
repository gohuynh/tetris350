module blockshifter(in, cur, start, out, helper);
	input [63:0] in, cur;
	input start;
	
	output [63:0] out;
	output helper;
	
	wire [63:0] shiftedIn;

	assign shiftedIn[30:0] = cur[31:1];
	assign shiftedIn[62:31] = in[63:32];
	assign shiftedIn[63] = in[63];
	
	assign out = start ? in : shiftedIn;
	assign helper = start ? 1'b0 : cur[0];
	
endmodule
