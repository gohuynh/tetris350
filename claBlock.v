module claBlock(x, y, cin, s, G, P);
	input [7:0] x, y;
	input cin;
	
	output [7:0] s;
	output G, P;
	
	wire [7:0] g, p, c;
	
	genvar i;
	generate
		for(i = 0; i < 8; i=i+1) begin: loop1
			and andg(g[i], x[i], y[i]);
			xor xorp(p[i], x[i], y[i]);
		end
	endgenerate
	
	assign c[0] = cin;
	
	wire w11;
	and and11(w11, p[0], cin);
	or or1(c[1], g[0], w11);
	
	wire w21, w22;
	and and21(w21, p[1], p[0], cin);
	and and22(w22, p[1], g[0]);
	or or2(c[2], g[1], w22, w21);
	
	wire w31, w32, w33;
	and and31(w31, p[2], p[1], p[0], cin);
	and and32(w32, p[2], p[1], g[0]);
	and and33(w33, p[2], g[1]);
	or or3(c[3], g[2], w33, w32, w31);
	
	wire w41, w42, w43, w44;
	and and41(w41, p[3], p[2], p[1], p[0], cin);
	and and42(w42, p[3], p[2], p[1], g[0]);
	and and43(w43, p[3], p[2], g[1]);
	and and44(w44, p[3], g[2]);
	or or4(c[4], g[3], w44, w43, w42, w41);
	
	wire w51, w52, w53, w54, w55;
	and and51(w51, p[4], p[3], p[2], p[1], p[0], cin);
	and and52(w52, p[4], p[3], p[2], p[1], g[0]);
	and and53(w53, p[4], p[3], p[2], g[1]);
	and and54(w54, p[4], p[3], g[2]);
	and and55(w55, p[4], g[3]);
	or or5(c[5], g[4], w55, w54, w53, w52, w51);
	
	wire w61, w62, w63, w64, w65, w66;
	and and61(w61, p[5], p[4], p[3], p[2], p[1], p[0], cin);
	and and62(w62, p[5], p[4], p[3], p[2], p[1], g[0]);
	and and63(w63, p[5], p[4], p[3], p[2], g[1]);
	and and64(w64, p[5], p[4], p[3], g[2]);
	and and65(w65, p[5], p[4], g[3]);
	and and66(w66, p[5], g[4]);
	or or6(c[6], g[5], w66, w65, w64, w63, w62, w61);
	
	wire w71, w72, w73, w74, w75, w76, w77;
	and and71(w71, p[6], p[5], p[4], p[3], p[2], p[1], p[0], cin);
	and and72(w72, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and and73(w73, p[6], p[5], p[4], p[3], p[2], g[1]);
	and and74(w74, p[6], p[5], p[4], p[3], g[2]);
	and and75(w75, p[6], p[5], p[4], g[3]);
	and and76(w76, p[6], p[5], g[4]);
	and and77(w77, p[6], g[5]);
	or or7(c[7], g[6], w77, w76, w75, w74, w73, w72, w71);

	generate
		for(i = 0; i < 8; i=i+1) begin: loop2
			xor xors(s[i], p[i], c[i]);
		end
	endgenerate
	
	and andP(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
	
	wire w01, w02, w03, w04, w05, w06, w07;
	and and01(w01, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
	and and02(w02, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
	and and03(w03, p[7], p[6], p[5], p[4], p[3], g[2]);
	and and04(w04, p[7], p[6], p[5], p[4], g[3]);
	and and05(w05, p[7], p[6], p[5], g[4]);
	and and06(w06, p[7], p[6], g[5]);
	and and07(w07, p[7], g[6]);
	or or0(G, g[7], w07, w06, w05, w04, w03, w02, w01);
	

endmodule
