module KeyGen (roundCount, keyIn, keyOut);
    input  [3:0]    roundCount;
    input  [127:0]  keyIn;
    output [127:0]  keyOut;

    genvar i;

    // Split the key into 4 words (w0..w3)
    wire [31:0] words[0:3];
    generate
        for (i = 0; i < 4; i = i + 1) begin : KeySplitLoop
            assign words[i] = keyIn[127 - i*32 -: 32];
        end
    endgenerate

    // rotWord on w3
    wire [31:0] w3Rot = {words[3][23:0], words[3][31:24]};

    // subWord on rotated w3
    wire [31:0] w3Sub;
    generate
        for (i = 0; i < 4; i = i + 1) begin : SubWordLoop
            SubTable subTable(w3Rot[8*i +: 8], w3Sub[8*i +: 8]);
        end
    endgenerate

    // Rcon (only the first 10 needed for AES-128)
    wire [7:0] roundConstantStart = (roundCount == 4'd1)  ? 8'h01 :
                                    (roundCount == 4'd2)  ? 8'h02 :
                                    (roundCount == 4'd3)  ? 8'h04 :
                                    (roundCount == 4'd4)  ? 8'h08 :
                                    (roundCount == 4'd5)  ? 8'h10 :
                                    (roundCount == 4'd6)  ? 8'h20 :
                                    (roundCount == 4'd7)  ? 8'h40 :
                                    (roundCount == 4'd8)  ? 8'h80 :
                                    (roundCount == 4'd9)  ? 8'h1b :
                                    (roundCount == 4'd10) ? 8'h36 :
                                                            8'h00;
    wire [31:0] roundConstant = {roundConstantStart, 24'h00};

    // First word of next key
    assign keyOut[127 -: 32] = words[0] ^ w3Sub ^ roundConstant;

    
    generate
        for (i = 1; i < 4; i = i + 1) begin : KeyExpansionLoop
            assign keyOut[127 - i*32 -: 32] = words[i] ^ keyOut[127 - (i-1)*32 -: 32];
        end
    endgenerate
endmodule
