`timescale 1 ns / 100ps
module skeleton_tb();
	reg clk, reset;
	
	skeleton dut(clk, reset);
	
	initial
		begin
			$display($time, "<< Starting the Simulation >>");
			$monitor($time, "%d		%d			%d", dut.my_processor.address_imem, dut.my_processor.q_imem, dut.my_processor.dT);
			clk = 1'b0;    // at time 0
			#100;
			$stop;
		end
		
	always@(posedge clk)
		begin
//			$display("%d		%d			%d", dut.my_processor.address_imem, dut.my_processor.q_imem, dut.my_processor.dT);//dut.my_regfile.reg1.out);
		end
	
	always
		#10 clk = ~clk;

endmodule
