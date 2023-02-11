module top(
    input CLK100MHZ,                // nexys clk signal
    input [12:0] switches,            // Input from the switch for values of temperature.
    input isTempSensor, 
    input reset,                    // btnC on nexys
    
    inout TMP_SDA,                  // i2c sda on temp sensor - bidirectional
    
    output TMP_SCL,                 // i2c scl on temp sensor
    output [6:0]  SEG,              // 7 segments of each display
    output [7:0]  AN,               // 4 anodes of 4 displays
    output dp,                      // 4 anodes always OFF
    output reg [12:0] LED,              // nexys leds = binary temp in deg C
    output R,
    output G,
    output B
    );
    
    wire sda_dir;                   // direction of SDA signal - to or from master
    wire w_200kHz;                  // 200kHz SCL
    wire [15:0] w_data;              // 8 bits of temperature data
    reg [15:0] temporary;
     
      
     i2c_master master(
       .clk_200kHz(w_200kHz),
       .reset(reset),
       .temp_data(w_data),
       .SDA(TMP_SDA),
       .SDA_dir(sda_dir),
       .SCL(TMP_SCL)
     );               
    
    // Instantiate 200kHz clock generator
    clkgen_200kHz cgen(
        .clk_100MHz(CLK100MHZ),
        .clk_200kHz(w_200kHz)
    );
    
    always @(posedge CLK100MHZ)
    begin
        case(isTempSensor)
        1'b0:
            begin
                temporary <= {switches,3'b000};
            end
        1'b1:
            begin
                temporary <= w_data;
            end   
         endcase   
    end
    // Instantiate 7 segment control 
    seg_Display seg_instance(
        .clk_100MHz(CLK100MHZ),
        .temp_data(temporary),
        .reset(reset),
        .SEG(SEG),
        .AN(AN),
        .dp(dp),
        .R(R),
        .G(G),
        .B(B)
        );


  always @(posedge CLK100MHZ)
    begin
        case(isTempSensor)
        1'b0:
            begin
                LED <= switches;
            end
        1'b1:
            begin
                LED <= w_data[15:3];
            end   
         endcase   
    end
    
endmodule