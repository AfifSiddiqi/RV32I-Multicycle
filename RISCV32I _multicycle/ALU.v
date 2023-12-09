module ALU (ALUctl, A, B, ALUOut, Zero, n_zero, less_than, greater_than, less_than_u, greater_than_u);
input [3:0] ALUctl;
input [31:0] A,B;
output reg [31:0] ALUOut;
output Zero,n_zero,less_than,greater_than,less_than_u,greater_than_u;

assign Zero = (ALUOut==0); //Zero is true if ALUOut is 0
assign n_zero = (ALUOut!=0) ? 1 : 0; //n_Zero is true if ALUOut is not 0
assign less_than = ($signed(A) < $signed(B)) ? 1 : 0; //less_than is true if A is less than B
assign greater_than = ($signed(A)>$signed(B) | $signed(A)==$signed(B)) ? 1 : 0; //greater_than is true if A is greater than B
assign less_than_u = (A < B) ? 1 : 0; //less_than is true if A is less than B (Unsigned)
assign greater_than_u = (A>B | A==B) ? 1 : 0; //greater_than is true if A is greater than B (Unsigned)

wire shamt = B[4:0]; 

always @(ALUctl, A, B) //reevaluate if these change
case (ALUctl)
0: ALUOut = A & B;
1: ALUOut = A | B;
2: ALUOut = A + B;
6: ALUOut = A - B;
7: ALUOut = (A < B) ? 1 : 0; // sltu
12: ALUOut = ~(A | B); // result is nor 

11: ALUOut = A ^ B; // result is xor 

3: ALUOut = A << B; // sll
4: ALUOut = A >> B; // srl
5: ALUOut = $signed(A) >>> B; // sra 

8: ALUOut = A << shamt; // slli
9: ALUOut = A >> shamt; // srli
10: ALUOut = $signed(A) >>> shamt; // srai

15: ALUOut = $signed(A) < $signed(B) ? 1 : 0; // slt

default: ALUOut = 0; //default to 0. should not happen;
endcase
endmodule