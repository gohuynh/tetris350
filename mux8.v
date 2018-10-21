module mux8(s, in0, in1, in2, in3, in4, in5, in6, in7, out);
	input [2:0] s;
	input in0, in1, in2, in3, in4, in5 ,in6 ,in7;
	
	output out;
	
	wire [7:0] decoded;
	
	decoder3to8 myDecoder(s, 1'b1, decoded);
	
	assign out = decoded[0] ? in0 :
					 decoded[1] ? in1 :
					 decoded[2] ? in2 :
					 decoded[3] ? in3 :
					 decoded[4] ? in4 :
					 decoded[5] ? in5 :
					 decoded[6] ? in6 : in7;
	
endmodule
