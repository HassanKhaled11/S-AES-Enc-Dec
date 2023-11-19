/////////////////////////////////
////////// Key_Expansion ////////
/////////////////////////////////


module Key_Expansion
(
  input      [15:0]    Key          ,

  output reg [15:0]    Key_Round0   ,
  output reg [15:0]    Key_Round1   ,
  output reg [15:0]    Key_Round2   

);

wire [7:0] g_w1   ;
wire [7:0] g_w3   ;

g_func  g_fun_Unit 
( 
  .word_1 (Key[7:0])            ,
  .word_3 (Key_Round1[7:0])     ,
  .g_w1   (g_w1)                ,
  .g_w3   (g_w3)   
);


always@(*)
begin 
 Key_Round0 = Key ;
 Key_Round1 = {Key[15:8]^g_w1 , Key[15:8]^g_w1^Key[7:0]} ;
 Key_Round2 = {Key_Round1[15:8]^g_w3 , Key_Round1[15:8]^g_w3^Key_Round1[7:0]}; 
end

endmodule


/////////////////////////////////
////////// g_Function ///////////
/////////////////////////////////

module g_func
(
  input  [7:0] word_1     ,
  input  [7:0] word_3     ,
  
  output [7:0] g_w1       ,
  output [7:0] g_w3    

);

wire [3:0] S_Box [15:0]    ;

////////// SBOX TABLE ///////////////
assign  S_Box [ 0 ] = 4'h9;
assign  S_Box [ 1 ] = 4'h4;
assign  S_Box [ 2 ] = 4'hA;
assign  S_Box [ 3 ] = 4'hB;
assign  S_Box [ 4 ] = 4'hD;
assign  S_Box [ 5 ] = 4'h1; 
assign  S_Box [ 6 ] = 4'h8;
assign  S_Box [ 7 ] = 4'h5;
assign  S_Box [ 8 ] = 4'h6;
assign  S_Box [ 9 ] = 4'h2;
assign  S_Box [10 ] = 4'h0;
assign  S_Box [11 ] = 4'h3;
assign  S_Box [12 ] = 4'hC;
assign  S_Box [13 ] = 4'hE;      
assign  S_Box [14 ] = 4'hF;
assign  S_Box [15 ] = 4'h7;
/////////////////////////////////////

assign g_w1 =  {S_Box[word_1[3:0]] , S_Box[word_1[7:4]]} ^ 8'b1000_0000 ;
assign g_w3 =  {S_Box[word_3[3:0]] , S_Box[word_3[7:4]]} ^ 8'b0011_0000 ;


endmodule
