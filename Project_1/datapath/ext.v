module ext #(parameter W = 16) (in, dout);
	input	[W-1:0]	in; 
	output	[31:0]	dout;
	
	assign dout = {{32-W{in[W-1]}}, in};
endmodule