module mdAlu(data_operandA, data_operandB, ctrl_ALUopcode, data_result, isNotEqual);

   input [31:0] data_operandA, data_operandB;
   input ctrl_ALUopcode;

   output [31:0] data_result;
   output isNotEqual;

   // YOUR CODE HERE //
	wire [31:0] add, subtract, notB, g;
	wire addC, subC, equal;
	
	bitNot notb(notB, data_operandB);
	
	// ADD
	claAdder myadder(data_operandA, data_operandB, 1'b0, add, addC);
	
	// SUBTRACT
	claAdder mysubtracter(data_operandA, notB, 1'b1, subtract, subC);
	
	// XNOR
	bitXnor xnorg(g, data_operandA, data_operandB);
	
	// Output based on opcode
	assign data_result = ctrl_ALUopcode ? add : subtract;
	
	// Shows if not equal
	and andequal(equal,g[0],g[1],g[2],g[3],g[4],g[5],g[6],g[7],
							g[8],g[9],g[10],g[11],g[12],g[13],g[14],g[15],
							g[16],g[17],g[18],g[19],g[20],g[21],g[22],g[23],
							g[24],g[25],g[26],g[27],g[28],g[29],g[30],g[31]);
	not notequal(isNotEqual, equal);

endmodule
