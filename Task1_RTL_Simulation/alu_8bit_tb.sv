`timescale 1ns/1ps

module alu_8bit_tb;

    logic [7:0] A;
    logic [7:0] B;
    logic [2:0] op;

    logic [7:0] result;
    logic       zero;
    logic       carry;

    integer pass_count;
    integer fail_count;

    integer op_count [0:7];

    logic [7:0] expected_result;
    logic       expected_zero;
    logic       expected_carry;

    // DUT
    alu_8bit dut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    // Reference model
    task automatic calculate_expected;

        logic [8:0] temp;

        begin
            expected_result = 8'b0;
            expected_carry  = 1'b0;
            temp            = 9'b0;

            case (op)

                3'b000: begin
                    temp = {1'b0,A} + {1'b0,B};
                    expected_result = temp[7:0];
                    expected_carry  = temp[8];
                end

                3'b001: begin
                    expected_result = A - B;
                    expected_carry  = (A >= B);
                end

                3'b010:
                    expected_result = A & B;

                3'b011:
                    expected_result = A | B;

                3'b100:
                    expected_result = A ^ B;

                3'b101:
                    expected_result = ~A;

                3'b110: begin
                    expected_result = A << 1;
                    expected_carry  = A[7];
                end

                3'b111: begin
                    expected_result = A >> 1;
                    expected_carry  = A[0];
                end

            endcase

            expected_zero = (expected_result == 8'b0);
        end

    endtask


    // Checker
    task automatic check_result;

        begin

            calculate_expected();

            #1;

            if ((result === expected_result) &&
                (zero   === expected_zero)   &&
                (carry  === expected_carry)) begin

                pass_count = pass_count + 1;

                $display(
                    "PASS | A=%02h B=%02h OP=%03b RESULT=%02h ZERO=%b CARRY=%b",
                    A, B, op, result, zero, carry
                );

            end
            else begin

                fail_count = fail_count + 1;

                $display(
                    "FAIL | A=%02h B=%02h OP=%03b | Expected=%02h Z=%b C=%b | Got=%02h Z=%b C=%b",
                    A, B, op,
                    expected_result,
                    expected_zero,
                    expected_carry,
                    result,
                    zero,
                    carry
                );

            end

            op_count[op] = op_count[op] + 1;

        end

    endtask


    // Directed tests
    task automatic directed_tests;

        begin

            $display("");
            $display("======================================");
            $display("        DIRECTED TESTS");
            $display("======================================");

            // ADD
            A = 8'h05;
            B = 8'h03;
            op = 3'b000;
            check_result();

            // ADD overflow
            A = 8'hFF;
            B = 8'h01;
            op = 3'b000;
            check_result();

            // SUB
            A = 8'h09;
            B = 8'h04;
            op = 3'b001;
            check_result();

            // AND
            A = 8'hAA;
            B = 8'h55;
            op = 3'b010;
            check_result();

            // OR
            A = 8'hAA;
            B = 8'h55;
            op = 3'b011;
            check_result();

            // XOR
            A = 8'hAA;
            B = 8'h55;
            op = 3'b100;
            check_result();

            // NOT
            A = 8'hF0;
            B = 8'h00;
            op = 3'b101;
            check_result();

            // Shift Left
            A = 8'h81;
            B = 8'h00;
            op = 3'b110;
            check_result();

            // Shift Right
            A = 8'h81;
            B = 8'h00;
            op = 3'b111;
            check_result();

            // Zero result
            A = 8'h55;
            B = 8'h55;
            op = 3'b100;
            check_result();

        end

    endtask


    // Random tests
    task automatic random_tests;

        integer i;

        begin

            $display("");
            $display("======================================");
            $display("         RANDOM TESTS");
            $display("======================================");

            for (i = 0; i < 100; i = i + 1) begin

                A  = $urandom_range(0,255);
                B  = $urandom_range(0,255);
                op = $urandom_range(0,7);

                check_result();

            end

        end

    endtask


    // Coverage report
    task automatic coverage_report;

        integer i;

        begin

            $display("");
            $display("======================================");
            $display("        COVERAGE REPORT");
            $display("======================================");

            for (i = 0; i < 8; i = i + 1) begin

                $display(
                    "Operation %03b executed %0d times",
                    i,
                    op_count[i]
                );

            end

            $display("");
            $display("Total PASS = %0d", pass_count);
            $display("Total FAIL = %0d", fail_count);

            if (fail_count == 0)
                $display("STATUS = ALL TESTS PASSED");
            else
                $display("STATUS = TEST FAILURE DETECTED");

            $display("======================================");

        end

    endtask


    // Main test
    initial begin

        pass_count = 0;
        fail_count = 0;

        for (integer i = 0; i < 8; i = i + 1)
            op_count[i] = 0;

        A  = 8'b0;
        B  = 8'b0;
        op = 3'b000;

        directed_tests();

        random_tests();

        coverage_report();

        #10;

        $finish;

    end

endmodule