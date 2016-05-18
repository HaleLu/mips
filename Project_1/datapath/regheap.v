module regheap(clk, we, rreg1, rreg2, wreg, wdata, rdata1, rdata2);
	input			clk;
	input			we;
	input	[4:0]	rreg1, rreg2, wreg;
	input	[31:0]	wdata;
	output	[31:0]	rdata1, rdata2;
	
	reg 	[31:0]	rh[31:0];

	initial begin
		rh[8] = 32'b0000_0000_0000_0000_0000_0000_0000_0001;
		rh[9] = 32'b0000_0000_0000_0000_0000_0000_0000_0010;

		rh[12] = 32'b0000_0000_0000_0000_0000_0000_0100_0001;
		rh[13] = 32'b0000_0000_0000_0000_0000_0000_0010_0000;

		rh[15] = 32'b0000_0000_0000_0000_0011_0000_0000_0001;
		rh[16] = 32'b0000_0000_0000_0000_0110_0000_0000_0010;

		rh[18] = 32'b0000_0000_0000_1010_0000_0000_0000_0001;
		rh[19] = 32'b0000_0000_0000_1001_0000_0000_0000_0010;

		rh[21] = 32'b0000_0000_0010_0000_0000_0000_0000_0001;
		rh[22] = 32'b0000_0000_0100_0000_0000_0000_0000_0010;
	end

	always @(posedge clk) begin
		if (we) begin
			rh[wreg] <= wdata;
			$display(rh[10]);
		end
	end
	
	assign rdata1 = (rreg1 != 0)? rh[rreg1]:0;
	assign rdata2 = (rreg2 != 0)? rh[rreg2]:0;
endmodule