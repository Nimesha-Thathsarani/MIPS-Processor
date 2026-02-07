// `include "mux2x1.v"
`include "MuxUnit4.v"

module ForwardUnit(data2 , result);
    input [7:0] data2;
    output [7:0] result; // Changed to wire as this output directly assigns input to output
    assign #1 result = data2; // Using assign for direct assignment
endmodule

module AddUnit(data1, data2, result);
    input [7:0] data1, data2;
    output [7:0] result; // Changed to wire, output directly driven by procedural block
    assign #2 result = data1 + data2; // Using assign for direct addition
endmodule

module AndUnit(data1, data2, result);
    input [7:0] data1, data2;
    output [7:0] result; // Changed to wire
    assign #1 result = data1 & data2; // Using assign for bitwise AND
endmodule

module OrUnit(data1, data2, result);
    input [7:0] data1, data2;
    output [7:0] result; // Changed to wire
    assign #1 result = data1 | data2; // Using assign for bitwise OR
endmodule

module shiftUnit(data1, data2, result,islogicalorisleft);
    input [1:0] islogicalorisleft;
    input [7:0] data1, data2;
    output [7:0] result; // Changed to wire
    reg [3:0] control;
    reg [7:0] logicalexception, shift1LogicalLeft, shift2LogicalLeft, shift4LogicalLeft;
    reg [7:0] shift1LogicalRight, shift2LogicalRight, shift4LogicalRight;
    reg [7:0] arithmeticexception, shift1ArithmeticLeft, shift2ArithmeticLeft, shift4ArithmeticLeft;
    reg [7:0] shift1ArithmeticRight, shift2ArithmeticRight, shift4ArithmeticRight;
    wire [7:0] shift1, shift2, shift4,exception, result1,result2,result4;

     // Using assign for left shift 7 6 5 4 3 2 1 0
    
    always @(data2) begin
        if (data2[3:0] < 4'b1000) begin // 0111 
            control = #1 data2[3:0];
        end else begin
            control = #1 4'b1000;
        end
    end

    // shifting 0 ,1

    always @(data1)
        begin
        //logical
        logicalexception = 8'b00000000;
        shift1LogicalLeft[7:0] = {data1[6:0],1'b0};
        shift1LogicalRight[7:0] = {1'b0,data1[7:1]};

        //arithmetic
        arithmeticexception = {data1[7],7'b0000000};
        shift1ArithmeticLeft[7:0] = {data1[7],data1[5:0],1'b0};
        shift1ArithmeticRight[7:0] = {data1[7],1'b0,data1[6:1]};
    end
   
     //shift1 mux
    MuxUnit4 mux1(shift1ArithmeticRight, shift1ArithmeticLeft, shift1LogicalRight, shift1LogicalLeft, islogicalorisleft, shift1);
    //result mux 1
    mux2x1 resultmux1(data1, shift1, control[0], result1);

    //next shifting 2 , 3
    always @(result1)
        begin
        //logical
        shift2LogicalLeft[7:0] = {result1[5:0],2'b00};
        shift2LogicalRight[7:0] = {2'b00,result1[7:2]};

        //arithmetic
        shift2ArithmeticLeft[7:0] = {result1[7],result1[4:0],2'b00};
        shift2ArithmeticRight[7:0] = {result1[7],2'b00,result1[6:2]};
    end

    //shift2 mux
    MuxUnit4 mux2(shift2ArithmeticRight, shift2ArithmeticLeft, shift2LogicalRight, shift2LogicalLeft, islogicalorisleft, shift2);
    //result mux 2
    mux2x1 resultmux2(result1, shift2, control[1], result2);

    //next shifting 4 , 5
    always @(result2)
        begin
        //logical
        shift4LogicalLeft[7:0] = {result2[3:0],4'b0000};
        shift4LogicalRight[7:0] = {4'b0000,result2[7:4]};

        //arithmetic
        shift4ArithmeticLeft[7:0] = {result2[7],result2[2:0],4'b0000};
        shift4ArithmeticRight[7:0] = {result2[7],4'b0000,result2[6:4]};
    end

     //shift4 mux
    MuxUnit4 mux4(shift4ArithmeticRight, shift4ArithmeticLeft, shift4LogicalRight, shift4LogicalLeft, islogicalorisleft, shift4);
     //result mux 4
    mux2x1 resultmux4(result2, shift4, control[2], result4);


    //next shifting 6 , 7
    //exception mux
    MuxUnit4 mux5(arithmeticexception, arithmeticexception, logicalexception, logicalexception, islogicalorisleft, exception);   
    //exception mux
    mux2x1 exceptionmux5(result4, exception, control[3], result);

endmodule

module rotation(data1, data2, result, isleft);
    input [7:0] data1, data2;
    input isleft;
    output [7:0] result;

    reg [2:0] control;
    reg [7:0] rotationLeft1, rotationLeft2, rotationLeft4;
    reg [7:0] rotationRight1, rotationRight2, rotationRight4;
    wire [7:0] rotation1, rotation2, rotation4;
    wire [7:0] result1, result2;

    always @(data2) begin
        control = #1 data2[2:0];
    end

    //rotating 1
    always@(data1) begin
        rotationLeft1[7:0] = {data1[6:0],data1[7]};
        rotationRight1[7:0] = {data1[0],data1[7:1]};
    end

    //rotation 1 mux
    mux2x1 mux1(rotationRight1, rotationLeft1, isleft, rotation1);
    //result mux 1
    mux2x1 resultmux1(data1, rotation1, control[0], result1);


    //rotating 2
    always@(result1) begin
        rotationLeft2[7:0] = {result1[5:0],result1[7:6]};
        rotationRight2[7:0] = {result1[1:0],result1[7:2]};
    end

    //rotation 2 mux
    mux2x1 mux2(rotationRight2, rotationLeft2, isleft, rotation2);
    //result mux 2
    mux2x1 resultmux2(result1, rotation2, control[1], result2);


    //rotating 4
    always@(result2) begin
        rotationLeft4[7:0] = {result2[3:0],result2[7:4]};
        rotationRight4[7:0] = {result2[3:0],result2[7:4]};
    end

    //rotation 4 mux
    mux2x1 mux4(rotationRight4, rotationLeft4, isleft, rotation4);  
    //result mux 4
    mux2x1 resultmux4(result2, rotation4, control[2], result);

endmodule

module multiplication(data1, data2, result);
    input [7:0] data1, data2;
    output [7:0] result;
    reg [7:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
    
    always @(data1 or data2) begin
        temp0 = { data1[0], data1[0] ,data1[0] ,data1[0] ,data1[0] ,data1[0] ,data1[0] ,data1[0] } & data2;
        temp1 = { data1[1], data1[1] ,data1[1] ,data1[1] ,data1[1] ,data1[1] ,data1[1] ,data1[1] } & data2;
        temp2 = { data1[2], data1[2] ,data1[2] ,data1[2] ,data1[2] ,data1[2] ,data1[2] ,data1[2] } & data2;
        temp3 = { data1[3], data1[3] ,data1[3] ,data1[3] ,data1[3] ,data1[3] ,data1[3] ,data1[3] } & data2;
        temp4 = { data1[4], data1[4] ,data1[4] ,data1[4] ,data1[4] ,data1[4] ,data1[4] ,data1[4] } & data2;
        temp5 = { data1[5], data1[5] ,data1[5] ,data1[5] ,data1[5] ,data1[5] ,data1[5] ,data1[5] } & data2;
        temp6 = { data1[6], data1[6] ,data1[6] ,data1[6] ,data1[6] ,data1[6] ,data1[6] ,data1[6] } & data2;
        temp7 = { data1[7], data1[7] ,data1[7] ,data1[7] ,data1[7] ,data1[7] ,data1[7] ,data1[7] } & data2;

        temp1 = {temp1[6:0],1'b0};
        temp2 = {temp2[5:0],2'b00};
        temp3 = {temp3[4:0],3'b000};
        temp4 = {temp4[3:0],4'b0000};
        temp5 = {temp5[2:0],5'b00000};
        temp6 = {temp6[1:0],6'b000000};
        temp7 = {temp7[0],7'b0000000};
    end

    assign #3 result = temp0 + temp1 + temp2 + temp3 + temp4 + temp5 + temp6 + temp7;

endmodule

module MuxUnit(I1, I2, I3, I4, I5, I6, I7, select, result);
    input [7:0] I1, I2, I3, I4, I5, I6 , I7;
    input [2:0] select;
    output reg [7:0] result;
    
    always @(*) begin // Changed sensitivity list to *
       case(select)
            3'b000: result <= I1;
            3'b001: result <= I2;
            3'b010: result <= I3;
            3'b011: result <= I4;
            3'b100: result <= I5;
            3'b101: result <= I6;
            3'b110: result <= I7;
           // It's good practice to have a default case
           default: result = 8'bx; // Undefined in case of an unexpected select
       endcase
    end
endmodule

module ALUUnit(data1, data2, select, result,zero,islogicalorisleft);
    input [7:0] data1, data2;
    input [1:0] islogicalorisleft; 
    input [2:0] select;
    output wire [7:0] result; // Changed to wire because it is directly driven by MuxUnit
    output reg zero; // Changed to wire because it is directly driven by if-else block
    wire [7:0] Ii1, Ii2, Ii3, Ii4, Ii5, Ii6, Ii7; // Already correctly defined as wire


    always @(*) begin
        if ((result == 8'b00000000)) begin
            zero = 1'b1;
        end
        else begin
            zero = 1'b0;
        end
    end


    ForwardUnit forward(data2, Ii1);
    AddUnit add(data1, data2, Ii2);
    AndUnit and1(data1, data2, Ii3);
    OrUnit or1(data1, data2, Ii4);
    shiftUnit shift(data1, data2, Ii5, islogicalorisleft);
    rotation rotate(data1, data2, Ii6, islogicalorisleft[0]);
    multiplication multiply(data1, data2, Ii7);
    MuxUnit mux(Ii1, Ii2, Ii3, Ii4, Ii5, Ii6, Ii7, select, result);

    
endmodule
 

