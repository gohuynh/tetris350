module gatedSlaveLatch(clk, s, r, q);
	input clk, s, r;
	
	output q;
	
	wire wand1, wand2, wnor1, wnor2;
	
	and and1(wand1, ~clk, r);
	and and2(wand2, ~clk, s);
	
	nor nor1(wnor1, wand1, wnor2);
	nor nor2(wnor2, wand2, wnor1);
	
	assign q = wnor1;

endmodule
