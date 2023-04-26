`timescale 1ns / 1ps

// This module is intended for synchronizing rising-edge sensitive interrupts
// from a fast clock domain to a slow clock domain

module f2s_rising_intr_sync #(
    parameter   INTR_WIDTH  = 1,
    parameter   SYNC_STAGE  = 2
)(
    input  wire                     fast_clk,
    input  wire [INTR_WIDTH-1:0]    fast_intr,

    input  wire                     slow_clk,
    output wire [INTR_WIDTH-1:0]    slow_intr
);

    genvar g_i;

    for (g_i=0; g_i<INTR_WIDTH; g_i=g_i+1) begin

        wire f_intr = fast_intr[g_i];
        reg f_intr_reg;

        always @(posedge fast_clk) begin
            f_intr_reg <= f_intr;
        end

        (* ASYNC_REG = "TRUE" *) reg f2s_presync;

        always @(posedge slow_clk or posedge f_intr_reg) begin
            if (f_intr_reg)
                f2s_presync <= 1'b1;
            else
                f2s_presync <= f_intr_reg;
        end

        (* ASYNC_REG = "TRUE" *) reg [SYNC_STAGE-1:0] f2s_sync;

        always @(posedge slow_clk) begin
            f2s_sync <= {f2s_presync, f2s_sync[SYNC_STAGE-1:1]};
        end

        // level to pulse stage in slow clock domain

        wire s_intr = f2s_sync[0];
        assign slow_intr[g_i] = s_intr;

    end

endmodule
