module FSM(
input clk,rst,
input [2:0] fun3,
input [6:0] Opcode,
output reg [4:0] state);

// create a dictionary here for readability
	parameter NoOp  = 7'b0000000;
	parameter LOAD  = 7'b0000011;
	parameter STORE = 7'b0100011;
	parameter R     = 7'b0110011;
	parameter BRANCH = 7'b1100011;
	parameter IMM   = 7'b0010011;
	parameter JALR  = 7'b1100111;
	parameter JAL   = 7'b1101111;
	parameter LUI   = 7'b0110111;
	parameter AUIPC = 7'b0010111; 
	
	
	always @(posedge clk or negedge rst)
		begin
		if (!rst)
			begin
			state <= 5'd0;
			end
		else
			begin
			case (state)
				5'd0:	state <= 5'd1;
					
				5'd1:
					// most of the work is done here
					if (Opcode == NoOp)
						state <= 5'd0;
					else if (Opcode == LOAD | Opcode == STORE)
						state <= 5'd2;
					else if (Opcode == R)
						state <= 5'd6;
					else if (Opcode == BRANCH)
						begin
						case(fun3)
						3'b000: state <= 5'd8;  //beq
						3'b001: state <= 5'd15;	//bne
						3'b100: state <= 5'd16;	//blt
						3'b101: state <= 5'd17;	//bge
						3'b110: state <= 5'd18;	//bltu
						3'b111: state <= 5'd19;	//bgeu
						default : state <= 5'd0;
					   endcase
						end
					else if (Opcode == IMM)
						state <= 5'd9;
					else if (Opcode == JAL)
						state <= 5'd11;
					else if (Opcode == JALR)
						state <= 5'd12;
					else if (Opcode == LUI)
						state <= 5'd21;
					else if (Opcode == AUIPC)
						state <= 5'd20;
					// if we have a bad opcode go back to state 1 (NoOp)
					else
						state <= 5'd0;
				
				5'd2:
					if (Opcode == NoOp)
						state <= 5'd0;
					else if (Opcode == LOAD)
						state <= 5'd3;
					else if (Opcode == STORE)
						begin
						case(fun3)
						3'b000: state <= 5'd13; //sb
						3'b001: state <= 5'd14; //sw
						3'b010: state <= 5'd5;
						default : state <= 5'd0;
					   endcase
						end

					// if we have a bad opcode go back to state 1 (NoOp)
					else
						state <= 5'd0;
				
				5'd3: state <= 5'd4;
						
				5'd6:	state <= 5'd7;
				
				5'd9:	state <= 5'd10;  
					
				default:
					state <= 5'd0;
			endcase
			end
		end
		
endmodule		
