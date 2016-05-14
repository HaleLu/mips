module testbench();
	reg clk, rst;

	initial begin
		clk = 0;
		rst = 1;
		#12 rst = 0;
	end

	always #10 clk = ~clk;

	mips mips(clk, rst);
endmodule