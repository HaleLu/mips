module mux2 #(parameter W = 32) (a, b, s, dout);
	input	[W-1:0]	a;
	input	[W-1:0]	b;
	input			s;
	output	[W-1:0]	dout;
	
	assign dout = s ? b : a;
endmodule