
module ALUControl(ALUOp,funct3,funct7,ALUCtl,OP);

    input [1:0]ALUOp;
    input [2:0]funct3;
    input [6:0]funct7,OP;
    output reg[3:0] ALUCtl;
	 
	 always@(*)
	 begin
	 case(ALUOp)
	 2'b00 : ALUCtl = 4'b0010; //add
	 2'b01 : ALUCtl = 4'b0110;  //sub
	 2'b10 : if (OP == 7'b0010011)
				begin
				case(funct3)
				3'b000 : ALUCtl = 4'b0010;		//addi
				3'b010 : ALUCtl = 4'b1111;		//slti
				3'b011 : ALUCtl = 4'b0111;		//sltiu
				3'b100 : ALUCtl = 4'b1011;		//xori
				3'b110 : ALUCtl = 4'b0001;		//ori
				3'b111 : ALUCtl = 4'b0000;		//andi
				3'b001 : ALUCtl = 4'b1000;		//slli
				3'b101 : case(funct7)
							7'b0000000 : ALUCtl = 4'b1001;	//srli
							7'b0100000 : ALUCtl = 4'b1010;	//srai
							default : ALUCtl = 4'b0000;
							endcase
				default : ALUCtl = 4'b0000;  
				endcase
				end
				
				else 
				begin
				case(funct7)
				7'b0000000 : case(funct3)
								 3'b000 : ALUCtl = 4'b0010;   //add
								 3'b001 : ALUCtl = 4'b0011;   //sll
								 3'b010 : ALUCtl = 4'b1111;   //slt
								 3'b011 : ALUCtl = 4'b0111;	//sltu
								 3'b100 : ALUCtl = 4'b1011;	//xor
								 3'b101 : ALUCtl = 4'b0100;	//srl
								 3'b110 : ALUCtl = 4'b0001;	//or
								 3'b111 : ALUCtl = 4'b0000;	//and
								 default : ALUCtl = 4'b0000;  
								 endcase
				7'b0100000 : case(funct3)
								 3'b000 : ALUCtl = 4'b0110;	//sub
								 3'b101 : ALUCtl = 4'b0101;	//sra
								 default : ALUCtl = 4'b0000;
								 endcase
				default : ALUCtl = 4'b0000; 
			   endcase
				end
				
	 default : ALUCtl = 4'b0000; 
	 endcase				
	 end 

endmodule