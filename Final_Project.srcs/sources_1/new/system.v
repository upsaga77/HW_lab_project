`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/13/2021 08:21:16 PM
// Design Name: 
// Module Name: system
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

module system(
    output wire RsTx,
    input wire RsRx,
    input btnC,
    input clk
    );
wire reset,done,send_opcode;
wire [2:0] opcode;
wire [42:0] sending_data,received_data;
reg [42:0] accumulator;
reg data_status;

singlePulser (reset, btnC, clk);
uart uart(clk,RsRx,sending_data,reset,done,RsTx,received_data,opcode,send_opcode);
qadd qadd(accumulator,received_data,sending_data,done);


always@(sending_data)
begin
    accumulator <= sending_data;
    data_status <= 1;
end
endmodule
