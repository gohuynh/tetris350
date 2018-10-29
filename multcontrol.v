module multcontrol(start, clk, interrupt, helper, addsub, noadd, done);

	input start, clk, interrupt;
	input [1:0] helper;
	
	output addsub, noadd, done;
	
	counter counter32(start, clk, interrupt, done);
	
	xnor xnorNoAdd(noadd, helper[1], helper[0]);
	
	and andAddSub(addsub, ~helper[1], helper[0]);

endmodule
