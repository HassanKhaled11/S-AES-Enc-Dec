
/////////////////////////////////
////////// Mix_Coloumn //////////
/////////////////////////////////

module Mix_Coloumn
(
  input      [15:0] W       ,
  output     [7:0] W_out_B1 ,
  output     [7:0] W_out_B2 
);


wire [3:0] lookup_table_4 [15:0] ;


////////////////////////////////////////
////////// LookUp_Tables ///////////////

assign  lookup_table_4[1]  = 4'h4 ;  
assign  lookup_table_4[2]  = 4'h8 ;  
assign  lookup_table_4[3]  = 4'hC ; 
assign  lookup_table_4[4]  = 4'h3 ; 
assign  lookup_table_4[5]  = 4'h7 ; 
assign  lookup_table_4[6]  = 4'hB ;
assign  lookup_table_4[7]  = 4'hF ;
assign  lookup_table_4[8]  = 4'h6 ;
assign  lookup_table_4[9]  = 4'h2 ;
assign  lookup_table_4[10] = 4'hE ;
assign  lookup_table_4[11] = 4'hA ;
assign  lookup_table_4[12] = 4'h5 ;
assign  lookup_table_4[13] = 4'h1 ;
assign  lookup_table_4[14] = 4'hD ;
assign  lookup_table_4[15] = 4'h9 ;


assign W_out_B1 = {W[15:12]  ^ lookup_table_4[W[11:8]] , lookup_table_4[W[15:12]] ^ W[11:8]} ;
assign W_out_B2 = {W[7 :4 ]  ^ lookup_table_4[W[3 :0]] , lookup_table_4[W[7 :4]]  ^ W[3 :0]} ;


endmodule
