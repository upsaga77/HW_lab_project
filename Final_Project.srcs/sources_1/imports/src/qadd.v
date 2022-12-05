`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:28:18 08/24/2011 
// Design Name: 
// Module Name:    q15_add 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module qadd(
    input [43-1:0] a,
    input [43-1:0] b,
    output [43-1:0] c,
    output reg done
    );
//sign+16.15

	//Parameterized value
reg [43-1:0] res;

assign c = res;

always @(a,b)
begin
    done = 0;
	//both negative
	if(a[43-1] == 1 && b[43-1] == 1) begin
		//sign
		res[43-1] = 1;
		//whole
		res[43-2:0] = a[43-2:0] + b[43-2:0];
		done = 1;
	end
	//both positive
	else if(a[43-1] == 0 && b[43-1] == 0) begin
		//sign
		res[43-1] = 0;
		//whole
		res[43-2:0] = a[43-2:0] + b[43-2:0];
		done = 1;
	end
	//subtract a-b
	else if(a[43-1] == 0 && b[43-1] == 1) begin
		//sign
		if(a[43-2:0] > b[43-2:0])
			res[43-1] = 1;
		else
			res[43-1] = 0;
		//whole
		res[43-2:0] = a[43-2:0] - b[43-2:0];
		done = 1;
	end
	//subtract b-a
	else begin
		//sign
		if(a[43-2:0] < b[43-2:0])
			res[43-1] = 1;
		else
			res[43-1] = 0;
		//whole
		res[43-2:0] = b[43-2:0] - a[43-2:0];
		done = 1;
	end
end

endmodule

