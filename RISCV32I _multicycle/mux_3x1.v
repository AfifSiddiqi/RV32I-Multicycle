module mux_3x1(
input[31:0] a,b,c,
input [1:0]s,
output reg [31:0]q );

always@(*)
begin
	case(s)
	2'b00: q = a;
	2'b01: q = b;
	2'b10: q = c;
	default: q = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
	endcase
end

endmodule