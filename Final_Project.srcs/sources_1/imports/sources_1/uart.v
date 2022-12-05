`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 09:59:35 PM
// Design Name: 
// Module Name: uart
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

module uart(
    input clk,
    input RsRx,
    input [42:0] sending_data,
    input reset,
    input done,
    output RsTx,
    output [42:0] received_data,
    output opcode,
    output reg send_opcode
    );
    
    reg ena, last_rec, last_finish;
    wire [103:0] data_ascii;
    //reg send_opcode;
    wire [42:0] sending_data;
    wire [42:0] received_data;
    reg [7:0] data_in;
    wire [7:0] data_out;
    //wire [2:0] opcode;
    wire sent, received, baud;
    wire finish;
    reg [3:0] idx;
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, data_out);
    uart_tx transmitter(baud, data_in, ena, sent, RsTx);
    ascii2binary ascii2binary(data_out,clk,reset,received,received_data,opcode);
    binary2ascii binary2ascii(sending_data,clk,reset,done,sent,finish,data_ascii);
    
    
    always @(posedge baud) begin
        if (ena) ena = 0;
        if (~last_rec & received) begin
            if((data_out > 8'h2F && data_out < 8'h3A)|| data_out == 8'h2B||data_out == 8'h2D||data_out == 8'h2A||data_out == 8'h2F||data_out == 8'h63||data_out == 8'h43||data_out == 8'h73||data_out == 8'h53)begin
                data_in = data_out;
                ena = 1;
            end
            if(data_out == 8'h0A || data_out == 8'h0D) begin
                send_opcode = 1;
            end
        end
        last_rec = received;
    end
    
    always@ (finish) idx = 0;
           
    always@(posedge baud) begin
         //save = 0;
         if (ena) ena = 0;
         if (sent & finish)
         begin
            if (idx == 4'b1110) begin
                data_in <= 8'h3e;
                ena = 1;
            end
            else begin
                data_in = data_ascii[8*idx+7 -: 8];
                ena = 1;
            end
            idx = idx + 1;
            if (idx > 4'b1110)  idx = 0;
        end
    end

endmodule


