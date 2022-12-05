`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2021 03:59:02 PM
// Design Name: 
// Module Name: binary2ascii
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

module binary2ascii(
    input [42:0] in, 	//Binary input
    input clk,		//Clock Signal
    input rst,
    input data_status, //This bit goes to 1 if the data is ready
    input sent, //data is sent
    
    output reg finish, //data array is completed
    output reg [103:0] out	//ASCII Output 12 unit (6 int unit and 6 decimal unit) 
    );
    
parameter s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100, s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000, s9 = 4'b1001, s10 = 4'b1010, s11 = 4'b1011, s12 = 4'b1100;  //defining different states for Finite State Machine
reg fsm;		//FSM output		
reg [42:0] tmp;			   
reg [3:0] a;
reg [7:0] b;
reg [3:0] state;	//Variable for tracking the state

   task binary2ascii;
        input [3:0] in;	
        output [7:0] out;  
        begin
            case (in)
                0: out = 48;		//ASCII value 48 = 0 in Binary
                1: out = 49;		//ASCII value 49 = 1 in Binary
                2: out = 50;		//ASCII value 50 = 2 in Binary
                3: out = 51;		//ASCII value 51 = 3 in Binary
                4: out = 52;		//ASCII value 52 = 4 in Binary
                5: out = 53; 		//ASCII value 53 = 5 in Binary
                6: out = 54;		//ASCII value 54 = 6 in Binary
                7: out = 55;		//ASCII value 55 = 7 in Binary
                8: out = 56;		//ASCII value 56 = 8 in Binary
                9: out = 57;		//ASCII value 57 = 9 in Binary
            endcase
        end
   endtask
	
always @ (posedge clk)begin
	if (rst)begin
		state = s0; out = 0; a =0; b=0;tmp=0;	
	end
	else begin                     //Finite State Machine: Mealy Machine
	case (state)
		s0: begin
			fsm =0; 
			if (data_status) begin
			    tmp = in;
				a = tmp / (10**11);
				tmp = tmp - (a*(10**11));
				binary2ascii(a,b);
				out[7:0] = b;
				state = s1;
 			end
			else begin
				state = s0;
			end
		end
		s1: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**10);
				tmp = tmp - (a*(10**10));
				binary2ascii(a,b);
				out[15:8] = b;
				state = s2;
 			end
			else begin
				state = s1;
			end
		end
		s2: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**9);
				tmp = tmp - (a*(10**9));
				binary2ascii(a,b);
				out[23:16] = b;
				state = s3;	
 			end
			else begin
				state = s2;
			end
		end
		s3: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**8);
				tmp = tmp - (a*(10**8));
				binary2ascii(a,b);
				out[31:24] = b;
				state = s4;	
 			end
			else begin
				state = s3;
			end
		end
		s4: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**7);
				tmp = tmp - (a*(10**7));
				binary2ascii(a,b);
				out[39:32] = b;
				state = s5;
 			end
			else begin
				state = s4;
			end
		end
		s5: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**6);
				tmp = tmp - (a*(10**6));
				binary2ascii(a,b);
				out[47:40] = b;	
				state = s6;
 			end
			else begin
				state = s5;
			end
		end
		s6: begin
			fsm =0; 
			if (data_status) begin
				out[55:48] = 8'h2E;
				state = s7;
 			end
			else begin
				state = s6;
			end
		end
		s7: begin
			fsm =0; 
 			if (data_status) begin
				a = tmp / (10**5);
				tmp = tmp - (a*(10**5));
				binary2ascii(a,b);
				out[63:56] = b;
				state = s8;
 			end
			else begin
				state = s7;
			end
		end
		s8: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**4);
				tmp = tmp - (a*(10**4));
				binary2ascii(a,b);
				out[71:64] = b;
				state = s9;
 			end
			else begin
				state = s8;
			end
		end
		s9: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**3);
				tmp = tmp - (a*(10**3));
				binary2ascii(a,b);
				out[79:72] = b;
				state = s10;
 			end
			else begin
				state = s9;
			end
		end
		s10: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**2);
				tmp = tmp - (a*(10**2));
				binary2ascii(a,b);
				out[87:80] = b;
				state = s11;
 			end
			else begin
				state = s10;
			end
		end
		s11: begin
			fsm =0; 
			if (data_status) begin
				a = tmp / (10**1);
				tmp = tmp - (a*(10**1));
				binary2ascii(a,b);
				out[95:88] = b;
				state = s12;
 			end
			else begin
				state = s11;
			end
		end
		s12: begin
			fsm =1; 
			if (data_status) begin
				a = tmp / (10**0);
				tmp = tmp - (a*(10**0));
				binary2ascii(a,b);
				out[103:96] = b;
				finish = 1;
				state = s0;
 			end
			else begin
				state = s12;
			end
		end
	endcase
	end
end

endmodule

