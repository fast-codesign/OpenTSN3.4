//second pulse0727ok_01
module write_file_data #(

)
(
      input clk,
      input rst_n,

      input [3:0] host_wr_id,
      input [31:0] local_clock,

      input [7:0] RXD,
      input RXDV
);

      reg [3:0] write_file_state;
      
      reg [7:0] data_reg;

      localparam INIT_S =4'd0,
                 
                 WAIT_S=4'd1,
                 
                 TRANS_S=4'd2;        


       reg [2:0] length_cnt;
       reg [2:0] time_cnt;
       reg [2:0] preamble_cnt;
       reg [15:0] pkt_length;
       reg [15:0] pkt_length_cnt;
       reg [3:0] result;

       reg [31:0] local_clock_time;

      integer fp_w;

      always @(posedge clk or negedge rst_n)begin
            if(!rst_n)begin
                  length_cnt <=3'd0;
                  time_cnt <=3'd0;
                  preamble_cnt <=3'd0;
                  pkt_length <=16'd0;
                  pkt_length_cnt <=16'd0;
                  write_file_state <=INIT_S;  
            end
            else begin
                  case(write_file_state)
                       INIT_S:begin
                             case(host_wr_id)
                                  4'd0: result=4'd0;
                                       
                                  4'd1: result=4'd1;

                                  4'd2: result=4'd2;
                                  
                                  4'd3: result=4'd3;
                                  
                                  4'd4: result=4'd4;
                                                   
                                  4'd5: result=4'd5;
                                                  
                                  4'd6: result=4'd6;
                                                  
                                  4'd7: result=4'd7;

                                  default: result=4'bx;
                             endcase
                                  write_file_state <=WAIT_S;
                       end
                       
                       WAIT_S:begin

                             if(RXDV==1'b0)begin
                                write_file_state <=WAIT_S;
                             end
                             ///////////////1111111111111111111111
                             else begin  //??????????
                                 preamble_cnt <= preamble_cnt+3'd1;
                                 
                                 data_reg <=RXD;
                                   
                                   local_clock_time <=local_clock;                                   
                                        case(result)
                                         4'd0:begin 
                                               fp_w =$fopen("../data/data010.txt","a+");
                                               $fwrite(fp_w,"%h %h %h %h %h ",local_clock[31:24],local_clock[23:16],local_clock[15:8],local_clock[7:0],RXD) ;

                                               $fclose(fp_w);
                                         end

                                          4'd1:begin 
                                               fp_w =$fopen("../data/data011.txt","a+");
                                               $fwrite(fp_w,"%h %h %h %h %h ",local_clock[31:24],local_clock[23:16],local_clock[15:8],local_clock[7:0],RXD ) ;

                                               $fclose(fp_w);
                                          end

                                          4'd2:begin 
                                               fp_w =$fopen("../data/data012.txt","a+");
                                               $fwrite(fp_w,"%h %h %h %h %h ",local_clock[31:24],local_clock[23:16],local_clock[15:8],local_clock[7:0],RXD ) ;

                                               $fclose(fp_w);
                                          end

                                          4'd3:begin 
                                               fp_w =$fopen("../data/data013.txt","a+");
                                               $fwrite(fp_w,"%h %h %h %h %h ",local_clock[31:24],local_clock[23:16],local_clock[15:8],local_clock[7:0],RXD ) ;

                                               $fclose(fp_w);
                                          end 

                                         4'd4:begin 
                                               fp_w =$fopen("../data/data014.txt","a+");
                                               $fwrite(fp_w,"%h %h %h %h %h ",local_clock[31:24],local_clock[23:16],local_clock[15:8],local_clock[7:0],RXD) ;

                                               $fclose(fp_w);
                                         end

                                          4'd5:begin 
                                               fp_w =$fopen("../data/data015.txt","a+");
                                               $fwrite(fp_w,"%h %h %h %h %h ",local_clock[31:24],local_clock[23:16],local_clock[15:8],local_clock[7:0],RXD ) ;

                                               $fclose(fp_w);
                                          end

                                          4'd6:begin 
                                               fp_w =$fopen("../data/data016.txt","a+");
                                               $fwrite(fp_w,"%h %h %h %h %h ",local_clock[31:24],local_clock[23:16],local_clock[15:8],local_clock[7:0],RXD ) ;

                                               $fclose(fp_w);
                                          end

                                          4'd7:begin 
                                               fp_w =$fopen("../data/data017.txt","a+");
                                               $fwrite(fp_w,"%h %h %h %h %h ",local_clock[31:24],local_clock[23:16],local_clock[15:8],local_clock[7:0],RXD ) ;

                                               $fclose(fp_w);
                                          end 
                                        
                                        endcase
                                        write_file_state <=TRANS_S;                                                           
                             end                      
                       end

                       TRANS_S:begin                  
                         
                              if( (RXDV==1'b1) )begin
                                   pkt_length_cnt <=pkt_length_cnt +16'd1;
                                    
                                         case(result)
                                         4'd0:begin 
                                               fp_w =$fopen("../data/data010.txt","a+");
                                               $fwrite(fp_w,"%h ",RXD) ;
                                               $fclose(fp_w);
                                         end

                                          4'd1:begin 
                                               fp_w =$fopen("../data/data011.txt","a+");
                                               $fwrite(fp_w,"%h ",RXD) ;

                                               $fclose(fp_w);
                                          end

                                          4'd2:begin 
                                               fp_w =$fopen("../data/data012.txt","a+");
                                               $fwrite(fp_w,"%h ",RXD) ;

                                               $fclose(fp_w);
                                          end
                                          
                                          4'd3:begin 
                                               fp_w =$fopen("../data/data013.txt","a+");
                                               $fwrite(fp_w,"%h ",RXD) ;
                                               $fclose(fp_w);
                                          end  

                                         4'd4:begin 
                                               fp_w =$fopen("../data/data014.txt","a+");
                                               $fwrite(fp_w,"%h ",RXD) ;

                                               $fclose(fp_w);
                                         end

                                          4'd5:begin 
                                               fp_w =$fopen("../data/data015.txt","a+");
                                               $fwrite(fp_w,"%h ",RXD) ;

                                               $fclose(fp_w);
                                          end

                                          4'd6:begin 
                                               fp_w =$fopen("../data/data016.txt","a+");
                                               $fwrite(fp_w,"%h ",RXD) ;

                                               $fclose(fp_w);
                                          end
                                          
                                          4'd7:begin 
                                               fp_w =$fopen("../data/data017.txt","a+");
                                               $fwrite(fp_w,"%h ",RXD) ;

                                               $fclose(fp_w);
                                          end 
                                        endcase 

                                        write_file_state <=TRANS_S;
                                        
                             end
                             else begin
                                         case(result)
                                         4'd0:begin 
                                               fp_w =$fopen("../data/data010.txt","a+");
                                               $fwrite(fp_w,"%h%h%h%h\n",4'h1,4'h1,4'h1,4'h1 ) ;

                                               $fclose(fp_w);

                                         end

                                          4'd1:begin 
                                               fp_w =$fopen("../data/data011.txt","a+");
                                               $fwrite(fp_w,"%h%h%h%h\n",4'h1,4'h1,4'h1,4'h1 ) ;

                                               $fclose(fp_w);

                                          end

                                          4'd2:begin 
                                               fp_w =$fopen("../data/data012.txt","a+");
                                               $fwrite(fp_w,"%h%h%h%h\n",4'h1,4'h1,4'h1,4'h1 ) ;

                                               $fclose(fp_w);

                                          end

                                          4'd3:begin 
                                               fp_w =$fopen("../data/data013.txt","a+");
                                               $fwrite(fp_w,"%h%h%h%h\n",4'h1,4'h1,4'h1,4'h1 ) ;
                                                     
                                               $fclose(fp_w);
                                          end   

                                          
                                          4'd4:begin 
                                               fp_w =$fopen("../data/data014.txt","a+");
                                               $fwrite(fp_w,"%h%h%h%h\n",4'h1,4'h1,4'h1,4'h1 ) ;

                                               $fclose(fp_w);
                                         end

                                          4'd5:begin 
                                               fp_w =$fopen("../data/data015.txt","a+");
                                               $fwrite(fp_w,"%h%h%h%h\n",4'h1,4'h1,4'h1,4'h1 ) ;

                                               $fclose(fp_w);
                                          end

                                          4'd6:begin 
                                               fp_w =$fopen("../data/data016.txt","a+");
                                               $fwrite(fp_w,"%h%h%h%h\n",4'h1,4'h1,4'h1,4'h1 ) ;

                                               $fclose(fp_w);
                                          end

                                          4'd7:begin 
                                               fp_w =$fopen("../data/data017.txt","a+");
                                               $fwrite(fp_w,"%h%h%h%h\n",4'h1,4'h1,4'h1,4'h1 ) ;
                                                     
                                               $fclose(fp_w);
                                          end        
                                          endcase

                                        write_file_state <=WAIT_S;
                             end
                       end
                   
                     
                  endcase      
            end           
      end
endmodule
