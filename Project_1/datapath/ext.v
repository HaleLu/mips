module ext #(parameter W = 16) (din, dout);
	input	[W-1:0]	din; 
	output	[31:0]	dout;
	
	assign dout = {{32-W{din[W-1]}}, din};
endmodule