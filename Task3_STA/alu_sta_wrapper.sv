module alu_sta_wrapper (
    input  logic       clk,
    input  logic       reset,
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic [2:0] op,
    output logic [7:0] result,
    output logic       zero,
    output logic       carry
);

    logic [7:0] A_reg;
    logic [7:0] B_reg;
    logic [2:0] op_reg;

    logic [7:0] alu_result;
    logic       alu_zero;
    logic       alu_carry;

    // Input registers
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            A_reg  <= 8'b0;
            B_reg  <= 8'b0;
            op_reg <= 3'b0;
        end
        else begin
            A_reg  <= A;
            B_reg  <= B;
            op_reg <= op;
        end
    end

    // ALU
    alu_8bit u_alu (
        .A(A_reg),
        .B(B_reg),
        .op(op_reg),
        .result(alu_result),
        .zero(alu_zero),
        .carry(alu_carry)
    );

    // Output registers
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            result <= 8'b0;
            zero   <= 1'b1;
            carry  <= 1'b0;
        end
        else begin
            result <= alu_result;
            zero   <= alu_zero;
            carry  <= alu_carry;
        end
    end

endmodule