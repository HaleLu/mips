module alu(op, a, b, zero, dout, e);
	input		[3:0]	op;
	input		[31:0]	a;
	input		[31:0]	b;
	output				zero;
	output reg	[31:0]	dout;
	output reg	[1:0]		e;

	assign zero = dout == 0 ? 1 : 0;
	always @(op or a or b) begin
		case(op)
			4'b0010 : begin
				dout = a + b;
				e = (a[31] == 0 && b[31] == 0 && dout[31] == 1) || (a[31] == 1 && b[31] == 1 && dout[31] == 0) ? 1 : 0;
			end
			4'b0110 : begin
				dout = a - b;
				e = (a[31] == 0 && b[31] == 1 && dout[31] == 1) || (a[31] == 1 && b[31] == 0 && dout[31] == 0) ? 2 : 0;
			end
			4'b0001 : begin
				dout = a | b;
				e = 0;
			end
			4'b0000 : begin
				dout = a & b;
				e = 0;
			end
			4'b0111 : begin
				dout = a < b ? 1 : 0;
				e = 0;
			end
		endcase
	end
endmodule
