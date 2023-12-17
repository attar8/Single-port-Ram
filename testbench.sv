// Code your testbench here
// or browse Examples

module tb_RAM;
  
  wire [7:0] tb_data_out;
  reg [7:0]tb_data_in;
  reg [4:0]tb_address;
  reg tb_clk, tb_reset, tb_write_enable, tb_read_enable ;
  reg [7:0]data_out;
  
  integer i, flag;
  
  //memory
  reg [7:0]tb_mem[31:0];
  
  // Design module instantiation
  RAM R1(.data_out(tb_data_out), .data_in(tb_data_in), .address(tb_address), .clk(tb_clk), .reset(tb_reset), .write_enable(tb_write_enable), .read_enable(tb_read_enable));
  
  // clock generation with frequency = 50MHz => T = 20ns
  initial 
  begin
  tb_clk = 0;
  forever #10 tb_clk = ~tb_clk;
  end
  
    
//task reset
  task reset;

    tb_reset = 1'b1;
    #40;
    tb_reset = 1'b0;
   
  endtask
  
  initial
  begin
  $dumpfile("dump.vcd");
  $dumpvars;
    
    testcase1();
    testcase2();
    testcase3();
    testcase4();
    testcase5();
    
  $finish();
  end
  
  // Write task
  task write;
  output [7:0]tb_mem, tb_data_in;
  input [4:0]tb_address;
  begin
  tb_data_in = $random;
  tb_mem = tb_data_in;
  end
  endtask
  
  //Read task
  task read;
  output [7:0]data_out;
  input [7:0]tb_mem;
  data_out = tb_mem;
  endtask
   
  // Checking the data received from the design module 
  task check;
  inout flag;
  input [7:0]data_out, tb_data_out;
  begin
  if(data_out != tb_data_out)
  flag = 0;
  end
  endtask
   
  // task to display the result(pass/fail)
  task result;
  input flag;
  begin
  if (flag)
    $display(".....................pass....................");
  else
    $display(".....................fail....................");
  end
  endtask
  
  
  
      
  
  // Testcase-1:Write and read data from address
 
  task testcase1();
  begin
      reset;    
     tb_write_enable = 1 ;
     flag=1;

    $display(".................... Testcase 1.....................");
    
    for(i=0; i<32; i++)
       begin
       tb_address = i;
       write(tb_mem[tb_address], tb_data_in, tb_address);
       #20;
         $display($time,"\tWriting: tb_address = %0d tb_data_in = %0d tb_mem_address = %0d",tb_address,tb_data_in,tb_mem[tb_address]);
       end
 
  tb_read_enable = 1;
  tb_write_enable = 0;
  flag = 1;
    
    for(i=0; i<32; i++)
      begin
      tb_address = i;
      read(data_out, tb_mem[tb_address]);
      #20;
       $display($time,"\tReading:  tb_address = %0d, data_out = %0d, tb_data_out = %0d",tb_address, data_out,tb_data_out);
      check(flag, data_out, tb_data_out);
      #20;
      end
     result(flag);
  end
 endtask
    
  
  
 
    
  // Testcase-2:Write and read data from all locations alternatively
  
  task testcase2();
  begin
    reset;
  tb_read_enable = 0 ;
  tb_write_enable = 0;
  flag = 1;
    
    $display("....................... Testcase 2 ........................");
  
    for(i=0;i<32;i++)
     begin 
     
     tb_write_enable = 1;
     tb_read_enable = 0;
     tb_address = i;
     write(tb_mem[tb_address], tb_data_in, tb_address);
     $display($time,"\tWriting: tb_address = %0d tb_data_in = %0d tb_mem_address = %0d",tb_address,tb_data_in,tb_mem[tb_address]);
     #20;
     tb_write_enable = 0;
     tb_read_enable = 1;
     read(data_out, tb_mem[tb_address]);
       #20;
     $display($time,"\tReading:  tb_address = %0d, data_out = %0d, tb_data_out = %0d",tb_address, data_out,tb_data_out);
     check(flag, data_out, tb_data_out);
     #20;
     end
     result(flag);
  end
  endtask
        
    
 
  // Testcase-3:Write and read data from random address locations
  
  task testcase3();
  begin
    reset;
   
  tb_read_enable = 0 ;
  tb_write_enable = 0;
  flag = 1;
    
    $display(".................... Testcase 3........................");
    
    for(i=0;i<10;i++)
     begin
     tb_address = $random;
     tb_write_enable = 1;
     tb_read_enable = 0;
     write(tb_mem[tb_address], tb_data_in, tb_address);
     #20;
     $display($time,"\tWriting: tb_address = %0d tb_data_in = %0d tb_mem_address = %0d",tb_address,tb_data_in,tb_mem[tb_address]);
    
     tb_write_enable = 0;
     tb_read_enable = 1;
     read(data_out, tb_mem[tb_address]);
     #20;
    $display($time,"\tReading:  tb_address = %0d, data_out = %0d, tb_data_out = %0d",tb_address, data_out,tb_data_out);
     check(flag, data_out, tb_data_out);
     #20;
     end
     result(flag);
  end
  endtask
    
  
  // Testcase-4:Write and read randomly from address
  
  task testcase4();
  begin
    reset;
  
  tb_read_enable = 0 ;
  tb_write_enable = 0;
  flag = 1;
    
    
     $display("......................Testcase 4 ......................");
    for(i=0;i<32;i++)
     begin
     tb_address = i;
     tb_write_enable = $random;
     tb_read_enable = $random;
     write(tb_mem[tb_address], tb_data_in, tb_address);
     $display($time,"\tWriting: tb_address = %0d tb_data_in = %0d tb_mem_address = %0d",tb_address,tb_data_in,tb_mem[tb_address]);
     #20;
     tb_write_enable = $random;
     tb_read_enable = $random;
     read(data_out, tb_mem[tb_address]);
     #20;
     $display($time,"\tReading:  tb_address = %0d, data_out = %0d, tb_data_out = %0d",tb_address, data_out,tb_data_out);
     check(flag, data_out, tb_data_out);
     #20;
     end
     result(flag);
  end
  endtask
  
  
  //Testcase-5:Write and read data from address simultaneously

  task testcase5();
  begin
      reset;
    tb_read_enable = 0;
    tb_write_enable = 0;
    flag = 1;
       $display("......................Testcase 5.........................");
       for(i=0;i<32;i++)
      begin
        tb_address = i;
        tb_write_enable = $random;
        tb_read_enable = $random;
       
        if (tb_write_enable && ( ~tb_read_enable))
          begin
            write(tb_mem[tb_address], tb_data_in, tb_address);
            $display($time,"\tWriting: tb_address = %0d tb_data_in = %0d tb_mem_address = %0d",tb_address,tb_data_in,tb_mem[tb_address]);
        	#20;
          end
        else if(tb_read_enable && ( ~ tb_write_enable))
          begin
            read(data_out, tb_mem[tb_address]);
              #20;
            $display($time,"\tReading:  tb_address = %0d, data_out = %0d, tb_data_out = %0d",tb_address, data_out,tb_data_out);
            check(flag, data_out, tb_data_out);
            #20;
          end
        else
          $display("\tRead/Write operation cannot be performed");
      end
    result(flag); 
      end
    endtask
endmodule


  
  