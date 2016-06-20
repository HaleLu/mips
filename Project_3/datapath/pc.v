module pc (clk, rst, en, data, dout);
	input				clk;
	input				rst;
	input				en;
	input		[31:0]	data;
	output	reg	[31:0]	dout;

	always @(posedge clk)
	begin
		if(rst)
			dout[31:0] <= {32'h0000_3000};
		else 
		if (en) begin
			dout <= data;
		end
	end
endmodule
