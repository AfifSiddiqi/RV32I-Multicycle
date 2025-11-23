module FSM(
    input clk, rst,
    input [2:0] fun3,
    input [6:0] Opcode,
    output reg [4:0] state
);

    // Parameters for opcodes
    parameter NoOp   = 7'b0000000;
    parameter LOAD   = 7'b0000011;
    parameter STORE  = 7'b0100011;
    parameter R      = 7'b0110011;
    parameter BRANCH = 7'b1100011;
    parameter IMM    = 7'b0010011;
    parameter JALR   = 7'b1100111;
    parameter JAL    = 7'b1101111;
    parameter LUI    = 7'b0110111;
    parameter AUIPC  = 7'b0010111;
    
    reg [4:0] next_state;
    
    // Sequential logic: State register
    always @(posedge clk or negedge rst) begin  
        if (!rst)
            state <= 5'd0;
        else
            state <= next_state;
    end
    
    // Combinational logic: Next state logic
    always @(*) begin
        // Default assignment to avoid latches
        next_state = 5'd0;
        
        case (state)
            5'd0: next_state = 5'd1;
            
            5'd1: begin
                // Instruction decode and dispatch
                if (Opcode == NoOp)
                    next_state = 5'd0;
                else if (Opcode == LOAD || Opcode == STORE)
                    next_state = 5'd2;
                else if (Opcode == R)
                    next_state = 5'd6;
                else if (Opcode == BRANCH) begin
                    case(fun3)
                        3'b000: next_state = 5'd8;   // beq
                        3'b001: next_state = 5'd13;  // bne
                        3'b100: next_state = 5'd14;  // blt
                        3'b101: next_state = 5'd15;  // bge
                        3'b110: next_state = 5'd16;  // bltu
                        3'b111: next_state = 5'd17;  // bgeu
                        default: next_state = 5'd0;
                    endcase
                end
                else if (Opcode == IMM)
                    next_state = 5'd9;
                else if (Opcode == JAL)
                    next_state = 5'd11;
                else if (Opcode == JALR)
                    next_state = 5'd12;
                else if (Opcode == AUIPC)
                    next_state = 5'd18;
                else if (Opcode == LUI)
                    next_state = 5'd19;
                else
                    next_state = 5'd0;
            end
            
            5'd2: begin
                // Memory address calculation done
                if (Opcode == LOAD)
                    next_state = 5'd3;
                else if (Opcode == STORE)
                    next_state = 5'd5;
                else
                    next_state = 5'd0;
            end
            
            5'd3: next_state = 5'd4;   // Load: Memory read
            5'd6: next_state = 5'd7;   // R-type: Execute
            5'd9:  next_state = 5'd10; // I-type: Execute
            default: next_state = 5'd0;
        endcase
    end
    
endmodule
