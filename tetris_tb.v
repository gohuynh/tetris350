`timescale 1 ns / 100ps
module tetris_tb();
	reg clk, reset;
	wire VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC;
	wire [7:0] VGA_R, VGA_G, VGA_B;
	
	tetris dut(clk,
	 reset,
	 VGA_CLK,  														//	VGA Clock
	 VGA_HS,															//	VGA H_SYNC
	 VGA_VS,															//	VGA V_SYNC
	 VGA_BLANK,														//	VGA BLANK
	 VGA_SYNC,														//	VGA SYNC
	 VGA_R,   														//	VGA Red[9:0]
	 VGA_G,	 														//	VGA Green[9:0]
	 VGA_B);
	
	initial
		begin
			$display($time,"<< Starting the Simulation >>");
//			$display($time,"%10s %10s %10s %10s %10s", "PC", "OPCODE", "ALUOUT", "MEMADDR", "WDATA");
//			$monitor("------------------------------------------------------------------------------------------------------------------------------------------\nRegisters(0-9): %10d %10d %10d %10d %10d %10d %10d %10d %10d %10d\n------------------------------------------------------------------------------------------------------------------------------------------"
//						, $signed(dut.my_regfile.reg0.out), $signed(dut.my_regfile.reg1.out), $signed(dut.my_regfile.reg2.out), $signed(dut.my_regfile.reg3.out), 
//						$signed(dut.my_regfile.reg4.out), $signed(dut.my_regfile.reg5.out), $signed(dut.my_regfile.reg6.out), $signed(dut.my_regfile.reg7.out), $signed(dut.my_regfile.reg8.out), $signed(dut.my_regfile.reg30.out));
			clk = 1'b0;    // at time 0
			reset = 1'b0;
			#1000;
			$stop;
		end
		
	always@(posedge clk or negedge clk)
		begin
//			$display($time, "%10d %10d %10d %10d %10d %10d %10d %10d", dut.my_processor.address_imem, dut.my_processor.dOpcode, dut.my_processor.xOpcode, dut.my_processor.mO, dut.my_processor.wRegData, dut.my_processor.ctrl_readRegB, dut.my_processor.operandB, dut.my_processor.xD);
//			$display($time, "%10d %10d %10d %10d %10d", dut.my_processor.address_imem, dut.my_processor.dOpcode, dut.my_processor.xOpcode, dut.my_processor.mO, dut.my_processor.wRegData);
			$display($time, "%10d %10d %10d %10d", dut.block1x, dut.block1y, dut.vga_ins.myProcessor.b1x, dut.vga_ins.myProcessor.b1y);
		end
	always@(posedge clk)
		begin
			#1;
			$display("------------------------------------------------------------------------------------------------------------------------------------------");
		end
	
	always
		#10 clk = ~clk;

endmodule