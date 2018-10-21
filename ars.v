module ars(out, in, s);
	input [31:0] in;
	input [4:0] s;
	
	output [31:0] out;
	
	wire [31:0] s16,s8,s4,s2,s1,m0,m1,m2,m3;
	
	ars16 my16(s16, in);
	assign m0 = s[4] ? s16 : in;
	
	ars8 my8(s8, m0);
	assign m1 = s[3] ? s8 : m0;
	
	ars4 my4(s4, m1);
	assign m2 = s[2] ? s4 : m1;
	
	ars2 my2(s2, m2);
	assign m3 = s[1] ? s2 : m2;
	
	ars1 my1(s1, m3);
	assign out = s[0] ? s1 : m3;
	

endmodule
