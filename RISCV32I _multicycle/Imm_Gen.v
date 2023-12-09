module Imm_Gen (Inst_In,Inst_Out);

    input [31:0]Inst_In;
    output reg [31:0]Inst_Out;
	 wire [6:0]opcode;
	 
	 assign opcode = Inst_In[6:0];
	 
	 always@(*)
	 begin
		 case(opcode)
		 //store
		 7'b0100011 : Inst_Out = {{20{Inst_In[31]}},Inst_In[31:25],Inst_In[11:7]};
		 
		 //branch
		 7'b1100011 : Inst_Out = {{20{Inst_In[31]}}, Inst_In[7], Inst_In[30:25], Inst_In[11:8], 1'b0};
		 
		 //jal
		 7'b1101111 : Inst_Out = {{12{Inst_In[31]}}, Inst_In[19:12], Inst_In[20], Inst_In[30:21], 1'b0};

		 //auipc
		 7'b0010111 : Inst_Out = {Inst_In[31:12], 12'b0};
		 
		 //any other
		 default : Inst_Out = {{20{Inst_In[31]}},Inst_In[31:20]};
		 endcase
	 end

endmodule