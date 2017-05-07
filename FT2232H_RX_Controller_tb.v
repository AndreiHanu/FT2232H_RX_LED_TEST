`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:16:39 05/06/2017
// Design Name:   FT2232H_RX_Controller
// Module Name:   C:/Users/Andrei/Desktop/CNPTEPC/Firmware/FT2232H_RX_LED_TEST/FT2232H_RX_Controller_tb.v
// Project Name:  FT2232H_RX_LED_TEST
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FT2232H_RX_Controller
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module FT2232H_RX_Controller_tb;

	// Inputs
	reg clk;
	reg reset;
	reg usb_rxfn;	
	reg [7:0] usb_d;

	// Outputs
	wire usb_rdn;
	wire led1;
	wire led2;
	wire led3;
	wire led4;	

	// Instantiate the Unit Under Test (UUT)
	FT2232H_RX_Controller uut (
		.clk(clk), 
		.reset(reset), 
		.usb_d(usb_d), 
		.usb_rxfn(usb_rxfn), 
		.usb_rdn(usb_rdn), 
		.led1(led1), 
		.led2(led2), 
		.led3(led3), 
		.led4(led4)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 0;
		usb_rxfn = 1;
		usb_d = 0;

		// Wait 100 ns for global reset to finish
		#100 reset = 1;
		#2 reset = 0;
        
		// Add stimulus here
		// Turn on LED 1
		#100 usb_rxfn = 0;
		#16 usb_d = 8'h31;
		#32 usb_rxfn = 1;
		
		// Turn off LED 1
		#50 usb_rxfn = 0;
		#16 usb_d = 8'h31;
		#32 usb_rxfn = 1;
	end
	
	always #4 clk =~clk;
      
endmodule

