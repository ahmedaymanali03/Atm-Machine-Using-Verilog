module ATM (clk,reset,cardIn,moneyDeposited,ejectCard,correctPassword,Another_Operation,password,opCode,ATMUsageFinished);
    input wire clk,reset,cardIn,moneyDeposited,ejectCard,correctPassword,Another_Operation;
    input wire [3:0]password;
    input wire [1:0]opCode;
    integer inputAmount;
    output ATMUsageFinished; 
    reg [31:0] Existing_Balance = 32'h000F4240;
    reg [3:0]  Correct_Pass = 4'b1010;
    localparam  [3:0] Idle = 4'b0000, //Done
                      enter_Pin = 4'b0001,//DONE
                      choose_Transaction = 4'b0010,//DONE
                      deposit = 4'b0011, //salma :)
                      withdraw= 4'b0100, //salma  :)
                      check_Balance= 4'b0101, //ayman DONE
                      update_balance= 4'b0110, //ayman DONE
                      display_Balance= 4'b0111, //kassab DONE
                      eject_Card= 4'b1000;//kassab DONE

    reg   [3:0]     current_state,
                     next_state;
                     
// state transition
     always @(posedge clk or posedge reset)
 begin
  if(reset)
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

enter_Pin: begin
									if(correctPassword ==0)
                                    next_state = enter_Pin;
                                    else if (correctPassword==1)
                                    next_state = choose_Transaction;							
end
choose_Transaction: begin
    if(opCode==2'b00)
    next_state= choose_Transaction;
    else if (opCode ==2'b01)
    next_state= display_Balance;
    else if (opCode == 2'b10)
    next_state = deposit;
    else if (opCode == 2'b11)
    next_state = withdraw;
    end
deposit     						: begin
								if(moneyDeposited)
									next_state = update_balance ;
								else 
									next_state = deposit ;	
											  
								end
withdraw     						: begin
								if(inputAmount)
									next_state = check_Balance ;
								else 
									next_state = withdraw ;	
											  
								end            

check_Balance: begin
                if(inputAmount > Existing_Balance)
                  next_state = withdraw;
                else
                  next_state = update_balance;	
               end
               
update_balance: begin
                  next_state = display_Balance;
                  if (moneyDeposited)
                    Existing_Balance = Existing_Balance + inputAmount;
                  else if (inputAmount)
                    Existing_Balance = Existing_Balance - inputAmount;
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