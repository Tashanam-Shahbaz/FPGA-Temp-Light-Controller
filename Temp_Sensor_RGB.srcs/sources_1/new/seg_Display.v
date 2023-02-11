
module seg_Display(
    input clk_100MHz,               // Nexys A7 clock
    input [15:0] temp_data,
    input reset,
    
    output reg [6:0] SEG,           // 7 Segments of Displays
    output reg [7:0] AN,
    output reg dp,
    output reg is_Negative,
    output reg R,                   // RGB Displays
    output reg G, 
    output reg B
    );

    reg [3:0] first;  // first seven segment
    reg [3:0] second; //second seven segment
    reg [3:0] third; //third seven segment
    reg [3:0] fourth; // fourth seven segment
    reg [3:0] fifth; //fifth seven segment
    reg [3:0] sixth; //sixth seven segment
    reg [3:0] seventh; //seventh seven segment or negative sign   
    
    reg [3:0] seg;
    
    //18 bit Counter, 8 bit pulse with modulation counter and 3 bit RGB
    reg [17:0] Counter = 0 ;
    wire [7:0] pwm_Count;
    reg [2:0] RGB_Color;
    
    reg [12:0] temp_variable;
    reg [4:0] temp_fraction;
    
    
    always@(posedge clk_100MHz)
    
    begin
    Counter<=Counter+1;
    end
    
   always @ (*)
begin
    case(seg)
        0 : SEG = 7'b1000000; //0
        1 : SEG = 7'b1111001; //1
        2 : SEG = 7'b0100100; //2
        3 : SEG = 7'b0110000; //3
        4 : SEG = 7'b0011001; //4
        5 : SEG = 7'b0010010; //5
        6 : SEG = 7'b0000010; //6
        7 : SEG = 7'b1111000; //7
        8 : SEG = 7'b0000000; //8
        9 : SEG = 7'b0011000; //9
        10: SEG = 7'b0111111;       //(-) negative sign.
        default: SEG = 7'b1111111; //seven segment OFF
    endcase

 
 //FOR HANDLING 2'S COMPLEMENTS    
case ( temp_data[15] )
    1'b0: begin
        seventh <= 4'b1011;     //This values will be ignore
        is_Negative<=0;         //indicating positive number
        temp_variable <= temp_data[15:3];
      end
    1'b1: begin
            seventh <= 4'b1010; //indicating it is neg number
            is_Negative<=1;     //indicating it is neg number
            temp_variable <= (~temp_data[15:3])+1; //taking out 2's complement
          end

endcase

// e.g 25 --> { (25 / 10 = 2) and (25 % 10 = 5 ) }     
sixth = temp_variable[12:4] / 10;           // Tens value of temp data
fifth = temp_variable[12:4] % 10; 
temp_fraction = temp_variable[3:0];    

