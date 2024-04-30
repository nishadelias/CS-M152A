
module FPCVT(
    input [11:0] A,
    output S,
    output [2:0] E,
    output [3:0] F
);
    wire [11:0] result;
    wire [7:0] exp_mant_bit;
    wire [7:0] rounded;

    SignedMagnitudeConverter smc(A, result);
    ExponentMantissaCalculator emc(result, exp_mant_bit);
    Rounding rounder(exp_mant_bit, rounded);

    assign S = rounded[7];
    assign E = rounded[6:4];
    assign F = rounded[3:0];
    
endmodule

module SignedMagnitudeConverter(
    input [11:0] A,
    output reg [12:0] signed_mag
);
    always @* begin
        signed_mag[12] = A[11];  // Sign bit
        if (A == 12'b100000000000) begin
            signed_mag = 13'b1011111111111;
        end else begin
            signed_mag[11:0] = (A[11] == 1'b1) ? (~A + 1'b1) : A;
        end
    end
endmodule

module ExponentMantissaCalculator(
    input [11:0] magnitude,
    output reg [7:0] exponent_mantissa_bit
);
    integer i;
    always @* begin
        i = 10;
        while (magnitude[i] != 1 && i > 3) begin
            i = i - 1;
        end
        exponent_mantissa_bit[7:5] = i - 3;
        if (i < 4) begin
            exponent_mantissa_bit[4:0] = {magnitude[3:0], 1'b0};
        end else begin
            exponent_mantissa_bit[4:0] = magnitude[i: i-4];
        end
    end
endmodule

module Rounding(
    input [7:0] exp_mant_bit,
    output [7:0] floating
);
    // the line below is temporary
    assign floating = exp_mant_bit;
endmodule
