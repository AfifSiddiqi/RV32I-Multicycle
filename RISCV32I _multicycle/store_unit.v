module store_unit(

input [31:0] int_in,
input [2:0] fu3,
output reg [31:0] int_out
);

always@(*)
begin
	case(fu3)
		3'b010 : int_out <= int_in;     						//sw
		3'b000 : int_out <= {24'b0,int_in[7:0]};			//sb
		3'b001 : int_out <= {16'b0,int_in[15:0]};			//sh
		default : int_out <= int_in;
		endcase
end

endmodule