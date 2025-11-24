module RISCV32I(
    input           clk_in,
    input           rst_in,
    output [31:0]   address,
    output [31:0]   data_out,
    output          r_en_mem,
    output          w_en_mem,
    input  [31:0]   MemData
);

    //--------------------------------------------------------------------------
    // Internal wires
    //--------------------------------------------------------------------------
    wire [31:0] PC_out;
    wire [31:0] alu_result, rs1_out, rs2_out, memout;
    wire [31:0] A_out, B_out, alu_result_reg;
    wire [31:0] inst_out_reg, MDR_out;
    wire [31:0] mux_out1, mux_out2, mux_out3, mux_out4, mux_out5;
    wire [31:0] inst_out_imm;

    wire         w_en_regfile;
    wire         IorD, alusrcA, Irwrite;
    wire         zero, nzero, less, greater, lessun, greaterun;
    wire         pcwrite, pc_en;

    wire [1:0]   aluop;
    wire [1:0]   alusrcB;
    wire [1:0]   pcsource;
    wire [1:0]   memtoreg;

    wire [3:0]   alu_contrl;
    wire [4:0]   state_out;
    wire [5:0]   pcwritecond;

    wire [31:0]  jal, jalr, store_out, auipc, load_out;
    wire         a_n_d_1, a_n_d_2, a_n_d_3, a_n_d_4, a_n_d_5, a_n_d_6;

    //--------------------------------------------------------------------------
    // Simple assigns / small arithmetic conversions
    //--------------------------------------------------------------------------

    assign memout = MemData;

    // jal  = PC + immediate
    assign jal   = ((PC_out - 32'd4) + inst_out_imm);
    // jalr = rs1 + immediate
    assign jalr  = (A_out + inst_out_imm);
    // auipc = PC + immediate (upper immediate already aligned in Imm_Gen)
    assign auipc = ((PC_out - 32'd4) + inst_out_imm);

    //--------------------------------------------------------------------------
    // Module instantiations
    //--------------------------------------------------------------------------

    PC pc (
        .clk    (clk_in),
        .rst    (rst_in),
        .pc_in  (mux_out5),
        .PCWrite(pc_en),
        .pc_out (PC_out)
    );

    mux mux1 (
        .a (PC_out),
        .b (alu_result_reg),
        .s (IorD),
        .c (mux_out1)
    );

    store_unit store_unit_inst (
        .int_in (B_out),
        .fu3    (inst_out_reg[14:12]),
        .int_out(store_out)
    );

    register_en inst_reg (
        .clk   (clk_in),
        .reset (rst_in),
        .en    (Irwrite),
        .d     (memout),
        .q     (inst_out_reg)
    );

    register Mem_data_reg (
        .clk   (clk_in),
        .reset (rst_in),
        .d     (memout),
        .q     (MDR_out)
    );

    mux_4x1 mux2 (
        .a (alu_result_reg),
        .b (load_out),                         // load result
        .c ({inst_out_reg[31:12], 12'b0}),     // LUI
        .d (auipc),                            // AUIPC
        .s (memtoreg),
        .q (mux_out2)
    );

    load_unit load_unit_inst (
        .clock       (clk_in),
        .reset       (rst_in),
        .int_in_load (MDR_out),
        .fu3         (inst_out_reg[14:12]),
        .addr        (mux_out1[1:0]),
        .int_out_load(load_out)
    );

    register_file reg_file (
        .write_data (mux_out2),
        .rs1        (inst_out_reg[19:15]),
        .rs2        (inst_out_reg[24:20]),
        .rd         (inst_out_reg[11:7]),
        .we         (w_en_regfile),
        .clk        (clk_in),
        .rst        (rst_in),
        .read_data1 (rs1_out),
        .read_data2 (rs2_out)
    );

    Imm_Gen imm_gen (
        .Inst_In  (inst_out_reg),
        .Inst_Out (inst_out_imm)
    );

    register Areg (
        .clk   (clk_in),
        .reset (rst_in),
        .d     (rs1_out),
        .q     (A_out)
    );

    register Breg (
        .clk   (clk_in),
        .reset (rst_in),
        .d     (rs2_out),
        .q     (B_out)
    );

    mux mux3 (
        .a (PC_out),
        .b (A_out),
        .s (alusrcA),
        .c (mux_out3)
    );

    mux_4x1 mux4 (
        .a (B_out),
        .b (32'd4),
        .c (inst_out_imm),
        .s (alusrcB),
        .q (mux_out4)
    );

    ALUControl alu_control (
        .ALUOp  (aluop),
        .funct3 (inst_out_reg[14:12]),
        .funct7 (inst_out_reg[31:25]),
        .OP     (inst_out_reg[6:0]),
        .ALUCtl (alu_contrl)
    );

    ALU alu (
        .ALUctl         (alu_contrl),
        .A              (mux_out3),
        .B              (mux_out4),
        .ALUOut         (alu_result),
        .Zero           (zero),
        .n_zero         (nzero),
        .less_than      (less),
        .greater_than   (greater),
        .less_than_u    (lessun),
        .greater_than_u (greaterun)
    );

    register ALUoutreg (
        .clk   (clk_in),
        .reset (rst_in),
        .d     (alu_result),
        .q     (alu_result_reg)
    );

    mux_4x1 mux5 (
        .a (alu_result),
        .b (alu_result_reg),
        .c ({jal}),
        .d ({jalr}),
        .s (pcsource),
        .q (mux_out5)
    );

    FSM fsm (
        .clk    (clk_in),
        .rst    (rst_in),
        .Opcode (inst_out_reg[6:0]),
        .fun3   (inst_out_reg[14:12]),
        .state  (state_out)
    );

    controller contrller (
        .state       (state_out),
        .RegWrite    (w_en_regfile),
        .ALUSrcA     (alusrcA),
        .MemRead     (r_en_mem),
        .MemWrite    (w_en_mem),
        .MemtoReg    (memtoreg),
        .IorD        (IorD),
        .IRWrite     (Irwrite),
        .PCWrite     (pcwrite),
        .PcWriteCond (pcwritecond),
        .ALUOp       (aluop),
        .ALUSrcB     (alusrcB),
        .PCSource    (pcsource)
    );

    //--------------------------------------------------------------------------
    // pc enable logic (based on condition flags and controller mask)
    //--------------------------------------------------------------------------

    assign a_n_d_1 = zero & pcwritecond[0];
    assign a_n_d_2 = nzero & pcwritecond[1];
    assign a_n_d_3 = less & pcwritecond[2];
    assign a_n_d_4 = greater & pcwritecond[3];
    assign a_n_d_5 = lessun & pcwritecond[4];
    assign a_n_d_6 = greaterun & pcwritecond[5];

	assign pc_en = a_n_d_1 | a_n_d_2 |a_n_d_3 |a_n_d_4 |a_n_d_5 |a_n_d_6 | pcwrite;

    //--------------------------------------------------------------------------
    // Top-level outputs
    //--------------------------------------------------------------------------

    assign address  = mux_out1;
    assign data_out = store_out;

endmodule



