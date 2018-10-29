module divider(operandA, operandB, clk, start, interrupt, result, ready, exception);
	input [31:0] operandA, operandB;
	input clk, start, interrupt;
	
	output [31:0] result;
	output ready, exception;
	
	// Make absolute values
	wire [31:0] negA, negB, inputA, inputB;
	wire ineA, ineB;
	
	mdAlu negateA(32'b0, operandA, 1'b0, negA, ineA);
	mdAlu negateB(32'b0, operandB, 1'b0, negB, ineB);
	
	assign inputA = operandA[31] ? negA : operandA;
	assign inputB = operandB[31] ? negB : operandB;

	// Set up control
	wire done;
	
	divcontrol control(start, clk, interrupt, done);
	
	// Save divisor to register
	wire [31:0] divisor;
	
	genvar i;
	generate
		for(i = 0; i < 32; i=i+1) begin: loop1
			dffe_ref dffDivisor(divisor[i], inputB[i], clk, start, 1'b0);
		end
	endgenerate
	
	// Get output's sign
	wire msbSigns, quotientSign;
	
	xor xorSigns(msbSigns, operandA[31], operandB[31]);
	dffe_ref dffSign(quotientSign, msbSigns, clk, start, 1'b0);
	
	// Set up inputs to registers
	wire [63:0] startData, diffData, data, out;
	wire [31:0] diff;
	wire ineMain;
	
	assign startData[63:33] = 31'd0;
	assign startData[32:1] = inputA;
	assign startData[0] = 0;
	
	mdAlu myAlu(out[63:32], divisor, 1'b0, diff, ineMain);
	assign diffData[31:0] = 32'd0;
	assign diffData[63:32] = diff[31] ? out[63:32] : diff;
	
	assign data = start ? startData : diffData;
	
	// Set up registers
	quotientblock quotient(data, clk, start, ~done, ~diff[31], out);
	
	// Output results
	assign ready = done;
	
	wire ineQ;
	wire [31:0] negQuotient;
	mdAlu negateQuotient(32'b0, out[31:0], 1'b0, negQuotient, ineQ);
	assign result = quotientSign ? negQuotient : out[31:0];
	
	dffe_ref dffZero(exception, ~ineB, clk, start, 1'b0);

endmodule
