module controller(
    input  [4:0] state,
    output reg RegWrite,
    output reg ALUSrcA,
    output reg MemRead,
    output reg MemWrite,
    output reg IorD,
    output reg IRWrite,
    output reg PCWrite,
    output reg [1:0] ALUOp,
    output reg [1:0] ALUSrcB,
    output reg [1:0] PCSource,
    output reg [1:0] MemtoReg,
    output reg [5:0] PcWriteCond
);

    always @(*) begin
        // Default values
        RegWrite   = 0;
        ALUSrcA    = 0;
        MemRead    = 0;
        MemWrite   = 0;
        IorD       = 0;
        IRWrite    = 0;
        PCWrite    = 0;
        ALUOp      = 2'b00;
        ALUSrcB    = 2'b00;
        PCSource   = 2'b00;
        MemtoReg   = 2'b00;
        PcWriteCond = 6'b000000;

        case (state)

            // ==========================
            // Instruction Fetch
            // ==========================
            5'd0: begin
                PCWrite  = 1;
                MemRead  = 1;
                IRWrite  = 1;
                ALUSrcB  = 2'b01;
            end

            // ==========================
            // Decode
            // ==========================
            5'd1: begin
                ALUSrcB = 2'b10;
            end

            // ==========================
            // Effective Address Calc
            // ==========================
            5'd2: begin
                ALUSrcA = 1;
                ALUSrcB = 2'b10;
            end

            // ==========================
            // Memory Read
            // ==========================
            5'd3: begin
                IorD    = 1;
                MemRead = 1;
            end

            // ==========================
            // Load Write-Back
            // ==========================
            5'd4: begin
                RegWrite = 1;
                MemtoReg = 2'b01;
            end

            // ==========================
            // Store
            // ==========================
            5'd5: begin
                IorD     = 1;
                MemWrite = 1;
            end

            // ==========================
            // R‑type ALU Execute
            // ==========================
            5'd6: begin
                ALUSrcA = 1;
                ALUOp   = 2'b10;
            end

            // ==========================
            // R‑Type Write Back
            // ==========================
            5'd7: begin
                RegWrite = 1;
            end

            // ==========================
            // BEQ
            // ==========================
            5'd8: begin
                ALUSrcA = 1;
                ALUOp   = 2'b01;
                PCSource = 2'b10;
                PcWriteCond = 6'b000001;
            end

            // ==========================
            // Immediate ALU Execute
            // ==========================
            5'd9: begin
                ALUSrcA = 1;
                ALUSrcB = 2'b10;
                ALUOp   = 2'b10;
            end

            // ==========================
            // Immediate Write Back
            // ==========================
            5'd10: begin
                RegWrite = 1;
            end

            // ==========================
            // JAL
            // ==========================
            5'd11: begin
                PCWrite  = 1;
                RegWrite = 1;
                PCSource = 2'b10;
                ALUSrcB  = 2'b01;
            end

            // ==========================
            // JALR
            // ==========================
            5'd12: begin
                PCWrite  = 1;
                RegWrite = 1;
                PCSource = 2'b11;
                ALUSrcB  = 2'b01;
            end

            // ==========================
            // BNE
            // ==========================
            5'd13: begin
                ALUSrcA = 1;
                ALUOp = 2'b01;
                PCSource = 2'b10;
                PcWriteCond = 6'b000010;
            end

            // ==========================
            // BLT
            // ==========================
            5'd14: begin
                ALUSrcA = 1;
                ALUOp = 2'b01;
                PCSource = 2'b10;
                PcWriteCond = 6'b000100;
            end

            // ==========================
            // BGE
            // ==========================
            5'd15: begin
                ALUSrcA = 1;
                ALUOp = 2'b01;
                PCSource = 2'b10;
                PcWriteCond = 6'b001000;
            end

            // ==========================
            // BLTU
            // ==========================
            5'd16: begin
                ALUSrcA = 1;
                ALUOp = 2'b01;
                PCSource = 2'b10;
                PcWriteCond = 6'b010000;
            end

            // ==========================
            // BGEU
            // ==========================
            5'd17: begin
                ALUSrcA = 1;
                ALUOp = 2'b01;
                PCSource = 2'b10;
                PcWriteCond = 6'b100000;
            end

            // ==========================
            // AUIPC
            // ==========================
            5'd18: begin
                RegWrite = 1;
                ALUSrcB  = 2'b01;
                MemtoReg = 2'b11;
            end

            // ==========================
            // LUI
            // ==========================
            5'd19: begin
                RegWrite = 1;
                ALUSrcB  = 2'b01;
                MemtoReg = 2'b10;
            end

            // ==========================
            // Default
            // ==========================
            default: begin
                RegWrite   = 1'bx;
                ALUSrcA    = 1'bx;
                MemRead    = 1'bx;
                MemWrite   = 1'bx;
                IorD       = 1'bx;
                IRWrite    = 1'bx;
                PCWrite    = 1'bx;
                ALUOp      = 2'bxx;
                ALUSrcB    = 2'bxx;
                PCSource   = 2'bxx;
                MemtoReg   = 3'bxxx;
                PcWriteCond = 6'bxxxxxx;
            end
        endcase
    end

endmodule
