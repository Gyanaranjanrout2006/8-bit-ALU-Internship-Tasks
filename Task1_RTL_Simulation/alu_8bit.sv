module alu_8bit (
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic [2:0] op,
    output logic [7:0] result,
    output logic       zero,
    output logic       carry
);

    logic [8:0] temp;

    always_comb begin
        result = 8'b0;
        carry  = 1'b0;
        temp   = 9'b0;

        case (op)

            3'b000: begin
                // ADD
                temp   = {1'b0, A} + {1'b0, B};
                result = temp[7:0];
                carry  = temp[8];
            end

            3'b001: begin
                // SUB
                result = A - B;
                carry  = (A >= B);
            end

            3'b010: begin
                // AND
                result = A & B;
            end

            3'b011: begin
                // OR
                result = A | B;
            end

            3'b100: begin
                // XOR
                result = A ^ B;
            end

            3'b101: begin
                // NOT A
                result = ~A;
            end

            3'b110: begin
                // SHIFT LEFT
                result = A << 1;
                carry  = A[7];
            end

            3'b111: begin
                // SHIFT RIGHT
                result = A >> 1;
                carry  = A[0];
            end

            default: begin
                result = 8'b0;
                carry  = 1'b0;
            end

        endcase

        zero = (result == 8'b0);
    end

endmodule