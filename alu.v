module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	wire [31:0] add, subtract, g, p, notB, sll, sra, opcode, x;
	wire addC, subC, equal;
	
	bitNot notb(notB, data_operandB);
	
	// ADD
	claAdder myadder(data_operandA, data_operandB, 1'b0, add, addC);
	
	// SUBTRACT
	claAdder mysubtracter(data_operandA, notB, 1'b1, subtract, subC);
	
	// AND
	bitAnd andg(g, data_operandA, data_operandB);
	
	// OR
	bitOr orp(p, data_operandA, data_operandB);
	
	// SLL
	lls mylls(sll, data_operandA, ctrl_shiftamt);
	
	// SRA
	ars myars1(sra, data_operandA, ctrl_shiftamt);
	
	// Output based on opcode
	decoder5to32 decodeOp(ctrl_ALUopcode, 1'b1, opcode);
	assign data_result = opcode[0] ? add : 32'dz;
	assign data_result = opcode[1] ? subtract : 32'dz;
	assign data_result = opcode[2] ? g : 32'dz;
	assign data_result = opcode[3] ? p : 32'dz;
	assign data_result = opcode[4] ? sll : 32'dz;
	assign data_result = opcode[5] ? sra : 32'dz;
	
	// XNOR
	bitXnor xnorx(x, data_operandA, data_operandB);
	
	// Shows if not equal
	and andequal(equal,x[0],x[1],x[2],x[3],x[4],x[5],x[6],x[7],
							x[8],x[9],x[10],x[11],x[12],x[13],x[14],x[15],
							x[16],x[17],x[18],x[19],x[20],x[21],x[22],x[23],
							x[24],x[25],x[26],x[27],x[28],x[29],x[30],x[31]);
	not notequal(isNotEqual, equal);
	
	// Check overflow
	wire opSumSigns, opDiffSigns, sumOverflow, diffOverflow, sumSign, diffSign;
	
	xnor xnoropsumsigns(opSumSigns, data_operandA[31], data_operandB[31]);
	xnor xnoropdiffsigns(opDiffSigns, data_operandA[31], notB[31]);
	
	xor xorsumsign(sumSign, data_operandA[31], add[31]);
	xor xordiffsign(diffSign, data_operandA[31], subtract[31]);
	
	and andsumoverflow(sumOverflow, opSumSigns, sumSign);
	and anddiffoverflow(diffOverflow, opDiffSigns, diffSign);
	
	assign overflow = opcode[0] ? sumOverflow : diffOverflow;
	
	// Shows if less than
	assign isLessThan = diffOverflow ? data_operandA[31] : subtract[31];

endmodule
