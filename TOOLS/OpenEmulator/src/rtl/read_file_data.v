`define SEEK_SET 0    //0104                                                                                                    
`define SEEK_CUR 1                                                                                                              
`define SEEK_END 2                                                                                                              
                                                                                                                                
module read_file_data #(parameter PLATFORM="Modelsim")(                                                                                                                               
	input clk,                                                                                                                  
	input rst_n,                                                                                                                
	                                                                                                                            
	input [3:0] host_r_id,                                                                                                      
	input [31:0] local_clock,                                                                                                   
	                                                                                                                            
	output	reg	[7:0]	TXD,                                                                                                    
	output	reg	TX_EN                                                                                                           
);                                                                                                                              
                                                                                                                                
	reg [4:0] read_file_state;		                                                                                            
	localparam    INIT_S =5'd0,                                                                                                 
                  IDLE_S =5'd1,                                                                                                 
                  GET_LENGTH_S =5'd2,   
				  GET_SENDTIME_S =5'd3,   
                  ADD_PREAMBLE_S =5'd4,                                                                                                                                                                                
                  TRANS_S =5'd5,                                                                                                
                  IFS_S =5'd6,                                                                                                  
                  WAIT_SEND_S =5'd7,
				  START_S=5'd8,
				  DALAY_S=5'd9;                                                                                            
	                                                                                                                           	                                                                                                                            
	//////////////////////////////                                                                                              
	reg [3:0] result;
	reg [3:0] dalay_cnt;  //dalay		
	reg [7:0] read_mem_reg; 
	reg [7:0] read_mem_reg1; 	
	reg [31:0]  mem_cnt;                                                                                                        
	                                                                                                                            
	reg  length_cnt;   // 
	reg [15:0] pktlength_cnt;                                                                                                   
	                                                                                                                            
	reg  send_wait_cnt;                                                                                                         
	reg [15:0] send_wait_time;                                                                                                  
	                                                                                                                            
	reg [3:0] preamble_cnt;	                                                                                                                                                                                                   
	                                                                                                                                                                                                                                       
	reg [15:0] data_cnt;                                                                                                        
	                                                                                                                            
	reg [3:0] ifs_cnt;                                                                                                          
	                                                                                                                            
	reg [31:0] sendpkt_cnt;                                                                                                     
	reg [31:0] wait_pat_cnt;                                                                                                    
                                                                                                                                
	integer fp_r;  //  文件句柄   
	integer fp_r1;  //  文件句柄   	
	integer count; //  fscanf函数返回值 
	integer count1; //  fscanf函数返回值  		                                                                                                                            
always @(posedge clk or negedge rst_n)begin                                                                                 
	if(!rst_n)begin                                                                                                        
        TXD <=8'b0;                                                                                                         
        TX_EN <=1'b0;                                                                                                       
        result <=4'd0;	                                                                                                    
	    mem_cnt <=32'd0;                                                                                                    	                                                                                                                        
	    length_cnt <=1'd0; 
	    pktlength_cnt <=16'd0;                                                                                              	                                                                                                                        
	    send_wait_cnt <=1'd0;                                                                                               
	    send_wait_time <=16'd0;                                                                                             
		read_mem_reg<=8'b0; 
		read_mem_reg1<=8'b0; 		
	    preamble_cnt <=4'd0;	                                                                                            

		dalay_cnt 	<=	4'd0;
                                                                                                    
	    data_cnt <=16'd0;                                                                                                                        
	    ifs_cnt <=4'd0;                                                                                                     
        sendpkt_cnt <=32'd0;                                                                                                
	    wait_pat_cnt <=32'd0 ;                                                                                              
                                                                                                                            
        read_file_state <=INIT_S;                                                                                           
	end                                                                                                                     
	else begin                                                                                                              
		case (read_file_state)                                                                                              
			INIT_S:begin                                                                                                    
                 case(host_r_id)                                                                                           
                    4'd0: begin                                                                                        
                          result <=4'd0;                                                                               
					      fp_r <=$fopen("../data/data110.txt","r");//打开文本
  						  fp_r1 <=$fopen("../data/data210.txt","r"); 
					      read_file_state <=IDLE_S;                                                                    
                    end                                                                                                
                    4'd1: begin                                                                                        
                          result <=4'd1;                                                                               
					      fp_r <=$fopen("../data/data111.txt","r");
						  fp_r1 <=$fopen("../data/data211.txt","r"); 
					      read_file_state <=IDLE_S;                                                                    
                    end                                                                                                
					4'd2: begin                                                                                        
                          result <=4'd2;                                                                               
					      fp_r <=$fopen("../data/data112.txt","r"); 
						  fp_r1 <=$fopen("../data/data212.txt","r"); 
					      read_file_state <=IDLE_S;                                                                    
                    end                                                                                                
					4'd3: begin                                                                                        
                          result <=4'd3;                                                                               
					      fp_r <=$fopen("../data/data113.txt","r"); 
						  fp_r1 <=$fopen("../data/data213.txt","r"); 
					      read_file_state <=IDLE_S;                                                                    
                    end                                                                                                
                    4'd4: begin                                                                                        
                          result <=4'd4;                                                                               
					      fp_r <=$fopen("../data/data114.txt","r"); 
						  fp_r1 <=$fopen("../data/data214.txt","r"); 
					      read_file_state <=IDLE_S;                                                                    
                    end                                                                                                
                    4'd5: begin                                                                                        
                          result <=4'd5;                                                                               
					      fp_r <=$fopen("../data/data115.txt","r");  
						  fp_r1 <=$fopen("../data/data215.txt","r"); 
					      read_file_state <=IDLE_S;                                                                    
                    end                                                                                                
					4'd6: begin                                                                                        
                          result <=4'd6;                                                                               
					      fp_r <=$fopen("../data/data116.txt","r"); 
						  fp_r1 <=$fopen("../data/data216.txt","r"); 
					      read_file_state <=IDLE_S;                                                                    
                    end                                                                                                
					4'd7: begin                                                                                        
                          result <=4'd7;                                                                               
					      fp_r <=$fopen("../data/data117.txt","r"); 
						  fp_r1 <=$fopen("../data/data217.txt","r"); 
					      read_file_state <=IDLE_S;                                                                    
                    end                                                                                                                                                                                               
                    default: read_file_state <=INIT_S;                                                                 
				 endcase                                                                                                   	                                                                                                                        
			 end                                                                                                            

            IDLE_S:begin                                                                                                    
                 case(host_r_id)                                                                                    
                    4'd0: begin                                                                                        
                          result <=4'd0; 
						  count1 <=$fscanf(fp_r1,"%h",read_mem_reg1);//标识文本中读取报文完成写入标志“1”
					      read_file_state <=START_S;                                                              
                    end                                                                                                
                    4'd1: begin                                                                                        
                          result <=4'd1;             
						  count1 <=$fscanf(fp_r1,"%h",read_mem_reg1);					  
					      read_file_state <=START_S;                                                              
                    end                                                                                                
					4'd2: begin                                                                                        
                          result <=4'd2;  						  
						  count1 <=$fscanf(fp_r1,"%h",read_mem_reg1);						  
					      read_file_state <=START_S;                                                              
                    end                                                                                                
					4'd3: begin                                                                                        
                          result <=4'd3;         
						  count1 <=$fscanf(fp_r1,"%h",read_mem_reg1);						  
					      read_file_state <=START_S;                                                              
                    end                                                                                                
                                                                                                                       
                    4'd4: begin                                                                                        
                          result <=4'd4; 
						  count1 <=$fscanf(fp_r1,"%h",read_mem_reg1);						  
					      read_file_state <=START_S;                                                              
                    end                                                                                                
                    4'd5: begin                                                                                        
                          result <=4'd5;
						  count1 <=$fscanf(fp_r1,"%h",read_mem_reg1);						  
					      read_file_state <=START_S;                                                              
                    end                                                                                                
					4'd6: begin                                                                                        
                          result <=4'd6;  
						  count1 <=$fscanf(fp_r1,"%h",read_mem_reg1);						  
					      read_file_state <=START_S;                                                              
                    end                                                                                                
					4'd7: begin                                                                                        
                          result <=4'd7;  
						  count1 <=$fscanf(fp_r1,"%h",read_mem_reg1);						  
					      read_file_state <=START_S;                                                              
                    end                                                                                                                                                                                            
                    default: read_file_state <=IDLE_S;                                                                 
                endcase                                                                                            
            end 
            START_S:begin                                                                                                    
                 case(host_r_id)                                                                                                                                                                                
					4'd0: begin                                                                                         
						  if((count1==32'd1)&&(read_mem_reg1==8'b1))begin	//当fscanf函数返回值为1，并且读出报文写完标识为“1”	状态，开始读取报文					
							count <=$fscanf(fp_r,"%h",read_mem_reg);
							read_file_state <=DALAY_S; 
						  end
						  else begin 
							read_file_state <=IDLE_S;
						  end
                    end  
					4'd1: begin                                                                                         
						  if((count1==32'd1)&&(read_mem_reg1==8'b1))begin							
							count <=$fscanf(fp_r,"%h",read_mem_reg);
							read_file_state <=DALAY_S; 
						  end
						  else begin 
							read_file_state <=IDLE_S;
						  end
                    end  
					4'd2: begin                                                                                         
						  if((count1==32'd1)&&(read_mem_reg1==8'b1))begin							
							count <=$fscanf(fp_r,"%h",read_mem_reg);
							read_file_state <=DALAY_S; 
						  end
						  else begin 
							read_file_state <=IDLE_S;
						  end
                    end  
					4'd3: begin                                                                                         
						  if((count1==32'd1)&&(read_mem_reg1==8'b1))begin							
							count <=$fscanf(fp_r,"%h",read_mem_reg);
							read_file_state <=DALAY_S; 
						  end
						  else begin 
							read_file_state <=IDLE_S;
						  end
                    end  
					4'd4: begin                                                                                         
						  if((count1==32'd1)&&(read_mem_reg1==8'b1))begin							
							count <=$fscanf(fp_r,"%h",read_mem_reg);
							read_file_state <=DALAY_S; 
						  end
						  else begin 
							read_file_state <=IDLE_S;
						  end
                    end  
					4'd5: begin                                                                                         
						  if((count1==32'd1)&&(read_mem_reg1==8'b1))begin							
							count <=$fscanf(fp_r,"%h",read_mem_reg);
							read_file_state <=DALAY_S; 
						  end
						  else begin 
							read_file_state <=IDLE_S;
						  end
                    end  
					4'd6: begin                                                                                         
						  if((count1==32'd1)&&(read_mem_reg1==8'b1))begin							
							count <=$fscanf(fp_r,"%h",read_mem_reg);
							read_file_state <=DALAY_S; 
						  end
						  else begin 
							read_file_state <=IDLE_S;
						  end
                    end 
					4'd7: begin                                                                                         
						  if((count1==32'd1)&&(read_mem_reg1==8'b1))begin							
							count <=$fscanf(fp_r,"%h",read_mem_reg);
							read_file_state <=DALAY_S; 
						  end
						  else begin 
							read_file_state <=IDLE_S;
						  end
                    end  	 					
                    default: read_file_state <=INIT_S;                                                                 
                endcase                                                                                            
            end   			
			DALAY_S:begin//dalay cycle
				if(dalay_cnt < 4'd1)begin 
					dalay_cnt<=dalay_cnt+4'd1;
					read_file_state <=DALAY_S;
				end
				else begin
					dalay_cnt<=4'd0;
					read_file_state <=GET_LENGTH_S;				
				end
			end
            GET_LENGTH_S:begin  //获取报文长度字段                                                                                                                                                                       				
				if(length_cnt ==1'd0)begin                                                                      					                                                                      
					length_cnt <=1'd1;
					mem_cnt <= mem_cnt +32'd1;
					pktlength_cnt[15:8] <= read_mem_reg;
					count <=$fscanf(fp_r,"%h",read_mem_reg);
					read_file_state <=GET_LENGTH_S;                                                                 
				end      
				else begin
					pktlength_cnt[7:0] <= read_mem_reg;                                                             
					mem_cnt <= mem_cnt +32'd1;	                                                                    
					length_cnt <= 1'd0;
					count <=$fscanf(fp_r,"%h",read_mem_reg);
					read_file_state <=GET_SENDTIME_S; 							 							 
				end                                                                                                                                                            
            end                                                                                                                                                                                                          
            GET_SENDTIME_S:begin //获取报文输出间隔时间
				if(pktlength_cnt !=16'd0)begin                                                                                
				    if(send_wait_cnt ==1'd0)begin                                                                      
						mem_cnt <= mem_cnt +32'd1;
				    	send_wait_cnt <=1'd1;	
						send_wait_time[15:8] <= read_mem_reg; 
						count <=$fscanf(fp_r,"%h",read_mem_reg);
				    	read_file_state <=GET_SENDTIME_S;                                                                 
				    end      
				    else begin
				    	send_wait_time[7:0] <= read_mem_reg;  
						count <=$fscanf(fp_r,"%h",read_mem_reg);
				    	mem_cnt <= mem_cnt +32'd1;	                                                                    
				    	send_wait_cnt <= 1'd0;
				    	read_file_state <=WAIT_SEND_S; 							 							 
				    end
				end
				else begin
				    mem_cnt <= mem_cnt -32'd2;                                                                       
                    read_file_state <=IDLE_S; 
				end
            end                                                                                                               
		    ADD_PREAMBLE_S:begin   //添加前导码                                                                                         
				if( preamble_cnt <4'd7) begin                                                                           
				     TXD <=8'b0101_0101;                                                                                
				     TX_EN <=1'b1;                                                                                      
				     preamble_cnt <= preamble_cnt +3'd1;                                                                                                                                  
				     read_file_state <= ADD_PREAMBLE_S;                                                                 
				end                                                                                                     
				else begin                                                                                              
				    TXD <=8'b1101_0101;                                                                                 
                    TX_EN <=1'b1;                                                                                       
				    preamble_cnt <= 3'd0;                                                                               
				    read_file_state <=TRANS_S;                                                                     
				end                                                                                                     
		    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
			TRANS_S:begin	//传输报文			                                                                                    
				if(data_cnt < pktlength_cnt-1)begin                                                                       				                                                                 
					 TXD <= read_mem_reg; 
					 TX_EN <=1'b1; 
					 count <=$fscanf(fp_r,"%h",read_mem_reg);				                                                                                       
                     mem_cnt <= mem_cnt +32'd1;                                                                         
					 data_cnt <= data_cnt+16'd1;			                                                            
				     read_file_state <=TRANS_S;                                                                         
				end                                                                                                     
				else begin                                                                                              
				     TXD <= read_mem_reg;                                                                                       
				     TX_EN <=1'b1;                                                                                      
				  	 mem_cnt <= mem_cnt; 
				     data_cnt <= 16'd0;                                                                                 
					 pktlength_cnt <= 16'd0 ;                                                                           
				     read_file_state <=IFS_S;                                                                           
				end                                                                                                         
			end                                                                                                                                                                                                                                            			                                                                                                            
			//	                                                                                                            
			IFS_S:begin    //报文间隔                                                                                                 				                                                                                                            
				if( ifs_cnt < 4'd11) begin                                                                              
				     ifs_cnt <= ifs_cnt +4'd1;                                                                          
				     read_file_state <= IFS_S;                                                                          
                                                                                                                        
				     TXD <= 8'b0;                                                                                       
                     TX_EN <=1'b0;                                                                                      
				end                                                                                                     
				else begin                                                                                              
				     ifs_cnt <= 4'd0;                                                                                   
                     mem_cnt <= mem_cnt;                                                                                
					 send_wait_time<= 16'd0;                                                                            
					 read_mem_reg <= 8'h0;   
					 read_mem_reg1 <= 8'h0; 
				     sendpkt_cnt <=32'd0;                                                                               
				     read_file_state <= IDLE_S;                                                                         
                                                                                                                        
				end                                                                                                     
			end                                                                                                             
			                                                                                                                
			WAIT_SEND_S:begin   //等待发送                                                                                            
                if(send_wait_time ==16'd0)begin                                                                         
                     TXD <= 8'b0;                                                                                       
				     TX_EN <=1'b0;                                                                                                                                                                                                                 
                     sendpkt_cnt <=32'd0;                                                                               
				     read_file_state <= ADD_PREAMBLE_S;                                                                 
                end                                                                                                     
                else if((sendpkt_cnt ==32'd0) ) begin                                                                   
                     sendpkt_cnt <= sendpkt_cnt+ 32'd1;                                                                 
                     wait_pat_cnt <=send_wait_time;	                                                                    
                     TXD <= 8'b0;                                                                                       
				     TX_EN <=1'b0;                                                                                      			                                                                                                            
				     read_file_state <= WAIT_SEND_S;                                                                    
				end                                                                                                     
                else if((sendpkt_cnt <wait_pat_cnt-32'd1)) begin                                                        
                     sendpkt_cnt <= sendpkt_cnt+ 32'd1;                                                                                                                                                                                             
				     read_file_state <= WAIT_SEND_S;                                                                    
				end                                                                                                     
				else begin                                                                                              
                     TX_EN <=1'b0;    
					 TXD <= 8'b0;    
                     sendpkt_cnt <=32'd0;                                                                               
				     read_file_state <= ADD_PREAMBLE_S;                                                                 
				end                                                                                                       
			end  
            default:begin
                TX_EN <=1'b0;   
                TXD <= 8'b0;                  
                read_file_state   <= IDLE_S;
            end			
		endcase                                                                                                             
	end                                                                                                                     
end                                                                                                                         
endmodule	                                                                                                                    
