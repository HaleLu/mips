module alu(op, a, b, zero, dout);
	input		[3:0]	op;
	input		[31:0]	a;
	input		[31:0]	b;
	output				zero;
	output reg	[31:0]	dout;

	assign zero = dout == 0 ? 1 : 0;
	always @(op or a or b) begin
		case(op)
			4'b0010 : dout = a + b;
			4'b0110 : dout = a - b;
			4'b0001 : dout = a | b;
			4'b0000 : dout = a & b;
			4'b0111 : begin
				dout = a < b ? 1 : 0;
			end
		endcase
	end
endmodule
