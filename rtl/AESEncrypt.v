`timescale 1ns / 1ps

module AESEncrypt(pt, key, ct, clk, reset);

    input clk;

    input reset;
    input [127:0] pt;
    input [127:0] key;
    output [127:0] ct;


    wire [127:0] sb_out[9:0];
    wire [127:0] sb_sr_out[9:0];

    wire [127:0] sr_out[9:0];

    wire [127:0] mc_out[8:0];
    wire [127:0] ak_out[9:0];
    wire [127:0] r_out[9:0];
    wire [127:0] init;

    
    wire [127:0] k_out[9:0];
    wire [127:0] k_regA[9:0];
    wire [127:0] k_regB[9:0];

    AddRoundKey addr0 (pt, key, init);
    
    KeyGen k0 (4'd1, key, k_out[0]);
    Update key_regA0 (clk, reset, k_out[0], k_regA[0]);
    SubBytes sb0 (init, sb_out[0]);
    ShiftRows sr0 (sb_out[0], sr_out[0]);
    Update sbsr_r0 (clk, reset, sr_out[0], sb_sr_out[0]);
    
    MixColumns  mc0 (sb_sr_out[0], mc_out[0]);
    AddRoundKey sk0 (mc_out[0],   k_regA[0], ak_out[0]);
    Update out0 (clk, reset, ak_out[0], r_out[0]);
    Update key_regB0 (clk, reset, k_regA[0], k_regB[0]);

    genvar i;
    generate
        for (i = 1; i <= 9; i = i + 1) begin
            // SB/SR
            localparam round_num = i + 1;
            KeyGen k_i(round_num[3:0], k_regB[i-1], k_out[i]);
            Update key_regAi(clk, reset, k_out[i], k_regA[i]);
            
            SubBytes sb_i (r_out[i-1], sb_out[i]);
            ShiftRows sr_i(sb_out[i], sr_out[i]);

            Update sbsr_ri (clk, reset, sr_out[i], sb_sr_out[i]);
            Update key_regBi (clk, reset, k_regA[i], k_regB[i]);

            // Mix/Add
            if (i < 9) begin
                MixColumns  mc_i (sb_sr_out[i], mc_out[i]);
                AddRoundKey ak_i (mc_out[i],   k_regA[i], ak_out[i]);
                Update out_i (clk, reset, ak_out[i], r_out[i]);
            end else begin
                AddRoundKey ak_f (sb_sr_out[i], k_regA[i], ak_out[i]);
                Update out_f (clk, reset, ak_out[i], ct);
            end
        end
    endgenerate
endmodule