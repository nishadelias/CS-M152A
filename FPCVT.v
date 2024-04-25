module FPCVT(D,S,E,F);
input [11:0] D;
output S;
output [2:0] E;
output [3:0] F;
reg [11:0] magnitude;
reg sign;
reg [11:0] result;
reg [7:0] exp_mant_bit;
integer A = 12'b001011100000;



initial begin
    result = signed_mag(A);
    #10 $display("result= %b", result);
    #15 exp_mant_bit = exponent_mantissa_bit(result[11:0]);
    #20 $display("result= %b", exp_mant_bit);
    
    
    
    
end

function [12:0] signed_mag;
input [11:0] A;
begin
    sign = A[11];
    
    $display("Sign= %b", sign);
    if (sign == 1) begin
        magnitude = ~A[11:0] + 1;
    end else begin
        magnitude = A[11:0];
    end
    if (A == 12'b100000000000) begin
        signed_mag = 13'b1011111111111;
    end else begin
        signed_mag = {sign, magnitude};
    end
end
endfunction

function [7:0] exponent_mantissa_bit;
input [11:0] magnitude;
integer i;
begin
    i = 10;
    while(magnitude[i] != 1 && i > 3) begin
        i = i - 1;
    end
    exponent_mantissa_bit[7:5] = i-3;
    if (i < 4) begin
        exponent_mantissa_bit[4:0] = {magnitude[3:0],0};
    end else begin
        magnitude = magnitude >> (i-4);
        exponent_mantissa_bit[4:0] = magnitude[4:0];
    end
end
endfunction
endmodule

module rounding(exp_mant_bit, floating);
input [7:0] exp_mant_bit;
output [7:0] floating

endmodule




