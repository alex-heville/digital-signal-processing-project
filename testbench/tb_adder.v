// Testbench for 16-bit adder
`timescale 1ns/1ps

module tb_adder;
    reg [15:0] a;
    reg [15:0] b;
    reg cin;
    wire [15:0] sum;
    wire cout;
    
    // Instantiate the adder under test (currently ripple_carry_adder)
    ripple_carry_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );
    
    // Expected outputs
    wire [16:0] expected;
    assign expected = a + b + cin;
    
    integer i;
    integer errors = 0;
    
    initial begin
        // Initialize inputs
        a = 0;
        b = 0;
        cin = 0;
        
        // Test random vectors
        $display("Starting 16-bit adder test...");
        for (i = 0; i < 1000; i = i + 1) begin
            a = $random;
            b = $random;
            cin = $random & 1;
            #10; // wait for propagation
            
            if (sum !== expected[15:0] || cout !== expected[16]) begin
                $display("Error: a=%h, b=%h, cin=%b, sum=%h (expected %h), cout=%b (expected %b)",
                    a, b, cin, sum, expected[15:0], cout, expected[16]);
                errors = errors + 1;
            end
        end
        
        // Edge cases
        a = 16'hFFFF; b = 16'h0001; cin = 1'b0; #10;
        if (sum !== 16'h0000 || cout !== 1'b1) begin
            $display("Error: edge case 1 failed");
            errors = errors + 1;
        end
        
        a = 16'h0000; b = 16'h0000; cin = 1'b1; #10;
        if (sum !== 16'h0001 || cout !== 1'b0) begin
            $display("Error: edge case 2 failed");
            errors = errors + 1;
        end
        
        // Summary
        if (errors == 0) begin
            $display("All tests passed!");
        end else begin
            $display("Test failed with %d errors", errors);
        end
        $finish;
    end
    
endmodule