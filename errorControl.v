module errorControl(overflow, rType, aluOp, rdIn, dIn, rdOut, dOut);
	input overflow, rType;
	input[4:0] aluOp, rdIn;
	input[31:0] dIn;
	
	output[4:0] rdOut;
	output[31:0] dOut;
	
	wire[31:0] opcode, exception;
	wire add, addi;
	
	assign rdOut = overflow ? 32'd30 : rdIn;
	
	decoder5to32 decodeOp(aluOp, 1'b1, opcode);
	and andAdd(add, rType, opcode[0]);
	and andAddi(addi, ~rType, opcode[0]);
	
	assign exception = add ? 32'd1 : (addi ? 32'd2 : (opcode[1] ? 32'd3 : (opcode[6] ? 32'd4 : (opcode[7] ? 32'd5 : dIn))));
	
	assign dOut = overflow ? exception : dIn;
endmodule
