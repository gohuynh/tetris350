`timescale 1 ns / 100ps
module skeleton_tb();
	reg clk, reset;
	
	skeleton dut(clk, reset);
	
	initial
		begin
			$display($time,"<< Starting the Simulation >>");
			$display($time,"%10s %10s %10s %10s %10s", "PC", "OPCODE", "ALUOUT", "MEMADDR", "WDATA");
			$monitor("------------------------------------------------------------------------------------------------------------------------------------------\nRegisters(0-9): %10d %10d %10d %10d %10d %10d %10d %10d %10d %10d\n------------------------------------------------------------------------------------------------------------------------------------------"
						, $signed(dut.my_regfile.reg0.out), $signed(dut.my_regfile.reg1.out), $signed(dut.my_regfile.reg2.out), $signed(dut.my_regfile.reg3.out), 
						$signed(dut.my_regfile.reg4.out), $signed(dut.my_regfile.reg5.out), $signed(dut.my_regfile.reg6.out), $signed(dut.my_regfile.reg7.out), $signed(dut.my_regfile.reg8.out), $signed(dut.my_regfile.reg30.out));
			clk = 1'b0;    // at time 0
			reset = 1'b0;
			#1000;
			$stop;
		end
		
	always@(posedge clk or negedge clk)
		begin
//			$display($time, "%10d %10d %10d %10d %10d %10d %10d %10d", dut.my_processor.address_imem, dut.my_processor.dOpcode, dut.my_processor.xRs, dut.my_processor.xRt, dut.my_processor.xRd, dut.my_processor.wRd, dut.my_processor.mRd, dut.my_processor.xRd);//dut.my_processor.aluOut, dut.my_processor.mO, dut.my_processor.wRegData);
			$display($time, "%10d %10d %10d %10d %10d", dut.my_processor.address_imem, dut.my_processor.dOpcode, dut.my_processor.xOpcode, dut.my_processor.mO, dut.my_processor.wRegData);
		end
	always@(posedge clk)
		begin
			#1;
			$display("------------------------------------------------------------------------------------------------------------------------------------------");
		end
	
	always
		#10 clk = ~clk;

endmodule
