`Xinclude "alu.v"
module alu_tb;

    reg [7:0] data1, data2;
    reg [2:0] select;
    wire [7:0] result;
    
    // Corrected instantiation to match the provided ALU module
    ALUUnit myalu(data1, data2, select, result);
       
    initial begin
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("alu_wavedata.vcd");
        $dumpvars(0, myalu);
        
        // Initial values
        data1 = 8'd10;
        data2 = 8'd20;
        select = 3'b000; // Forward data2
        #20; // Waiting time increased to observe the change in waveform
        
        select = 3'b001; // Add data1 and data2
        #20;
        
        select = 3'b010; // AND data1 and data2
        #20;
        
        select = 3'b011; // OR data1 and data2
        #20;
        
        data1 = 8'd5;
        data2 = 8'd10;
        select = 3'b000; // Repeating the process with new data values
        #20;
        
        // Continue with other operations...
        
        // Last step to ensure all changes are captured before the simulation ends
        #10;
        $finish; // Properly terminate the simulation
    end
endmodule
