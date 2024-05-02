`timescale 1ns / 1ps

module tb;

    // Inputs
    reg [11:0] D;

    // Outputs
    wire S;
    wire [2:0] E;
    wire [3:0] F;

    // Instantiate the  (UUT)
    FPCVT uut (
        .D(D), 
        .S(S), 
        .E(E), 
        .F(F)
    );

    initial begin
        D = 12'b0;

        // Wait for global reset
        #100;

        // Test 1: Positive number
        D = 12'b010110011001; // Random positive number
        #10; // Wait 10ns for changes to be reflected in outputs
        
        // Test 2: Negative number
        D = 12'b101001110010; // Random negative number
        #10;
        
        // Test 3: Smallest negative number
        D = 12'b100000000000; // -2048 in two's complement
        #10;
        
        // Test 4: Positive number with rounding
        D = 12'b010101011111;
        #10;
        
        // Test 5: Corner case of rounding
        D = 12'b001111100000;
        #10;
        
        // Add more tests if required...
        
        // End simulation
        $finish; // Terminate simulation
    end
      
endmodule
