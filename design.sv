// Code your design here

module RAM(data_out, clk, reset, address, data_in, write_enable, read_enable);  
 
 // parameter declaration
  parameter addr_size = 4;
  parameter data_size = 7;
  parameter mem_size = 31;
  
  // port declaration output and input
  output reg [data_size:0]data_out;
  input [data_size:0]data_in;
  input [addr_size:0]address;
  input clk, reset, write_enable, read_enable;
  
  reg [data_size:0]mem[mem_size:0];//memory
  
  integer i;
  
  always@(posedge clk)
    begin
      if(reset)
        begin
          for(i=0; i<mem_size; i++)
            mem[i] <= 8'bz;
        end
      else if(write_enable)
        begin
        mem[address] <= data_in;
      $display("address=%d",address);
        end
      else
        mem[address] <= mem[address];

    end
    
  always@(posedge clk)
    begin
      if(reset)
           data_out <= 8'bz;
          else if(read_enable)
        data_out <= mem[address];
      else
        data_out <= 8'bz;
      
    end
    
endmodule

     
  
 