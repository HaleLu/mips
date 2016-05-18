module dm_4k(addr, din, we, re, clk, dout);
	input		[11:2]	addr ;  // address bus
	input		[31:0]	din ;   // 32-bit input data
	input				we ;    // memory write enable
	input				re ;    // memory read enable
	input				clk ;   // clock
	output	reg	[31:0]  dout ;  // 32-bit memory output

	reg			[31:0]	dm[1023:0] ;

	always @(posedge clk) begin
		if (we) begin
			dm[addr[11:2]][31:0] <= din[31:0];
		end
	end

	always @(addr) begin
		if (re) begin
			dout[31:0] <= dm[addr[11:2]][31:0];
		end
	end
endmodule