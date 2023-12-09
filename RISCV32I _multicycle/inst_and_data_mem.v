	module inst_and_data_mem(
	input clk,
	input [31:0]address,
	input [31:0]write_data,
	input MemRead, MemWrite,
	output [31:0] MemData );
	
	reg [31:0]mem[17000:0];

	
	initial
		$readmemh("mem.mif", mem);
		
		
	always @(posedge clk) 
	begin
		if(MemWrite)                    
			mem[address]<=write_data;
	end

	
	assign MemData = (MemRead) ? mem[address] : 32'bx;
		
	endmodule