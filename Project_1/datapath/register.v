module register #(parameter W = 32) (clk, rst, data, dout);
	input				clk;
	input				rst;
	input		[W-1:0]	data;
	output	reg	[W-1:0]	dout;

	always @(posedge clk)
	begin
		if(rst)
			dout[W-1:0] <= {W-1{1'b0}};
		else
			dout <= data;
	end
endmodule