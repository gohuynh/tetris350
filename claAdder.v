module claAdder (x,y,cin,s,cout);
	input [31:0] x,y;
	input cin;
	
	output [31:0] s;
	output cout;
	
	wire c8, c16, c24;
	wire [3:0] G, P;
	
	claBlock b0(x[7:0], y[7:0], cin, s[7:0], G[0], P[0]);
	claBlock b1(x[15:8], y[15:8], c8, s[15:8], G[1], P[1]);
	claBlock b2(x[23:16], y[23:16], c16, s[23:16], G[2], P[2]);
	claBlock b3(x[31:24], y[31:24], c24, s[31:24], G[3], P[3]);
	
	wire w01;
	and and01(w01, P[0], cin);
	or or0(c8, G[0], w01);
	
	wire w11, w12;
	and and11(w11, P[1], P[0], cin);
	and and12(w12, P[1], G[0]);
	or or1(c16, G[1], w12, w11);
	
	wire w31, w32, w33;
	and and31(w31, P[2], P[1], P[0], cin);
	and and32(w32, P[2], P[1], G[0]);
	and and33(w33, P[2], G[1]);
	or or3(c24, G[2], w33, w32, w31);
	
	wire w41, w42, w43, w44;
	and and41(w41, P[3], P[2], P[1], P[0], cin);
	and and42(w42, P[3], P[2], P[1], G[0]);
	and and43(w43, P[3], P[2], G[1]);
	and and44(w44, P[3], G[2]);
	or or4(cout, G[3], w44, w43, w42, w41);

endmodule
