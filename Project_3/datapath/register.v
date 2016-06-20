module register(clk, wdata, rdata);
	input				clk;
	input		[31:0]	wdata;
	output reg	[31:0]	rdata;

	initial begin
		rdata <= 0;
	end

	always @(posedge clk) begin
		rdata <= wdata;
	end
endmodule