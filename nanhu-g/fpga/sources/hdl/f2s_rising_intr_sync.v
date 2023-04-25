`timescale 1ns / 1ps

// This module is intended for synchronizing rising-edge sensitive interrupts
// from a fast clock domain to a slow clock domain

module f2s_rising_intr_sync #(
    parameter   INTR_WIDTH  = 1,
    parameter   SYNC_STAGE  = 2
)(
    input  wire                     fast_clk,
    input  wire                     fast_rstn,
    input  wire [INTR_WIDTH-1:0]    fast_intr,

    input  wire                     slow_clk,
    input  wire                     slow_rstn,
    output wire [INTR_WIDTH-1:0]    slow_intr
);

    genvar g_i;

    for (g_i=0; g_i<INTR_WIDTH; g_i=g_i+1) begin

        wire f_intr = fast_intr[g_i];

        // pulse to level stage in fast clock domain

        reg f_intr_pre;
        reg f_p2l;

        always @(posedge fast_clk) begin
            if (~fast_rstn)
                f_intr_pre <= 1'b0;
            else
                f_intr_pre <= f_intr;
        end

        always @(posedge fast_clk) begin
            if (~fast_rstn)
                f_p2l <= 1'b0;
            else
                f_p2l <= f_p2l ^ (f_intr & ~f_intr_pre);
        end

        // cdc stages

        (* ASYNC_REG = "TRUE" *) reg [SYNC_STAGE-1:0] f2s_sync;

        always @(posedge slow_clk) begin
            if (~slow_rstn)
                f2s_sync <= {SYNC_STAGE{1'b0}};
            else
                f2s_sync <= {f_p2l, f2s_sync[SYNC_STAGE-1:1]};
        end

        // level to pulse stage in slow clock domain

        reg s_l2p;

        always @(posedge slow_clk) begin
            if (~slow_rstn)
                s_l2p <= 1'b0;
            else
                s_l2p <= f2s_sync[0];
        end

        wire s_intr = s_l2p ^ f2s_sync[0];
        assign slow_intr[g_i] = s_intr;

    end

endmodule
