//////////////////////////////////////////////
//////////AES DECRYPTION TESTING BLOCK ///////
//////////////////////////////////////////////

module Simplified_AES_Dec_tb   ;

reg  [15:0] Cipher_Text        ;
reg  [15:0] Key                ;
wire [15:0] Plain_Text         ;


Simplified_AES_Dec DUT(.*)     ;


initial begin
//TEST CASE EXAMPLE1

Cipher_Text = 16'b0010_0100_1110_1100;    // PUT CIPHER TEXT HERE
Key         = 16'b0100_1010_1111_0101;    
#10;
if(Plain_Text == 16'b1101_0111_0010_1000)   //PUT EXPECTED Plain_Text HERE
           $display("DATA MATCHED SUCCEEDED , Cipher_Text = %0b  , Plain_Text = %0b" ,Cipher_Text,Plain_Text);
else       $display("DATA NOT MATCHED FAILED , Cipher_Text = %0b , Plain_Text = %0b" ,Cipher_Text,Plain_Text); 


//---------------------------------------------------------------------------------

//TEST CASE EXAMPLE2

// Cipher_Text = 16'b0000_0111_0011_1000;     // PUT CIPHER TEXT HERE
// Key         = 16'b1010_0111_0011_1011;    
// #10;
// if(Plain_Text == 16'b0110_1111_0110_1011)  //PUT EXPECTED Plain_Text HERE
//            $display("DATA MATCHED DECRYPTION SUCCEEDED  , Cipher_Text = %b  , Plain_Text = %b" ,Cipher_Text,Plain_Text);
// else       $display("DATA NOT MATCHED DECRYPTION FAILED , Cipher_Text = %b  , Plain_Text = %b" ,Cipher_Text,Plain_Text); 

#1000;
$stop;
end

endmodule

//-----------------------------------------------------------------------------------------

///////////////////////////////////////////////////////////////////
////////////// AES DECRYPTION DESIGN CODE /////////////////////////
///////////////////////////////////////////////////////////////////


module Simplified_AES_Dec
(
  input      [15:0]    Cipher_Text   ,
  input      [15:0]    Key           ,

  output reg [15:0]    Plain_Text  
);


wire  [3:0] Inv_S_Box [15:0]  ;

 
wire [15:0] Key_Round0 ; 
wire [15:0] Key_Round1 ;
wire [15:0] Key_Round2 ;


reg  [15:0] add_r_k0      ;
reg  [15:0] nibble_Sub1   ;
reg  [15:0] shift_row1    ;
reg  [15:0] mix_coloumn_r2;
reg  [15:0] add_r_k1      ;
reg  [15:0] nibble_Sub2   ;
reg  [15:0] shift_row2    ;
reg  [15:0] add_r_k2      ;
   


wire [7:0] W_out_B1     ;
wire [7:0] W_out_B2     ;



Key_Expansion  Key_Expansion_Unit 
(
  .Key        (Key)            ,
  .Key_Round0 (Key_Round0)     ,
  .Key_Round1 (Key_Round1)     ,
  .Key_Round2 (Key_Round2)  
);


Mix_Coloumn   Mix_Coloumn_Unit
(
  .W        (add_r_k1) ,
  .W_out_B1 (W_out_B1)   ,
  .W_out_B2 (W_out_B2)
);



////////// Inverae SBOX TABLE ///////////////

assign  Inv_S_Box [ 0 ] = 4'hA;
assign  Inv_S_Box [ 1 ] = 4'h5;
assign  Inv_S_Box [ 2 ] = 4'h9;
assign  Inv_S_Box [ 3 ] = 4'hB;
assign  Inv_S_Box [ 4 ] = 4'h1;
assign  Inv_S_Box [ 5 ] = 4'h7; 
assign  Inv_S_Box [ 6 ] = 4'h8;
assign  Inv_S_Box [ 7 ] = 4'hF;
assign  Inv_S_Box [ 8 ] = 4'h6;
assign  Inv_S_Box [ 9 ] = 4'h0;
assign  Inv_S_Box [10 ] = 4'h2;
assign  Inv_S_Box [11 ] = 4'h3;
assign  Inv_S_Box [12 ] = 4'hC;
assign  Inv_S_Box [13 ] = 4'h4;      
assign  Inv_S_Box [14 ] = 4'hD;
assign  Inv_S_Box [15 ] = 4'hE;

////////////////////////////////////


always @(*) begin           // Encryption Process

 add_r_k2       = Cipher_Text ^ Key_Round2     ;
 shift_row2     = {add_r_k2[15:12] , add_r_k2[3:0] , add_r_k2[7:4] , add_r_k2[11:8]}               ;
 nibble_Sub2    = {Inv_S_Box[shift_row2[15:12]] , Inv_S_Box[shift_row2[11:8]] , Inv_S_Box[shift_row2[7:4]] ,Inv_S_Box[shift_row2[3:0]]};
 add_r_k1       = nibble_Sub2 ^ Key_Round1    ;
 mix_coloumn_r2 = {W_out_B1,W_out_B2}         ;
 shift_row1     = {mix_coloumn_r2[15:12] , mix_coloumn_r2[3:0] , mix_coloumn_r2[7:4] , mix_coloumn_r2[11:8]}; 
 nibble_Sub1    = {Inv_S_Box[shift_row1[15:12]] , Inv_S_Box[shift_row1[11:8]] , Inv_S_Box[shift_row1[7:4]] ,Inv_S_Box[shift_row1[3:0]]};
 add_r_k0       = nibble_Sub1 ^ Key_Round0    ;
 Plain_Text     = add_r_k0                    ;

end


endmodule

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



/////////////////////////////////
////////// Mix_Coloumn //////////
/////////////////////////////////

module Mix_Coloumn
(
  input      [15:0] W       ,
  output     [7:0] W_out_B1 ,
  output     [7:0] W_out_B2 
);



wire [3:0] lookup_table_2 [15:0] ;
wire [3:0] lookup_table_9 [15:0] ;


////////////////////////////////////////
////////// LookUp_Tables ///////////////


assign  lookup_table_2[1]  = 4'h2 ;  
assign  lookup_table_2[2]  = 4'h4 ;  
assign  lookup_table_2[3]  = 4'h6 ; 
assign  lookup_table_2[4]  = 4'h8 ; 
assign  lookup_table_2[5]  = 4'hA ; 
assign  lookup_table_2[6]  = 4'hC ;
assign  lookup_table_2[7]  = 4'hE ;
assign  lookup_table_2[8]  = 4'h3 ;
assign  lookup_table_2[9]  = 4'h1 ;
assign  lookup_table_2[10] = 4'h7 ;
assign  lookup_table_2[11] = 4'h5 ;
assign  lookup_table_2[12] = 4'hB ;
assign  lookup_table_2[13] = 4'h9 ;
assign  lookup_table_2[14] = 4'hF ;
assign  lookup_table_2[15] = 4'hD ;



assign  lookup_table_9[1]  = 4'h9 ;  
assign  lookup_table_9[2]  = 4'h1 ;  
assign  lookup_table_9[3]  = 4'h8 ; 
assign  lookup_table_9[4]  = 4'h2 ; 
assign  lookup_table_9[5]  = 4'hB ; 
assign  lookup_table_9[6]  = 4'h3 ;
assign  lookup_table_9[7]  = 4'hA ;
assign  lookup_table_9[8]  = 4'h4 ;
assign  lookup_table_9[9]  = 4'hD ;
assign  lookup_table_9[10] = 4'h5 ;
assign  lookup_table_9[11] = 4'hC ;
assign  lookup_table_9[12] = 4'h6 ;
assign  lookup_table_9[13] = 4'hF ;
assign  lookup_table_9[14] = 4'h7 ;
assign  lookup_table_9[15] = 4'hE ;




assign W_out_B1 = {lookup_table_9[W[15:12]] ^ lookup_table_2[W[11:8]] , lookup_table_2[W[15:12]] ^ lookup_table_9[W[11:8]]} ;
assign W_out_B2 = {lookup_table_9[W[7 :4]]  ^ lookup_table_2[W[3 :0]] , lookup_table_2[W[7 :4]]  ^ lookup_table_9[W[3:0]] } ;


endmodule


////////////////////////////////////////////////////////////////////





