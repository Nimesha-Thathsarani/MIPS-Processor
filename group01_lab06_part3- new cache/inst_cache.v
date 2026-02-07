/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description :

This file presents a skeleton implementation of the cache controller using a Finite State Machine model. Note that this code is not complete.
*/


module inst_cache (
    // Cache to CPU interface
    input clk,
    input [31:0] PC,
    input reset,
    output reg [31:0] CPUinstruction,
    output reg CPUbusywait,

    // Cache to memory interface
    input [127:0] readinst,
    input inst_mem_busywait,
    output reg inst_mem_read,
    output reg [5:0] inst_mem_address
);

    /************************************************************************************
    *                                  Structure of the Cache                          *
    *                                                                                  *
        valid bit (1 bit) = cache[131]
        tag (3 bits) = cache[130:128]
        instructions (32 bits) = cache[127:0]
    *           first instruction = cache[127:96]
    *           second instruction = cache[95:64]
    *           third instruction = cache[63:32]
    *           fourth instruction = cache[31:0]   
    */
    reg valid_bit [7:0];
    reg [2:0]tag_bit [7:0];
    reg [31:0] cache [31:0];

    wire valid;
    wire [2:0] cache_tag;
    wire [127:0] instruction_block;

    // Address decoding
    wire [1:0] offset;
    wire [2:0] index;
    wire [2:0] tag;

    assign #1 offset = PC[3:2];
    assign #1 index = PC[6:4];
    assign #1 tag = PC[9:7];

    assign #1 cache_tag = tag_bit[index];
    assign #1 instruction_block = {cache[{index,2'b00}], cache[{index,2'b01}], cache[{index,2'b10}], cache[{index,2'b11}]};
    assign #1 valid = valid_bit[index];

    wire Hit;
    
    always @(PC)
    begin
        CPUbusywait = 1;
    end

    
    //hit or miss
    assign #0.9 Hit = (valid) && (cache_tag == tag);
    
    //Mnage the busywait signal 
    // always @(clk) begin
    //     if (Hit) begin
    //         CPUbusywait = 0;
    //     end
    // end 


    //read hit
    always @(*)begin
        if(Hit)begin
            CPUbusywait =0;
            inst_mem_read =0;
            case(offset)
                2'b00: CPUinstruction = instruction_block[127:96];
                2'b01: CPUinstruction = instruction_block[95:64];
                2'b10: CPUinstruction = instruction_block[63:32];
                2'b11: CPUinstruction = instruction_block[31:0];
                default: CPUinstruction = 32'dx;
            endcase
            

        end

        else begin
            CPUbusywait = 1;
            inst_mem_read = 1;
            inst_mem_address = {tag, index};
        end
    end
//update cache after reading from memory
    always @(inst_mem_busywait)begin
        if(!inst_mem_busywait)begin
            valid_bit[index] = 1'b1;
            tag_bit[index] = tag;
            cache[{index,2'b00}] = readinst[31:0];
            cache[{index,2'b01}] = readinst[63:32];
            cache[{index,2'b10}] = readinst[95:64];
            cache[{index,2'b11}] = readinst[127:96];
        end
    end
   

   
   
    // Cache Controller FSM
    parameter IDLE = 3'b000, MEM_READ = 3'b001;
    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        
        case (state)
            IDLE: begin
                if (!Hit)
                    next_state = MEM_READ;  // Read miss
                else
                    next_state = IDLE;   // Hit
            end
            
            MEM_READ: begin
                if (!inst_mem_busywait)
                    next_state = IDLE;    // Memory read done, move to IDLE
                else    
                    next_state = MEM_READ;  // Wait for memory read
            end
            
            // CACHE_UPDATE: begin
            //     next_state = IDLE;
            // end

        endcase
    end

    // Combinational output logic
    always @(*) begin
        case (state)
            IDLE: begin
                inst_mem_read = 0;
                inst_mem_address= 6'dx;
                //CPUbusywait = 0;
            end
            
            MEM_READ: begin
                inst_mem_read = 1;
                inst_mem_address = {tag, index};
                CPUbusywait = 1;

            end
                
            // CACHE_UPDATE: begin
            //     inst_mem_read = 0;
            //     inst_mem_address = 6'dx;
            //     CPUbusywait = 1;
            //     cache[index][127:0] = readinst;  // Update cache with data from memory
            //     cache[index][131] = 1'b1;   // Set valid bit to 1
            //     cache[index][130:128] = tag;  // Set tag
            // end

        endcase
    end
    always @(posedge clk)begin
        if(reset)begin
            state = IDLE;
        end
        else begin
            state = next_state;
        end
    end
    // Sequential logic for state transitioning 
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state = IDLE;
            //CPUbusywait = 0;
            for (i = 0; i < 8; i = i + 1) begin
                valid_bit[i] = 1'b0;   // Set valid bit to 0
                tag_bit[i] = 3'b000;   // Set tag to 0
            end
         end //else begin
        //     state = next_state;
        // end
    end



endmodule
