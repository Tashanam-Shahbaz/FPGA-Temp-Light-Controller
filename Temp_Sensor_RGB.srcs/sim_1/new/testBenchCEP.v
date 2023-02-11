module testBenchCEP;

reg CLK100MHZ;
reg [12:0] switches; 
reg isTempSensor;
reg reset;

wire TMP_SDA;

wire TMP_SCL;

wire [6:0] SEG; 
wire [7:0] AN;
wire dp;
wire [15:0] LED;
wire R,G,B;


top UUT(CLK100MHZ, switches, isTempSensor, reset, TMP_SDA , TMP_SCL , SEG,AN , dp , LED , R ,  G , B );

always #5CLK100MHZ = ~CLK100MHZ;

initial begin
CLK100MHZ =0;

reset = 1'b0;
isTempSensor=1'b0;
switches=13'b0000000000000; //0

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b0000000000011; //0.1875

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b0000001000001; //+4.0625

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b0000011110101; // 15.3125

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b0000101000000; //20

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b0000110010000; //+25

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b0001000000000; //32

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b1111111111111; //-0.0625 

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b1111100000000; //-16

#10;
reset = 1'b0;
isTempSensor=1'b0;
switches=13'b1111001110000; //-25

#10;

end
endmodule