
module load_unit(
input clock,reset,
input [31:0] int_in_load,
input [2:0] fu3,
input [1:0]addr,
output reg [31:0] int_out_load
);
reg [1:0]addr_reg;

always@(posedge clock, negedge reset)
begin
    if(!reset)
    addr_reg <= 2'b00;
    else
    addr_reg <= addr;
end

always@(*)
begin
	case(fu3)
		3'd2 : int_out_load <= int_in_load;     						//lw

		3'd4 : case(addr_reg)											//lbu
				 2'd0 : int_out_load <= {24'b0, int_in_load[7:0]};	
				 2'd1 : int_out_load <= {24'b0, int_in_load[15:8]};
				 2'd2 : int_out_load <= {24'b0, int_in_load[23:16]};
				 2'd3 : int_out_load <= {24'b0, int_in_load[31:24]};	
				 default : int_out_load <= {24'b0, int_in_load[7:0]};	
                 endcase

		3'd5 : case(addr_reg)											//lhu	
				 2'd0 : int_out_load <= {16'b0, int_in_load[15:0]};	
				 2'd2 : int_out_load <= {16'b0, int_in_load[31:16]};
				 default : int_out_load <= {16'b0, int_in_load[15:0]};
                 endcase

		default : int_out_load <= int_in_load;
		endcase
end

endmodule
