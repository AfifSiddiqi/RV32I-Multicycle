module register_file
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)
(
	input [(DATA_WIDTH-1):0] write_data,
	input [(ADDR_WIDTH-1):0] rs1, rs2, rd,
	input we, clk, rst,
	output [(DATA_WIDTH-1):0] read_data1, read_data2
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	integer i;
	
	always @ (posedge clk, negedge rst)
	begin
		if(~rst) begin
			for (i=0; i< 2**ADDR_WIDTH; i=i+1)
				ram[i] <= 32'd0;
		end
		// Write
		// else if (we)
		else if (we && (rd != 5'd0))
			ram[rd] <= write_data;

		// Read (if read_addr == write_addr, return OLD data).	To return
		// NEW data, use = (blocking write) rather than <= (non-blocking write)
		// in the write assignment.	 NOTE: NEW data may require extra bypass
		// logic around the RAM.
		
		
	end

		assign read_data1 = ram[rs1];
		assign read_data2 = ram[rs2];

endmodule
