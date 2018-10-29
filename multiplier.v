module multiplier(operandA, operandB, clk, start, interrupt, result, finish, overflow);

	input [31:0] operandA, operandB;
	input clk, start, interrupt;
	
	output [31:0] result;
	output finish, overflow;
	
	
	// Set up Control
	wire [1:0] helper;
	wire addsub, noadd, done;
	
	multcontrol control(start, clk, interrupt, helper, addsub, noadd, done);
	
	// Save multiplicand
	wire [31:0] multiplicand;
	
	genvar i;
	generate
		for(i = 0; i < 32; i=i+1) begin: loop1
			dffe_ref dffMultiplicand(multiplicand[i], operandA[i], clk, start, 1'b0);
		end
	endgenerate

	// Set up inputs to registers
	wire [63:0] startData, sumData, data, out;
	wire [31:0] sum;
	wire isNotEqual;
	
	assign startData[63:32] = 32'd0;
	assign startData[31:0] = operandB;
	
	mdAlu myAlu(out[63:32], multiplicand, addsub, sum, isNotEqual);
	assign sumData[31:0] = 32'd0;
	assign sumData[63:32] = noadd ? out[63:32] : sum;
	
	assign data = start ? startData : sumData;
	
	// Set up registers
	productblock product(data, clk, start, ~done, out, helper);
	
	// Output results
	assign finish = done;
	assign result = out[31:0];
	
	// Check for overflow
	wire ine1, ine2, noOF, keepOF, parity;
	wire[31:0] d1, d2;
	
	mdAlu equal1(32'd1, operandA, 1'b0, d1, ine1);
	mdAlu equal2(32'd1, operandB, 1'b0, d2, ine2);
	
	or or1(noOF, ~ine1, ~ine2);
	
	dffe_ref dffOF(keepOF, noOF, clk, start, 1'b0);
	
	multOverflow checkOverflow(out[63:0], parity);
	
	assign overflow = keepOF ? 1'b0 : parity;
	

endmodule
