`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/22/2023 10:54:37 AM
// Design Name: 
// Module Name: pwm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// pwm
module pwm(
input clk,
output reg [7:0] pwm_count = 0
);
    always @(posedge clk )
    begin
    if (pwm_count<100)
        pwm_count<=pwm_count+1;
    else
        pwm_count <= 0;
    end
endmodule