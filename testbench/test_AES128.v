`timescale 1ns / 1ps

module AES_tb;

 
    reg         clk;
    reg         reset;
    reg  [127:0] pt;
    reg  [127:0] key;
    wire [127:0] ct;


    reg [127:0] test_pt     [0:3];
    reg [127:0] test_key;
    reg [127:0] expected_ct [0:3];
    reg [127:0] captured_ct [0:3];

    integer i;

    
    AESEncrypt uut (
        .pt   (pt),
        .key  (key),
        .ct   (ct),
        .clk  (clk),
        .reset(reset)
    );


    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    initial begin
  
        $dumpfile("aes_waveform.vcd");
        $dumpvars(0, AES_tb);

        test_key        = 128'h00000000000000000000000000000000;

        test_pt[0]      = 128'h4142434445464748494a4b4c4d4e4f50;
        expected_ct[0]  = 128'h61d78258eb1abd6fff479d1dabb6103b;

        test_pt[1]      = 128'h00000000000000000000000000000000;
        expected_ct[1]  = 128'h66e94bd4ef8a2c3b884cfa59ca342b2e;

        test_pt[2]      = 128'hffffffffffffffffffffffffffffffff;
        expected_ct[2]  = 128'h3f5b8cc9ea855a0afa7347d23e8d664e;

        test_pt[3]      = 128'h0123456789abcdef0123456789abcdef;
        expected_ct[3]  = 128'h27ba3ada4e61bcb03ad82126fe4e0a23;

        reset = 1'b1;
        pt    = 128'h0;
        key   = test_key;

     
        repeat (2) @(posedge clk);
        reset = 1'b0;
   
        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            pt  <= test_pt[i];
        end

        @(posedge clk);
        pt  <= 128'h0;
        key <= 128'h0;

        repeat (16) @(posedge clk); 

        for (i = 0; i < 4; i = i + 1) begin
            @(posedge clk);
            captured_ct[i] = ct;
        end


        for (i = 0; i < 4; i = i + 1) begin
          
            $display("Plaintext : %h", test_pt[i]);
            $display("Key       : %h", test_key);
            $display("Ciphertext: %h", captured_ct[i]);
            $display("Expected  : %h", expected_ct[i]);
            if (captured_ct[i] === expected_ct[i])
                $display(">>> TEST %0d PASSED <<<", i+1);
            else
                $display(">>> TEST %0d FAILED <<<", i+1);
         
        end

        $finish;
    end

endmodule
