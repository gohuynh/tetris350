module multdiv(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
	 
	 wire [31:0] mult_result, div_result;
	 wire mult_ready, mult_exception, div_ready, div_exception;

    // Your code here
	 
	 wire mEnabled, dEnabled;
	 gatedSlaveLatch mLatch(clock, ctrl_MULT, ctrl_DIV, mEnabled);
	 gatedSlaveLatch dLatch(clock, ctrl_DIV, ctrl_MULT, dEnabled);
	 
//	 operandA, operandB, clk, start, result, finish, overflow
	 multiplier mult(data_operandA, data_operandB, clock, ctrl_MULT, ctrl_DIV, mult_result, mult_ready, mult_exception);
	 
//	 operandA, operandB, clk, start, interrupt, result, ready, exception
	 divider div(data_operandA, data_operandB, clock, ctrl_DIV, ctrl_MULT, div_result, div_ready, div_exception);
	 
	 
	 assign data_result = mEnabled ? mult_result : div_result;
	 assign data_resultRDY = mEnabled ? mult_ready : div_ready;
	 assign data_exception = mEnabled ? mult_exception : div_exception;

endmodule
