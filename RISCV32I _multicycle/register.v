module register 
#(parameter width = 32)
(clk,reset,d,q);
input clk, reset;

input [width-1:0] d;
output reg [width-1:0] q;

always@(posedge clk or negedge reset)
begin
	if(!reset)
		q <= 0;
	else
		q <= d;
end

endmodule