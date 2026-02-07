/*
    * CO224 - Computer Architecture
    * Lab 05 - Part 3
    * reg_file module
    * Version 1.0
*/
`timescale 1ns / 1ps

`include "cpu.v"
`include "data_memory.v"
`include "dcacheFSM_skeleton.v"
`include "inst_cache.v"
`include "instr_memory.v"


module Testbench;
    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION, mem_writedata, mem_readdata;
    reg [7:0] instr_mem [0:1023];
    //cpu mycpu(PC, INSTRUCTION, CLK, RESET);
    wire [7:0] CPU_address, CPU_writedata, CPU_readdata;
    wire CPU_read, CPU_write,CPU_busywait, mem_read, mem_write, mem_busywait;
    wire [5:0] mem_address;
    
    wire inst_cpu_busywait,busywait;
    wire [127:0] readinst;
    wire inst_mem_busywait,inst_mem_read;
    wire [5:0] inst_mem_address;


    // initial
    // begin
        
    //     // METHOD 2: loading instr_mem content from instr_mem.mem file
    //     $readmemb("instr_mem.mem", instr_mem);
    // end
    
    //assign #2 INSTRUCTION ={instr_mem[PC+3] , instr_mem[PC+2] , instr_mem[PC+1],instr_mem[PC]};
    
    dcache cache(CLK,CPU_address,RESET,CPU_read,CPU_write,CPU_writedata,CPU_readdata,CPU_busywait,mem_address,mem_read,mem_write,mem_writedata,mem_readdata,mem_busywait);
    data_memory mydata_memory(CLK,RESET,mem_read,mem_write,mem_address,mem_writedata,mem_readdata,mem_busywait);

    //instrCache myinst_cache(CLK,RESET,PC,INSTRUCTION,inst_cpu_busywait,inst_mem_busywait,readinst,inst_mem_address,inst_mem_read );
    inst_cache myinst_cache(CLK,PC,RESET,INSTRUCTION,inst_cpu_busywait,readinst,inst_mem_busywait,inst_mem_read ,inst_mem_address);
    instruction_memory myinstruction_memory(CLK,inst_mem_read,inst_mem_address,readinst,inst_mem_busywait);
    
    assign busywait = inst_cpu_busywait || CPU_busywait;

    cpu mycpu(PC, INSTRUCTION, CLK, RESET,busywait,CPU_read,CPU_write,CPU_readdata,CPU_address,CPU_writedata);

    

    integer i;
    integer j;
    initial begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, Testbench);
        
        for (i=0 ;i<8;i=i+1)
            $dumpvars(1,Testbench.mycpu.regfile.REGISTER[i]);
        
        // for (j=0 ;j<256;j=j+1)
        //     $dumpvars(1,Testbench.mydata_memory.memory_array[j]);

        for (j=0 ;j<8;j=j+1)
            $dumpvars(1,Testbench.cache.cache[j]);

        for(j=0;j<1024;j=j+1)
            $dumpvars(1,Testbench.myinstruction_memory.memory_array[j]);

        // for(j=0;j<8;j=j+1)
        //     $dumpvars(1,Testbench.myinst_cache.instrCache_entries[j]);

        for(j=0;j<32;j=j+1)
            $dumpvars(1,Testbench.myinst_cache.cache[j]);
        
        RESET = 1'b0;
        CLK = 1'b0;
        
        // TODO: Reset the CPU (by giving a pulse to RESET signal) to start the program execution
        RESET = 1;
        #6
        RESET = 0;
        // finish simulation after some time
        #5000
        $finish;
    end
        
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
    
endmodule