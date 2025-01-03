module seven_segment (
input wire [3:0]i0,
output reg [6:0]o0,

input wire [3:0]i1,
output reg [6:0]o1,

input wire [3:0]i2,
output reg [6:0]o2,

input wire [3:0]i3,
output reg [6:0]o3,

input wire [3:0]i4,
output reg [6:0]o4,

input wire [3:0]i5,
output reg [6:0]o5
);


// HEX out - rewire DE1
//  ---0---
// |       |
// 5       1
// |       |
//  ---6---
// |       |
// 4       2
// |       |
//  ---3---

always @(*)
begin

	   case (i0)
	
		4'd0: o0 = 7'b0111111;
		4'd1: o0 = 7'b0001000;
		4'd2: o0 = 7'b0100100;
		4'd3: o0 = 7'b0110000;
		4'd4: o0 = 7'b0011001;
		4'd5: o0 = 7'b0010010;
		4'd6: o0 = 7'b0000010;
		4'd7: o0 = 7'b1111000;
		4'd8: o0 = 7'b0000000;
		4'd9: o0 = 7'b0011000;
		4'd10: o0 = 7'b0010100;
		4'd11: o0 = 7'b1100000;
		4'd12: o0 = 7'b1100000;
		4'd13: o0 = 7'b1100000;
	  
    	default: o0 = 7'b11111111;
	  
   endcase

   case (i1)
	
		4'd0: o1 = 7'b0111111;
		4'd1: o1 = 7'b0001000;
		4'd2: o1 = 7'b0100100;
		4'd3: o1 = 7'b0110000;
		4'd4: o1 = 7'b0011001;
		4'd5: o1 = 7'b0010010;
		4'd6: o1 = 7'b0000010;
		4'd7: o1 = 7'b1111000;
		4'd8: o1 = 7'b0000000;
		4'd9: o1 = 7'b0011000;
		4'd10: o1 = 7'b0010100;
		4'd11: o1 = 7'b1100000;
		4'd12: o1 = 7'b1100000;
		4'd13: o1 = 7'b1100000;
	  
    	default: o1 = 7'b11111111;
	  
   endcase
	
	   case (i2)
	
		4'd0: o2 = 7'b0111111;
		4'd1: o2 = 7'b0001000;
		4'd2: o2 = 7'b0100100;
		4'd3: o2 = 7'b0110000;
		4'd4: o2 = 7'b0011001;
		4'd5: o2 = 7'b0010010;
		4'd6: o2 = 7'b0000010;
		4'd7: o2 = 7'b1111000;
		4'd8: o2 = 7'b0000000;
		4'd9: o2 = 7'b0011000;
		4'd10: o2 = 7'b0010100;
		4'd11: o2 = 7'b1100000;
		4'd12: o2 = 7'b1100000;
		4'd13: o2 = 7'b1100000;
	  
    	default: o2 = 7'b11111111;
	  
   endcase
	
	   case (i3)
	
		4'd0: o3 = 7'b0111111;
		4'd1: o3 = 7'b0001000;
		4'd2: o3 = 7'b0100100;
		4'd3: o3 = 7'b0110000;
		4'd4: o3 = 7'b0011001;
		4'd5: o3 = 7'b0010010;
		4'd6: o3 = 7'b0000010;
		4'd7: o3 = 7'b1111000;
		4'd8: o3 = 7'b0000000;
		4'd9: o3 = 7'b0011000;
		4'd10: o3 = 7'b0010100;
		4'd11: o3 = 7'b1100000;
		4'd12: o3 = 7'b1100000;
		4'd13: o3 = 7'b1100000;
	  
    	default: o3 = 7'b11111111;
	  
   endcase
	
	   case (i4)
	
		4'd0: o4 = 7'b0111111;
		4'd1: o4 = 7'b0001000;
		4'd2: o4 = 7'b0100100;
		4'd3: o4 = 7'b0110000;
		4'd4: o4 = 7'b0011001;
		4'd5: o4 = 7'b0010010;
		4'd6: o4 = 7'b0000010;
		4'd7: o4 = 7'b1111000;
		4'd8: o4 = 7'b0000000;
		4'd9: o4 = 7'b0011000;
		4'd10: o4 = 7'b0010100;
		4'd11: o4 = 7'b1100000;
		4'd12: o4 = 7'b1100000;
		4'd13: o4 = 7'b1100000;
	  
    	default: o4 = 7'b11111111;
	  
   endcase
	
	   case (i5)
	
		4'd0: o5 = 7'b0111111;
		4'd1: o5 = 7'b0001000;
		4'd2: o5 = 7'b0100100;
		4'd3: o5 = 7'b0110000;
		4'd4: o5 = 7'b0011001;
		4'd5: o5 = 7'b0010010;
		4'd6: o5 = 7'b0000010;
		4'd7: o5 = 7'b1111000;
		4'd8: o5 = 7'b0000000;
		4'd9: o5 = 7'b0011000;
		4'd10: o5 = 7'b0010100;
		4'd11: o5 = 7'b1100000;
		4'd12: o5 = 7'b1100000;
		4'd13: o5 = 7'b1100000;
	  
    	default: o5 = 7'b11111111;
	  
   endcase
	
	
end

endmodule