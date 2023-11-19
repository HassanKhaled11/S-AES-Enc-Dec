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



////////// Inverse SBOX TABLE ///////////////

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

////////////////////////////////////////////////////////////////////





