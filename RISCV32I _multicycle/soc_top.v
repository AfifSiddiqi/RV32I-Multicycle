module soc_top(
input clk,rst);

wire [31:0]mux_out1;
wire [31:0]B_out;
wire w_en_mem, r_en_mem;
wire [31:0] memout;

RISCV32I rv32_inst(	.clk_in(clk),
							.rst_in(rst),
							.address(mux_out1),
							.data_out(B_out),
							.w_en_mem(w_en_mem), 
							.r_en_mem(r_en_mem), 
							.MemData(memout)
);							

inst_and_data_mem memory(.clk(clk),
								.address(mux_out1>>2),
								.write_data(B_out),
								.MemWrite(w_en_mem), 
								.MemRead(r_en_mem), 
								.MemData(memout)
);


always@(*)
begin
	if(mux_out1 == 32'h800000 & w_en_mem == 1)
			$write("%c",B_out[7:0]);
end

endmodule
					

