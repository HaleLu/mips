module ALUctrl(ALUOp, funct, op, e);
	input		[1:0]	ALUOp;
	input		[5:0]	funct;
	output	reg	[3:0]	op;
	output	reg			e;

	parameter	ADD	= 6'b100000,
				SUB	= 6'b100010,
				AND	= 6'b100100,
				OR	= 6'b100101,
				SLT	= 6'b101010;

	always @(*) begin
		case (ALUOp)
			2'b00 : begin
				op <= 4'b0010;
				e <= 0;
			end
			2'b01 : begin
				op <= 4'b0110;
				e <= 0;
			end
			2'b10 : begin
				case (funct)
					ADD	: begin
						op <= 4'b0010;
						e <= 0;
					end
					SUB	: begin
						op <= 4'b0110;
						e <= 0;
					end
					AND	: begin
						op <= 4'b0000;
						e <= 0;
					end
					OR	: begin
						op <= 4'b0001;
						e <= 0;
					end
					SLT	: begin
						op <= 4'b0111;
						e <= 0;
					end
					default : begin
						e <= 1;
					end
				endcase
			end
		endcase
	end
endmodule