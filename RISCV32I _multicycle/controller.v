module controller(
input [4:0]state,
output reg RegWrite,ALUSrcA,MemRead,MemWrite,IorD,IRWrite,PCWrite,
output reg[1:0] ALUOp, ALUSrcB, PCSource,
output reg[2:0] MemtoReg,
output reg[5:0] PcWriteCond );

	
	always@(*)
	begin
		case(state)
		5'd0	: begin
					PCWrite = 1'b1;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b1;
					MemWrite = 1'b0;
					IRWrite = 1'b1;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b0;
					RegWrite = 1'b0; 
					ALUOp = 2'b00;
					ALUSrcB = 2'b01;
					PCSource = 2'b00;
					end
				
		5'd1	: begin
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b0;	
					RegWrite = 1'b0;  
					ALUOp = 2'b00;
					ALUSrcB = 2'b10;  
					PCSource = 2'b00;
					end
				
		5'd2	: begin
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;//0
					ALUOp = 2'b00;
					ALUSrcB = 2'b10;
					PCSource = 2'b00;
					end
				
		5'd3	: begin
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b1;
					MemRead = 1'b1;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b0;
					RegWrite = 1'b0;
					ALUOp = 2'b00;
					ALUSrcB = 2'b00;
					PCSource = 2'b00;
					end
					
				
		5'd4	: begin                      //load
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b001;
					ALUSrcA = 1'b0;
					RegWrite = 1'b1;
					ALUOp = 2'b00;
					ALUSrcB = 2'b00;
					PCSource = 2'b00;
					end
					
		5'd5	: begin                          //store
					PcWriteCond = 6'b000000;
					IorD = 1'b1;
					MemRead = 1'b0;
					MemWrite = 1'b1;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b0;
					RegWrite = 1'b0;
					ALUOp = 2'b00;
					ALUSrcB = 2'b00;
					PCSource = 2'b00;
					end
				
		5'd6	: begin									//R-type
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b10;
					ALUSrcB = 2'b00;
					PCSource = 2'b00;
					end
				
		5'd7	: begin 
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b0;
					RegWrite = 1'b1;
					ALUOp = 2'b00;
					ALUSrcB = 2'b00;
					PCSource = 2'b00;
					end
			
		5'd8	: begin 							//BEQ
					PCWrite = 1'b0;
					PcWriteCond = 6'b000001;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b01;
					ALUSrcB = 2'b00;
					PCSource = 2'b10; 
					end
				
		5'd9	: begin                             //immediate
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b10;
					ALUSrcB = 2'b10;
					PCSource = 2'b00;
					end
					
		5'd10	: begin
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b0;
					RegWrite = 1'b1;
					ALUOp = 2'b00;
					ALUSrcB = 2'b00;
					PCSource = 2'b00;
					end
					
		5'd11	: begin								//JAL pc=pc+imm , rd = pc +4
					PCWrite = 1'b1;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b011;
					ALUSrcA = 1'b0;
					RegWrite = 1'b1;
					ALUOp = 2'b00;
					ALUSrcB = 2'b01;   
					PCSource = 2'b10;		
					end
					
		5'd12	: begin								//JALr pc=rs1+imm
					PCWrite = 1'b1;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b00;
					ALUSrcB = 2'b10;   
					PCSource = 2'b00;  
					end
		
		5'd13	: begin                             //SB
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b1;
					MemRead = 1'b0;
					MemWrite = 1'b1;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b0;
					RegWrite = 1'b0;
					ALUOp = 2'b00;
					ALUSrcB = 2'b00;
					PCSource = 2'b00;
					end
					
		5'd14 : begin                            //SH
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b1;
					MemRead = 1'b0;
					MemWrite = 1'b1;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b0;
					RegWrite = 1'b0;
					ALUOp = 2'b00;
					ALUSrcB = 2'b00;
					PCSource = 2'b00;
					end
					
		5'd15	: begin 							//BNE
					PCWrite = 1'b0;
					PcWriteCond = 6'b000010;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b01;
					ALUSrcB = 2'b00;
					PCSource = 2'b10; 
					end
					
		5'd16	: begin 							//BLT
					PCWrite = 1'b0;
					PcWriteCond = 6'b000100;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b01;
					ALUSrcB = 2'b00;
					PCSource = 2'b10; 
					end
					
		5'd17	: begin 							//BGE
					PCWrite = 1'b0;
					PcWriteCond = 6'b001000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b01;
					ALUSrcB = 2'b00;
					PCSource = 2'b10;
					end
					
		5'd18	: begin 							//BLTU
					PCWrite = 1'b0;
					PcWriteCond = 6'b010000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b01;
					ALUSrcB = 2'b00;
					PCSource = 2'b10; 
					end
					
		5'd19	: begin 							//BGEU
					PCWrite = 1'b0;
					PcWriteCond = 6'b100000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b000;
					ALUSrcA = 1'b1;
					RegWrite = 1'b0;
					ALUOp = 2'b01;
					ALUSrcB = 2'b00;
					PCSource = 2'b10; 
					end
					
		5'd20	: begin 							//AUIPC
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b100;
					ALUSrcA = 1'b0;
					RegWrite = 1'b1;
					ALUOp = 2'b00;
					ALUSrcB = 2'b01;
					PCSource = 2'b00;
					end
					
					
		5'd21	: begin 							//LUI
					PCWrite = 1'b0;
					PcWriteCond = 6'b000000;
					IorD = 1'b0;
					MemRead = 1'b0;
					MemWrite = 1'b0;
					IRWrite = 1'b0;
					MemtoReg = 3'b010;
					ALUSrcA = 1'b0;
					RegWrite = 1'b1;
					ALUOp = 2'b00;
					ALUSrcB = 2'b01;
					PCSource = 2'b00;
					end
					

		default: begin
					RegWrite=1'bx;ALUSrcA=1'bx;MemRead=1'bx;MemWrite=1'bx;MemtoReg=3'bxxx;IorD=1'bx;IRWrite=1'bx;PCWrite=1'bx;PcWriteCond=6'bx;
					ALUOp=2'bxx;ALUSrcB=2'bxx;PCSource=2'bxx;
					end
		
		endcase

	end
		
endmodule		
