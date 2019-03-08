# COMPE470L UART Lab

<details>
	<summary>The Instructions </summary>
	
This assignment is to create two state machine designs in Verilog and demonstrate them on the FPGA board:

1. Tx: The simpler of the two. When an 8 bit value is loaded into a register using the 8 DIP switches for the number and a push button for the "load" signal, it shifts the byte out in asynchronous serial format (initially at 9600 bits per second, later at an arbitrary, programmable data rate).  That begins with a start bit (0), followed by the 8 data bits LSB first, and a stop (1) bit.

2. Rx: The tough one, receiving a byte in the format above and displaying it using the LEDs. Your Rx will have to detect the start bit, with 1/2 bit period to confirm a valid start bit, then sample in the middle of each bit interval shifting each bit into an 8 bit register that drives the 8 LEDs on the IO board.
	
	
For this specific assignment, in part 1 you must implement a UART that takes paralllel input data from the switches and buttons, and produces a serial output on one of the FPGA output pins.  In order to do that, you must also create a clock with an appropriate frequency to operate the UART from the on-board oscillator connected to the FPGA.  The clock frequency should be higher than the data rate to allow for the requirements for part 2 below, most UARTs use a clock that is 16x the data rate. Capture the serial output data on the scope or logic analyzer abd confirm the serial output data is correct and that the bit period is 1/9600th second long.
	
In part 2, you will design a serial to parallel receiver that will receive the asynchronous data from your transmitter in part 1 above, and convert it into an 8 bit parallel word for display on the LEDs on the I/O board.
	
Ultimately, you will be implementing the core subset of transmit/receive functions of a device similar to the SCC2691 serial UART chip in the file listed below, so you should review the transmit buffer empty and receive buffer full status registers of that device.  For full credit, your final UART design should implement the receive buffer full and transmit buffer empty bits. You will need to take the raw FPGA input clock (8MHz for the older version of the board, 50MHz for the newer rev A board that has DIYchips.com written in white letters on the top of the board) and convert that clock into an appropriate clock for your two state machines.
</details>
