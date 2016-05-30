module mux2 #(parameter W = 32) (a, b, s, dout);
	input	[W-1:0]	a;
	input	[W-1:0]	b;
	input			s;
	output	[W-1:0]	dout;
	
	assign dout = s ? b : a;
endmodule

module mux3 #(parameter W = 32) (a, b, c, s, dout);
	input	[W-1:0]	a;
	input	[W-1:0]	b;
	input	[W-1:0]	c;
	input			s;
	output	[W-1:0]	dout;
	
	assign dout = (s==2'b00) ? a : (s==2'b01) ? b : c;
endmodule