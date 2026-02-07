/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * reg_file module
    * Version 1.0
*/

`include "cpu.v"
`include "data_memory.v"

module Testbench;
    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;
    reg [7:0] instr_mem [0:1023];
    //cpu mycpu(PC, INSTRUCTION, CLK, RESET);
    wire [7:0] data_memory_readdata, data_memory_writedata, address;
    wire read, write, busywait;

    initial
    begin
        
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        $readmemb("instr_mem.mem", instr_mem);
    end
    
    assign #2 INSTRUCTION ={instr_mem[PC+3] , instr_mem[PC+2] , instr_mem[PC+1],instr_mem[PC]};

    cpu mycpu(PC, INSTRUCTION, CLK, RESET,busywait,read,write,data_memory_readdata,address,data_memory_writedata);
    data_memory mydata_memory(CLK,RESET,read,write,address,data_memory_writedata,data_memory_readdata,busywait);


    integer i;
    integer j;
    initial begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, Testbench);
        
        for (i=0 ;i<8;i=i+1)
            $dumpvars(1,Testbench.mycpu.regfile.REGISTER[i]);
        
        for (j=0 ;j<256;j=j+1)
            $dumpvars(1,Testbench.mydata_memory.memory_array[j]);
        
        RESET = 1'b0;
        CLK = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1;
        #6
        RESET = 0;
        // finish simulation after some time
        #350
        $finish;
    end
        
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
    
endmodule