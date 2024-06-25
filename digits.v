`timescale 1ns / 1ps

module digits(
    input clk,
    input reset,
    input [5:0] seconds, minutes,
    output reg [3:0] ones,
    output reg [3:0] tens,
    output reg [3:0] hundreds,
    output reg [3:0] thousands
    );
    
    // ones, tens, hundreds, and thousands control
    always @(posedge clk or posedge reset)
    begin
        if (reset) begin
            ones <= 0;
            tens <= 0;
            hundreds <= 0;
            thousands <= 0;
        end 
        else begin
            ones <= seconds % 10;
            tens <= seconds / 10;
            hundreds <= minutes % 10;
            thousands <= minutes / 10;
        end
    end
endmodule
