module ALUctrl(ALUOp, funct, op);
	input		[1:0]	ALUOp;
	input		[5:0]	funct;
	output	reg	[3:0]	op;

	parameter	ADD	= 6'b100000,
				SUB	= 6'b100010,
				AND	= 6'b100100,
				OR	= 6'b100101,
				SLT	= 6'b101010;

	always @(*) begin
		case (ALUOp)
			2'b00 : begin
				op <= 4'b0010;
			end
			2'b01 : begin
				op <= 4'b0110;
			end
			2'b10 : begin
				case (funct)
					ADD	: begin
						op <= 4'b0010;
					end
					SUB	: begin
						op <= 4'b0110;
					end
					AND	: begin
						op <= 4'b0000;
					end
					OR	: begin
						op <= 4'b0001;
					end
					SLT	: begin
						op <= 4'b0111;
					end
				endcase
			end
		endcase
	end
endmodule