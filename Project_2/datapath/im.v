module im_4k( addr, dout ) ;
	input	[11:2]	addr ;  // address bus
	output	[31:0]	dout ;  // 32-bit memory output

	reg		[31:0]	im[1023:0] ;
	
	initial
	begin
		$readmemh("code.txt", im);
	end

	assign dout = im[addr[11:2]][31:0];
endmodule