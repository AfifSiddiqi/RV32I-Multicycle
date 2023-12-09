module mux_5x1(
input [31:0] a,b,c,d,e,
input [2:0] s,
output reg[31:0] q ); 

always@(*)
begin
	case(s)
	3'b000: q = a;
	3'b001: q = b;	//load
	3'b010: q = c;  //lui
	3'b011: q = d; // extra for jump
	3'b100: q = e; // auipc
	default: q = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
	endcase
end

endmodule