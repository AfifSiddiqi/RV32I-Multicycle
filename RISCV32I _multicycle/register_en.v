module register_en
#(parameter width = 32)
(clk,reset,en,d,q);

input clk, reset, en;
input [width-1:0] d;
output reg [width-1:0] q;

always@(posedge clk or negedge reset)
begin
	if(!reset)
		q <= 32'b0;
	else if(en)
		q <= d;
end

endmodule