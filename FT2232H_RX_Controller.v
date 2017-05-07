//////////////////////////////////////////////////////////////////////////////////
// 
// FT2232H Write (RX) Controller
//
// This controller receives commands or operational (OP) codes from the host PC
// using the asynchronous FT245 FIFO mode and controls various circuits on the DAQ.
//
// Designed by: Andrei Hanu 
//
// Create Date:  05/06/2017 
// Last Edited:	 05/06/2017
//
//////////////////////////////////////////////////////////////////////////////////

module FT2232H_RX_Controller(
		// Synchronous clock & asynchronous reset
		input wire clk, reset,
				
		// To & From FT2232H chip
		input wire [7:0] usb_d,					// Bi-directional data bus 
		input wire usb_rxfn,						// FIFO data available flag (Active LOW)
		output wire usb_rdn,						// Read Enable Pin (Active Low)

		// To main FPGA
		output wire led1,
		output wire led2,
		output wire led3,
		output wire led4		
	);
	

	// Symbolic State Declaration
	localparam [3:0]
		idle 		= 	4'd0,		
		read1 	= 	4'd1,
		read2 	= 	4'd2,
		read3 	= 	4'd3,
		read4 	= 	4'd4;
		
	// Internal Signal Declaration
	reg [3:0] reg_state, next_state;				// State register
	reg reg_usb_rdn, next_usb_rdn;					// Read Enable 
	reg reg_led1, next_led1;						// LED 1 state
	reg reg_led2, next_led2;						// LED 2 state
	reg reg_led3, next_led3;						// LED 3 state
	reg reg_led4, next_led4;						// LED 4 state
	
	// FSMD state & data registers
	always @(posedge clk, posedge reset) 
	begin
		if (reset) 
			begin
				reg_state <= idle;
				reg_usb_rdn <= 1'b1;
				reg_led1 <= 1'b0;
				reg_led2 <= 1'b0;
				reg_led3 <= 1'b0;
				reg_led4 <= 1'b0;
			end
		else 
			begin
				reg_state <= next_state;
				reg_usb_rdn <= next_usb_rdn;
				reg_led1 <= next_led1;
				reg_led2 <= next_led2;
				reg_led3 <= next_led3;
				reg_led4 <= next_led4;
			end
	end	
	
	// FSMD next-state logic
	always @*
	begin
		// Default conditions (keep same value)
		next_led1 = reg_led1;
		next_led2 = reg_led2;
		next_led3 = reg_led3;
		next_led4 = reg_led4;		
		
		case (reg_state)
			idle:
				begin					
					if (usb_rxfn) 
						begin 
							// Loop the same state
							next_state = idle;
						end
					else 
						begin					
							// Begin read operation
							next_state = read1;		
						end						
				end
			read1:
				begin
					next_state = read2;															
				end
			read2:
				begin
					next_state = read3;					
				end
			read3:
				begin
					next_state = read4;
					
					// Check the data for LED number
					case (usb_d)
						8'b00110001:
							begin
								// Toggle LED 1
								next_led1 = ~reg_led1;
							end
						8'b00110010:
							begin
								// Toggle LED 2
								next_led2 = ~reg_led2;
							end
						8'b00110011:
							begin
								// Toggle LED 3
								next_led3 = ~reg_led3;
							end
						8'b00110100:
							begin
								// Toggle LED 4
								next_led4 = ~reg_led4;
							end
					endcase					
				end
			read4:
				begin
					next_state = idle;					
				end
			default:
				next_state = idle;				
		endcase
	end
	
	// look-ahead output logic
	always @*
	begin
		// Default Conditions (Buffered Outputs)
		next_usb_rdn = 1'b1;					// (Active LOW)
		
		case (next_state)
		idle:
			begin
				next_usb_rdn = 1'b1;
			end
		read1:
			begin
				next_usb_rdn = 1'b0;
			end
		read2:
			begin
				next_usb_rdn = 1'b0;
			end
		read3:
			begin
				next_usb_rdn = 1'b0;
			end
		read4:
			begin
				next_usb_rdn = 1'b1;
			end
		endcase
	end
		
	// To main FPGA
	assign usb_rdn = reg_usb_rdn;
	assign led1 = reg_led1;
	assign led2 = reg_led2;
	assign led3 = reg_led3;
	assign led4 = reg_led4;
	
endmodule