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
    check_Balance= 4'b0101; //ayman DONE
    update_balance= 4'b0110; //ayman DONE
    display_Balance= 4'b0111; //kassab DONE
    eject_Card= 4'b1000;//kassab DONE
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
	  
Idle: begin
				if(cardIn == 1'b1)
					next_state = enter_Pin ;
				else if (cardIn == 1'b0)
					next_state = Idle ;	
			end

check_Balance: begin
                if(inputAmount > balance)
                  next_state = withdraw;
                else
                  next_state = update_balance;	
               end
               
update_balance: begin
                  next_state = display_Balance;
                  if (moneyDeposited)
                    balance = balance + inputAmount;
                  else if (inputAmount)
                    balance = balance - inputAmount;
                end
display_Balance:begin
                    if (ejectCard)
                    next_state = eject_Card;
                    else
                    next_state = choose_Transaction;
                end
eject_Card: begin
              next_state = Idle;
            end                



endcase
end
endmodule