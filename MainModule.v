module ATM ();
    input wire clk,reset,cardIn,moneyDeposited,ejectCard,correctPassword,Another_Operation;
    input wire [3:0]password;
    input wire [1:0]opCode;
    input integer wire inputAmount,balance;
    output ATMUsageFinished;
    wire 
    reg [31:0] Existing_Balance = 32'h000F4240;
    reg [3:0]  Correct_Pass = 4'b1010;
    localparam  [3:0] Idle = 4'b0000;
    enter_Pin = 4'b0001;
    choose_Transaction = 4'b0010;
    deposit = 4'b0011; //salma
    withdraw= 4'b0100; //salma
    check_Balance= 4'b0101; //ayman
    update_balance= 4'b0110; //ayman
    display_Balance= 4'b0111; //kassab
    eject_Card= 4'b1000;//kassab
    reg   [3:0]     current_state,
                     next_state;
// state transition
     always @(posedge clk or negedge reset)
 begin
  if(!reset)
   begin
     current_state <= Idle ;
   end
  else
   begin
     current_state <= next_state ;
   end
 end        
// next_state logic
always @(*)
 begin
  case(current_state)
	  
Idle     						: begin
								if(cardIn == 1'b1)
									next_state = enter_Pin ;
								else if (cardIn == 1'b0)
									next_state = Idle ;	
											  
								end
enter_Pin                      :be
  endcase
 end
endmodule