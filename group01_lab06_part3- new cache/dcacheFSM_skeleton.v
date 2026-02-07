/*
Module  : Data Cache 
Author  : Isuru Nawinne, Kisaru Liyanage
Date    : 25/05/2020

Description :

This file presents a skeleton implementation of the cache controller using a Finite State Machine model. Note that this code is not complete.
*/


module dcache (
    // Cache to CPU interface
    input clk,
    input [7:0] CPUaddress,
    input reset,
    input CPUread,
    input CPUwrite,
    input [7:0] CPUwritedata,
    output reg [7:0] CPUreaddata,
    output reg CPUbusywait,

    // Cache to memory interface
    output reg [5:0] mem_address,
    output reg mem_read,
    output reg mem_write,
    output reg [31:0] mem_writedata,
    input [31:0] mem_readdata,
    input mem_busywait
);

    // Cache memory structure
    // valid bit --> 1 bit == cache[index][36]
    // dirty bit --> 1 bit == cache[index][35]
    // tag       --> 3 bits == cache[index][34:32]
    // data      --> 32 bits
    // data[0] --> 8 bits == cache[index][31:24]
    // data[1] --> 8 bits == cache[index][23:16]
    // data[2] --> 8 bits == cache[index][15:8]
    // data[3] --> 8 bits == cache[index][7:0]
    reg [36:0] cache [7:0]; 

    // Address decoding
    wire [1:0] offset;
    wire [2:0] index;
    wire [2:0] tag;

    // reg readaccess, writeaccess;

    // Decoding the address
 

    assign #1 offset = CPUaddress[1:0];
    assign #1 index = CPUaddress[4:2];
    assign #1 tag = CPUaddress[7:5];

    wire Hit;
    wire Dirty;

    always @(*)
    begin
        if(CPUread || CPUwrite)
            CPUbusywait = 1;
    end

    
    //hit or miss
    assign #0.9 Hit = (cache[index][36]) && (cache[index][34:32] == tag);
    assign Dirty = cache[index][35];

    //read hit
    always @(*)begin
        if(Hit && CPUread && !CPUwrite)begin
            CPUbusywait = 0;
            case(offset)
                2'b00: CPUreaddata = #1 cache[index][31:24];
                2'b01: CPUreaddata = #1 cache[index][23:16];
                2'b10: CPUreaddata = #1 cache[index][15:8];
                2'b11: CPUreaddata = #1 cache[index][7:0];
                default: CPUreaddata = #1 8'bxxxxxxxx;
            endcase
        end
    end

    //write hit
    always @(posedge clk) begin
        if (Hit && CPUwrite && !CPUread) begin
            CPUbusywait=0;
            case (offset)
                2'b00: cache[index][31:24] = #1 CPUwritedata;
                2'b01: cache[index][23:16] = #1 CPUwritedata;
                2'b10: cache[index][15:8] = #1 CPUwritedata;
                2'b11: cache[index][7:0] = #1 CPUwritedata;
            endcase
            cache[index][35] = 1'b1; // Set dirty bit to 1
            cache[index][36] = 1'b1; // Set valid bit to 1
        end
    end

    // Combinational logic for read and write access

    // always @(CPUread, CPUwrite, CPUaddress) begin
    
    //     readaccess = CPUread;
    //     writeaccess = CPUwrite;
    //     CPUbusywait = (CPUread || CPUwrite) ? 1'b1 : 1'b0;
    // end

    
    // reg writefrommem;

    // // Cache read and hit/miss check
    // always @(*) begin
    //     if (readaccess || writeaccess) begin
    //         // Checking for a hit
    //         Hit = #0.9 (cache[index][36]) && (cache[index][34:32] == tag);
    //         Dirty = cache[index][35];
    //         CPUbusywait = !Hit;

    //         // Asynchronous read
    //         case (offset)
    //             2'b00: CPUreaddata = #1 cache[index][31:24];
    //             2'b01: CPUreaddata = #1 cache[index][23:16];
    //             2'b10: CPUreaddata = #1 cache[index][15:8];
    //             2'b11: CPUreaddata = #1 cache[index][7:0];
    //             default: CPUreaddata = #1 8'bxxxxxxxx;
    //         endcase
    //     end
    // end

    //
    // Cache Controller FSM
    parameter IDLE = 3'b000, MEM_READ = 3'b001, MEM_WRITE = 3'b010 , CACHE_UPDATE = 3'b011;
    reg [2:0] state, next_state;

    // Combinational next state logic
    always @(*) begin
        
        case (state)
            IDLE: begin
                if ((CPUread || CPUwrite) && !Dirty && !Hit)
                    next_state = MEM_READ;  // Read miss
                else if ((CPUread || CPUwrite) && Dirty && !Hit)
                    next_state = MEM_WRITE;  // Write miss
                else
                    next_state = IDLE;   // Hit
            end
            
            MEM_READ: begin
                if (!mem_busywait)
                    next_state = CACHE_UPDATE;    // Memory read done, move to IDLE
                else    
                    next_state = MEM_READ;  // Wait for memory read
            end
            
            MEM_WRITE: begin
                if (!mem_busywait)
                    next_state = MEM_READ;   // Wait for memory write
                else    
                    next_state = MEM_WRITE;   // Memory write done, move to MEM_READ to read block into cache
            end
            CACHE_UPDATE: begin
                next_state = IDLE;
            end

        endcase
    end

    // Combinational output logic
    always @(*) begin
        case (state)
            IDLE: begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 32'dx;
                CPUbusywait = 0;
            end
            
            MEM_READ: begin

                mem_read = 1;
                mem_write = 0;
                mem_address = {tag, index};
                mem_writedata = 32'dx;
                CPUbusywait = 1;

            end
                
            CACHE_UPDATE: begin
                mem_read = 0;
                mem_write = 0;
                mem_address = 6'dx;
                mem_writedata = 32'dx;
                CPUbusywait = 1;
                cache[index][31:0] = mem_readdata;  // Update cache with data from memory
                cache[index][36] = 1'b1;   // Set valid bit to 1
                cache[index][35] = 1'b0;   // Set dirty bit to 0
                cache[index][34:32] = tag;  // Set tag
            end

            MEM_WRITE: begin
                mem_read = 0;
                mem_write = 1;
                mem_address = {cache[index][34:32], index};
                mem_writedata = cache[index][31:0];
                CPUbusywait = 1;
                if (!mem_busywait) begin
                    cache[index][36] = 1'b1;   // Set valid bit to 1
                    cache[index][35] = 1'b0;   // Set dirty bit to 0
                end
            end
        endcase
    end

    // Sequential logic for state transitioning 
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state = IDLE;
            //CPUbusywait = 0;
            for (i = 0; i < 8; i = i + 1) begin
                cache[i][36] = 1'b0;   // Set valid bit to 0
                cache[i][35] = 1'b0;   // Set dirty bit to 0
                cache[i][34:32] = 3'b000;   // Set tag to 0
            end
        end else begin
            state = next_state;
        end
    end

    // // Write hit handling
    // always @(posedge clk) begin
    //     if (Hit && writeaccess) begin
    //         case (offset)
    //             2'b00: cache[index][31:24] = CPUwritedata;
    //             2'b01: cache[index][23:16] = CPUwritedata;
    //             2'b10: cache[index][15:8] = CPUwritedata;
    //             2'b11: cache[index][7:0] = CPUwritedata;
    //         endcase
    //         cache[index][35] = 1'b1; // Set dirty bit to 1
    //     end
    // end

    // // Handling data written from memory to cache
    // always @(posedge clk) begin
    //     if (writefrommem) begin
    //         #1;
    //         cache[index][36] = 1'b1; // Set valid bit to 1
    //         cache[index][35] = 1'b0; // Set dirty bit to 0
    //         cache[index][34:32] = tag; // Set tag
    //         cache[index][31:0] = mem_readdata; // Set data
    //         writefrommem = 1'b0;
    //     end
    // end

endmodule