case (temp_fraction)
    4'b0000: begin first  <= 4'b0000;
                   second <= 4'b0000;
                   third  <= 4'b0000;
                   fourth <= 4'b0000;end
    4'b0001: begin first  <= 4'b0101;
                   second <= 4'b0010;
                   third  <= 4'b0110;
                   fourth <= 4'b0000;end
    4'b0010: begin first  <= 4'b0000;
                   second <= 4'b0101;
                   third  <= 4'b0010;
                   fourth <= 4'b0001;end
    4'b0011: begin first  <= 4'b0101;
                   second <= 4'b0111;
                   third  <= 4'b1000;
                   fourth <= 4'b0001;end
    4'b0100: begin first  <= 4'b0000;
                   second <= 4'b0000;
                   third  <= 4'b0101;
                   fourth <= 4'b0010;end
    4'b0101: begin first  <= 4'b0101;
                   second <= 4'b0010;
                   third  <= 4'b0001;
                   fourth <= 4'b0011;end
    4'b0110: begin first  <= 4'b0000;
                   second <= 4'b0101;
                   third  <= 4'b0111;
                   fourth <= 4'b0011;end
    4'b0111: begin first  <= 4'b0101;
                   second <= 4'b0111;
                   third  <= 4'b0011;
                   fourth <= 4'b0100;end
    4'b1000: begin first  <= 4'b0000;
                   second <= 4'b0000;
                   third  <= 4'b0000;
                   fourth <= 4'b0101;end               
    4'b1001: begin first  <= 4'b0101;
                   second <= 4'b0010;
                   third  <= 4'b0110;
                   fourth <= 4'b0101;end
    4'b1010: begin first  <= 4'b0000;
                   second <= 4'b0101;
                   third  <= 4'b0010;
                   fourth <= 4'b0110;end
    4'b1011: begin first  <= 4'b0101;
                   second <= 4'b0111;
                   third  <= 4'b1000;
                   fourth <= 4'b0110;end
    4'b1100: begin first  <= 4'b0000;
                   second <= 4'b0000;
                   third  <= 4'b0101;
                   fourth <= 4'b0111;end
    4'b1101: begin first  <= 4'b0101;
                   second <= 4'b0010;
                   third  <= 4'b0001;
                   fourth <= 4'b1000;end
    4'b1110: begin first  <= 4'b0000;
                   second <= 4'b0101;
                   third  <= 4'b0111;
                   fourth <= 4'b1000;end
    4'b1111: begin first  <= 4'b0101;
                   second <= 4'b0111;
                   third  <= 4'b0011;
                   fourth <= 4'b1001;end
    default: begin first  <= 4'b0000;
                   second <= 4'b0000;
                   third  <= 4'b0000;
                   fourth <= 4'b0000;end
   endcase
end 
    
    
always @ (*)
begin
    
    case (Counter[17:15])
        3'b000: begin
                    seg <= first;
                    AN <= 8'b11111110;
                    dp <= 1'b1;
                end
        3'b001: begin
                    seg <= second;
                    AN <= 8'b11111101;
                    dp <= 1'b1;
                end
        3'b010: begin
                    seg <= third;
                    AN <= 8'b11111011;
                    dp <= 1'b1;
                end
        3'b011: begin
                    seg <= fourth;
                    AN <= 8'b11110111;
                    dp <= 1'b1;
                end
        3'b100: begin
                    seg <= fifth;
                    AN <= 8'b11101111;
                    dp <= 1'b0;
               end
        3'b101: begin
                    seg <= sixth;
                    AN <= 8'b11011111;
                    dp <= 1'b1;
               end
       
       3'b110: begin // For Negative values
                  seg <= seventh;
                  AN <= 8'b10111111;
                  dp <= 1'b1;
               end       
        default: begin AN <=8'b11111111; dp <= 1'b1;end  
    endcase

    //FOR INCREASING AND DECRESING INTENSITY OF RGB LIGHTS 
    case(fifth)
    4'b0000:
           if (10 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
    
    4'b0001: 
           if (20 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
           
    4'b0010:
           if (30 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
    
    4'b0011:
           if (40 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
    
    4'b0100:
           if (50 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
    
    4'b0101:
           if (60 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
           
    4'b0110: 
           if (70 > pwm_Count)
             begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
    
    4'b0111:
           if (80 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
           
    4'b1000:
           if (90 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
           
    4'b1001: 
           if (100 > pwm_Count)
           begin
               R<= RGB_Color[2];
               G<= RGB_Color[1];
               B<= RGB_Color[0];
           end
           else 
           begin
               R<=0;
               G<=0;
               B<=0;
           end
    endcase
    
    //SELECTION OF RGB COLOR
    case(is_Negative)
        1'b0:case(sixth)
                4'b0000:  RGB_Color <= 3'b110; // Yellow 
                4'b0001:  RGB_Color <= 3'b011; // Cyan
                4'b0010:  RGB_Color <= 3'b111; // White
                4'b0011:  RGB_Color <= 3'b001; // Blue
                default : RGB_Color <= 3'b000; // Black
             endcase
                
        1'b1:case(sixth)   
                4'b0000:  RGB_Color <= 3'b101; // Magenta
                4'b0001:  RGB_Color <= 3'b100; // Red
                4'b0010:  RGB_Color <= 3'b010; // Green
                default : RGB_Color <= 3'b000; // Black
             endcase
    endcase
end

//instances for pwm
pwm p1(.clk(clk_100MHz),.pwm_count(pwm_Count));
endmodule


