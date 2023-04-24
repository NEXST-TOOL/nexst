`timescale 1ns / 1ps

// This module is intended for synchronizing rising-edge sensitive interrupts
// from a fast clock domain to a slow clock domain

module f2s_rising_intr_sync #(
    parameter   WIDTH       = 1,
    parameter   SYNC_STAGE  = 3
)(
    input  wire             sync_clk,
    input  wire [WIDTH-1:0] intr_in,
    output wire [WIDTH-1:0] intr_out
);

    genvar g_i;

    for (g_i=0; g_i<WIDTH; g_i=g_i+1) begin

        (* ASYNC_REG = "TRUE" *) reg [SYNC_STAGE-1:0] sync_reg;

        integer i;
        always @(posedge sync_clk or posedge intr_in[g_i]) begin : sync_reg_blk
            if (intr_in[g_i])
                sync_reg <= {SYNC_STAGE{1'b1}};
            else
                sync_reg <= {intr_in[g_i], sync_reg[SYNC_STAGE-1:1]};
        end

        assign intr_out[g_i] = sync_reg[0];

    end

endmodule
