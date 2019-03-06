`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDSU
// Engineer: Colton Beery
// 
// Create Date: 03/6/2019 1:05 PM
// Revision Date: 03/6/2019 1:43 PM
// Module Name: UART_RX
// Project Name: UART
// Target Devices: Basys3
//
// Description: Rx: The tough one, receiving a byte in the format above and 
//              displaying it using the LEDs. Your Rx will have to detect the 
//              start bit, with 1/2 bit period to confirm a valid start bit, then
//              sample in the middle of each bit interval shifting each bit into 
//              an 8 bit register that drives the 8 LEDs on the I//O board.
// 
// Dependencies: 
//      Basys3_Master_Customized.xdc
//      UART_TX.v
// 
// Revision 0.03
// Changelog in Changelog.txt and Github
//
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////


module UART_RX(
    input [7:0] IO_SWITCH, //IO Dipswitches; up = 1
    input IO_BTN_C,         //IO Pushbutton (Center); pushed = 1
    input clk,              //Master clock signal
    inout [0:0] JA,     //PMOD JA; port JA1 used as TX pin
    output wire [7:0] IO_LED     //IO LED's for debugging data
    );
    
    /* instantiate tx module to read from it */
    UART_TX TX(.IO_SWITCH(IO_SWITCH), .IO_BTN_C(IO_BTN_C), .clk(clk), .JA(JA), .IO_LED(IO_LED));
    
    /* state machine logic */
    reg [1:0] state;
    parameter idle = 2'b00;             //when idle
    parameter isStart = 2'b01;          //when questioning if we're starting
    parameter read = 2'b10;             //when reading data
    
    /* Data and transmission parameters */
    reg [7:0] data = 0;                 //data output    
    reg [3:0] bit = 0;                  //bit number currently being transmitted 
    parameter max_counter = 10415;      // this should give 9600 baud
    reg [13:0] counter = 0;             //counter for baud rate generation; currently hardcoded to 14 bits for 9600 baud
    
    assign IO_LED = data; //LEDs used to display read data
    
    always @(posedge clk) begin
        case (state)
            idle: begin
                // High when idle, wait to read a zero
                if(~ JA) begin
                    counter <= 0;
                    state <= isStart;
                end
                data <= 0;
            end
            
            isStart: begin
                //Read a zero, but it might just be a glitch. 
                // Wait for 1/2 of 1/9600 of a second and see if it's still a zero
                if (counter < (max_counter/2)) begin
                    if (~JA) begin
                        //if it's still a 0, we have a start bit
                        counter <= 0;
                        state <= read;
                    end else begin
                        //if it's not still a 0, it was just a glitch, go back to idle
                        counter <= 0;
                        state <= idle;
                    end
                    counter <= counter + 1;
                end
            end
            
            read: begin
                if (bit <= 7) begin // If there's still more bits to transmit
                            if (counter < max_counter) begin //wait for counter to reach 10415, then read
                                counter <= counter + 1; 
                            end else begin //reset counter when it reaches 10415, and go to next bit
                                data[7-bit] <= JA[0];
                                counter <= 0;
                                bit <= bit + 1; 
                            end
                end else begin //when you run out of bits to receive, reset counter and bit, then return to idl
                    counter <= 0;
                    bit <= 0;  
                    state <= idle;
                end                   
            end
            
            default: begin
                // if in default state, something is wrong
                // return to idle
                state <= idle;
            end
        endcase
    end
    
endmodule
