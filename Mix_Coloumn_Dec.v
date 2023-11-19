

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
