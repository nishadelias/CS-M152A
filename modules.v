module FPCVT(D,S,E,F);
input [11:0] D;
output S;
output [2:0] E;
output [3:0] F;
wire [11:0] magnitude;
wire sign;
wire [7:0] exp_mant_bit;
wire [6:0] final_result;

signed_mag s(D,sign,magnitude);
exponent_mantissa_bit emb(magnitude, exp_mant_bit);
rounding r(exp_mant_bit, final_result);

assign S = sign;
assign E = final_result[6:4];
assign F = final_result[3:0];

//always @(final_result) begin
//    $display("final result= %b ", final_result);
//    end
//always @(sign, magnitude) begin
//    $display("sign= %b ", sign);
//    $display("magnitude= %b ", magnitude);
//end
//always @ (exp_mant_bit) begin
//    $display("emb= %b ", exp_mant_bit);
//end
endmodule

module signed_mag(A, s, m);
input [11:0] A;
output reg s;
output reg [11:0] m;

always @* begin
    assign s = A[11];
    
    if (s == 1) begin
        assign m = ~A[11:0] + 1;
    end else begin
        assign m = A[11:0];
    end
    if (A == 12'b100000000000) begin
        assign s = 1;
        assign m = 12'b011111111111;
    end
end
endmodule

module exponent_mantissa_bit(magnitude, exponent_mantissa_bit);
input [11:0] magnitude;
output reg [7:0] exponent_mantissa_bit;
reg [11:0] temp;
integer i;
always @ (*) begin
    i = 10;
    while(magnitude[i] != 1 && i > 3) begin
        i = i - 1;
    end
    exponent_mantissa_bit[7:5] = i-3;
    if (i < 4) begin
        exponent_mantissa_bit[4:1] = magnitude[3:0];
        exponent_mantissa_bit [0] = 0;
    end else begin
        temp = magnitude;
        temp = temp >> (i-4);
        exponent_mantissa_bit[4:0] = temp[4:0];
    end
end
endmodule

module rounding(exp_mant_bit, floating);
input [7:0] exp_mant_bit;
output reg [6:0] floating;
reg [2:0] new_exp;
reg [3:0] new_mant;

always @* begin
    new_exp = exp_mant_bit[7:5];
    new_mant = exp_mant_bit[4:1];

    if (exp_mant_bit == 8'b11111111) begin
        assign floating = 7'b1111111;

    end else if (exp_mant_bit[0] == 0) begin
        assign floating = exp_mant_bit[7:1];
    
    end else begin
        if (exp_mant_bit[4:1] == 4'b1111) begin
            new_mant = 4'b1000;
            new_exp = new_exp + 1;
        end else begin
            new_mant = new_mant + 1;
        end
        assign floating = {new_exp, new_mant};
    end
end
endmodule



