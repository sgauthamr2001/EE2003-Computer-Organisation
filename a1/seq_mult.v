//                              -*- Mode: Verilog -*-
// Filename        : seq-mult.v
// Description     : Sequential multiplier
// Author          : Nitin Chandrachoodan and Sai Gautham Ravipati (EE19B053)

// This implementation corresponds to a sequential multiplier, but
// most of the functionality is missing.  Complete the code so that
// the resulting module implements multiplication of two numbers in
// twos complement format.

// This style of modeling is 'behavioural', where the desired
// behaviour is described in terms of high level statements ('if'
// statements in verilog).  This is where the real power of the
// language is seen, since such modeling is closest to the way we
// think about the operation.  However, it is also the most difficult
// to translate into hardware, so a good understanding of the
// connection between the program and hardware is important.

// Synthesised code is not added and same shall be added after run.sh is modified 

`define width 8
`define ctrwidth 4

module seq_mult (
        // Outputs
        p, rdy, 
        // Inputs
        clk, reset, a, b
        ) ;
    
    input clk, reset;
    input [`width-1:0] a, b;
    
    // Output declaration for 'p' which is 2(`width) wide
    output [2*`width-1:0] p;
    output rdy;

    // Register declarations for p, multiplier, multiplicand all of them 2(`width) wide
    reg [2*`width-1:0] p, multiplier, multiplicand; 
    reg rdy;
    reg [`ctrwidth:0] ctr;

    always @(posedge clk or posedge reset)
        if (reset) begin
            rdy <= 0;
            p <= 0;
            ctr <= 0;
            multiplier <= {{`width{a[`width-1]}}, a};   // sign-extend
            multiplicand <= {{`width{b[`width-1]}}, b}; // sign-extend
        end else begin 
            if (ctr < 2*`width) 
            begin
            // Code for multiplication
                // Ternary operation, control? a:b, gives 'a' if control is true or 'b' is it is false.  
                // This operation is used to implement a mux which gives out multiplicand left shifted,
                // number of bits given by the value of ctr, if (ctr)th bit of the multiplier is not 0, 
                // or-else 0 is given as out. The output of the mux is added with p from previous step 
                // and the same is assigned to p in the next step. This is done using a single line of 
                // non-blocking assignment. Similarly, the counter is incremented at every step. We re-
                // -peat this as long as the value of ctr is less than 2('width). It is enough to incr-
                // -ment ctr till it exceeds ('width) for the case b,d in the below notes. But for the 
                // other two cases we need to increment ctr till it exceeds 2('width). The same can be 
                // verified from the below notes. This completes the implementation of seq. multiplier. 
                
                p <= (multiplier[ctr] ? (multiplicand<<ctr) : 0) + p;
                ctr <= ctr + 1; 
                
            end else begin
            rdy <= 1; 		// Assert 'rdy' signal to indicate end of multiplication
            end
        end

endmodule // seqmult

/*

Notes: 

Consider two 4-bit signed 2-complement numbers, so the product shall be 8-bit wide:

a. Both are negative: 

-3: 1111 1101 (Sign Extended)
-2: 1111 1110 (Sign Extended) 

   11111101
x  11111110 
  ----------
   00000000 
   1111101 
   111101 
   11101 
   1101
   101 
   01 
   1 
  ----------
   00000110    ---> +6
   
b. Multiplicand is negative: 

-3: 1111 1101 (Sign Extended)
+2: 0000 0010 (Sign Extended) 

   11111101
x  00000010  
  ----------
   00000000 
   1111101 
   000000 
   00000 
   0000
   000
   00
   0 
  ----------
   11111010    ---> -6  
   
c. Multiplier is negative: 

+3: 0000 0011 (Sign Extended)
-2: 1111 1110 (Sign Extended) 

   00000011
x  11111110   
  ----------
   00000000 
   0000011 
   000011 
   00011 
   0011
   011
   11
   1 
  ----------
   11111010    ---> -6 
   
d. Both are positive: 

+3: 0000 0011 (Sign Extended)
+2: 0000 0010 (Sign Extended) 

   00000011
x  00000010    
  ----------
   00000000 
   0000011 
   000000 
   00000 
   0000
   000
   00
   0
  ----------
   00000110    ---> +6 

*/ 