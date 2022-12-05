`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module ascii2binary(
    input [7:0] in, 	//ASCII input
    input clk,		//Clock Signal
    input rst,		
    input w_RX_dv,  //This bit goes to 1 if the data byte is received properly
   
    output reg [42:0] out,	//Binary Output
    output reg [2:0] opcode
    );
    
parameter s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011, s4 = 4'b0100, s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111, s8 = 4'b1000, s9 = 4'b1001, s10 = 4'b1010, s11 = 4'b1011, s12 = 4'b1100, s13 = 4'b1101, s14 = 4'b1110;  //defining different states for Finite State Machine
reg fsm;		//FSM output					   
reg [42:0] a;
reg [3:0] state;	//Variable for tracking the state

   task ascii2binary;
        input [7:0] w_RX_byte;  
        output [42:0]out;	
        begin
            case (w_RX_byte)
                48: out = 0;		//ASCII value 48 = 0 in Binary
                49: out = 1;		//ASCII value 49 = 1 in Binary
                50: out = 2;		//ASCII value 50 = 2 in Binary
                51: out = 3;		//ASCII value 51 = 3 in Binary
                52: out = 4;		//ASCII value 52 = 4 in Binary
                53: out = 5; 		//ASCII value 53 = 5 in Binary
                54: out = 6;		//ASCII value 54 = 6 in Binary
                55: out = 7;		//ASCII value 55 = 7 in Binary
                56: out = 8;		//ASCII value 56 = 8 in Binary
                57: out = 9;		//ASCII value 57 = 9 in Binary
            endcase
        end
   endtask
	
always @ (posedge clk)begin
	if (rst)begin
		state = s0; out = 0; a =0 ;	
	end
	else begin                     //Finite State Machine: Mealy Machine
	case (state)
		s0: begin
			fsm =0; 
			if (w_RX_dv) begin
				if(in == 8'h2B)begin // ADD
				    state = s1;
				    opcode = 3'b000;
				    out[42] = 0;  // signbit = 0
				end
				if(in == 8'h2D)begin // SUB
				    state = s1;
				    opcode = 3'b001;
				    out[42] = 1;  // signbit = 1
				end
				/*
				if(in == 8'h2A)begin // MUL
				
				
				end
				if(in == 8'h2F)begin // DIV
				
				
				end
				*/
				if(in == 8'h43 || in == 8'h63)begin // C
				    state = s14;
				end
				/*
				if(in == 8'h73 || in == 8'h53)begin // SQUARE ROOT
				
				
				end
				*/
 			end
			else begin
				state = s0;
			end
		end
		s1: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s2;
				ascii2binary(in,a);
                out = out +  a * 10**11;
 			end
			else begin
				state = s1;
			end
		end
		s2: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s3;
				ascii2binary(in,a);
                out = out +  a * 10**10;
 			end
			else begin
				state = s2;
			end
		end
		s3: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s4;
				ascii2binary(in,a);
                out = out +  a * 10**9;
 			end
			else begin
				state = s3;
			end
		end
		s4: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s5;
				ascii2binary(in,a);
                out = out +  a * 10**8;
 			end
			else begin
				state = s4;
			end
		end
		s5: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s6;
				ascii2binary(in,a);
                out = out +  a * 10**7;
 			end
			else begin
				state = s5;
			end
		end
		s6: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s7;
				ascii2binary(in,a);
                out = out +  a * 10**6;
 			end
			else begin
				state = s6;
			end
		end
		s7: begin
			fsm =0; 
			if (w_RX_dv && in == 8'h2E) begin
				state = s8;
 			end
			else begin
				state = s7;
			end
		end
		s8: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s9;
				ascii2binary(in,a);
                out = out +  a * 10**5;
 			end
			else begin
				state = s8;
			end
		end
		s9: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s10;
				ascii2binary(in,a);
                out = out +  a * 10**4;
 			end
			else begin
				state = s9;
			end
		end
		s10: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s11;
				ascii2binary(in,a);
                out = out +  a * 10**3;
 			end
			else begin
				state = s10;
			end
		end
		s11: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s12;
				ascii2binary(in,a);
                out = out +  a * 10**2;
 			end
			else begin
				state = s11;
			end
		end
		s12: begin
			fsm =0; 
			if (w_RX_dv) begin
				state = s13;
				ascii2binary(in,a);
                out = out +  a * 10**1;
 			end
			else begin
				state = s12;
			end
		end
		s13: begin
			fsm =1; 
			if (w_RX_dv) begin
				state = s0;
				ascii2binary(in,a);
                out = out +  a * 10**0;
 			end
			else begin
				state = s13;
			end
		end
		s14: begin
			fsm =1;
			state = s0;
		    opcode = 3'b111;
		end
	endcase
	end
end
endmodule