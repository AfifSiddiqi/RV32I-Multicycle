
//`timescale 1 ps / 1 ps

module testbench();
    
    reg clk, rst;

    soc_top dut( .clk(clk), .rst(rst));

    
    initial
    begin
		  #0
		  clk = 1'b0;
        rst = 1'b0;
        #60;
        rst =1'b1;
		 
    end
	 
	 
    always 
    begin
        clk = ~ clk;
        #50;  
        
    end
endmodule