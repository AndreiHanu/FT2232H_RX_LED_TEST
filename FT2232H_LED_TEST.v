//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:47:29 05/06/2017 
// Design Name: 
// Module Name:    FT2232_LED_TEST 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module FT2232_LED_TEST(
		// 125 MHz Differential Clock
		input wire SYSCLK_P, SYSCLK_N,
		
		// Test LEDs
		output wire [3:0] led,
		
		// FT2232H Signals
		input wire [7:0] usb_d,
		output wire usb_rdn,
		//output wire usb_wrn,
		input wire usb_rxfn
		//input wire usb_txen		
	);
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// 125 MHz Single Ended Clock
	/////////////////////////////////////////////////////////////////////////////////////////
	IBUFGDS my_clk_inst (.O  (clk),
								.I  (SYSCLK_P),
								.IB (SYSCLK_N));
	
	/////////////////////////////////////////////////////////////////////////////////////////
	// FT2232H RX Controller
	/////////////////////////////////////////////////////////////////////////////////////////
	FT2232H_RX_Controller FT2232H_RX_Controller (
		.clk(clk), 
		.reset(reset), 
		.usb_d(usb_d),
		.usb_rxfn(usb_rxfn),
		.usb_rdn(usb_rdn),
		.led1(led[0]),
		.led2(led[1]),
		.led3(led[2]),
		.led4(led[3])
	);

endmodule
