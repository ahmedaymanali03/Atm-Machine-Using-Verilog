module ATM (clk,reset,cardIn,moneyDeposited,ejectCard,correctPassword,Another_Operation,password,opCode,Current_Balance,Language,ATM_Usage_Finished, Balance_Shown, Deposited_Successfully, Withdrawed_Successfully,inputAmount);
    input wire clk,reset,cardIn,moneyDeposited,ejectCard,Another_Operation, Language;
    input wire [3:0]password;
    input wire [1:0]opCode;
    input  [6:0] inputAmount;
    output reg ATM_Usage_Finished, Balance_Shown, Deposited_Successfully, Withdrawed_Successfully,correctPassword; 
    output reg [31:0] Current_Balance;
    reg  [31:0] Existing_Balance = 32'h00FF4240;
   
    reg [3:0]  Correct_Pass = 4'b1010;
    localparam  [3:0] Idle = 4'b0000, //Done
                      enter_Pin = 4'b0001,//DONE
                      choose_Transaction = 4'b0010,//DONE
                      deposit = 4'b0011, //salma :)
                      withdraw= 4'b0100, //salma  :)
                      //check_Balance= 4'b0101, //ayman DONE
                      update_balance= 4'b0110, //ayman DONE
                      display_Balance= 4'b0111, //kassab DONE
                      eject_Card= 4'b1000,//kassab DONE
                      choose_Language= 4'b1001;

    reg   [3:0]     current_state,
                     next_state;
                     
// state transition
     always @(posedge clk or posedge reset)
 begin
   Current_Balance<=Existing_Balance;
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
					next_state = choose_Language ;
				else if (cardIn == 1'b0)
					next_state = Idle ;	
                else
				    next_state = Idle ;
			end
choose_Language: begin
				 if (Language)
									next_state = enter_Pin;
								else
									next_state = choose_Language ;	
			end

enter_Pin: begin
 
									if(password !=Correct_Pass)
                                    next_state = enter_Pin;
                  
  
                                    else if (password==Correct_Pass)
                                    next_state = choose_Transaction;
                                    else 
                                    next_state= enter_Pin;	

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
    else 
    next_state= choose_Transaction;
    end
deposit     						: begin
								if(moneyDeposited)
									next_state = update_balance ;
								else 
									next_state = deposit ;	
											  
								end
withdraw     						: begin
								if(inputAmount< Existing_Balance)
									next_state = update_balance;
								else 
									next_state = choose_Transaction ;	
											  
								end            

//heck_Balance: begin
        //        if(inputAmount > Existing_Balance)
      //            next_state = withdraw;
    //            else
  //                next_state = update_balance;	
//               end            
update_balance: begin
             if (moneyDeposited)begin
                    Existing_Balance = (Existing_Balance + inputAmount);
                     Current_Balance=Existing_Balance;
                  next_state = display_Balance;
             end
                  else if (Withdrawed_Successfully)begin
                    Existing_Balance = (Existing_Balance - inputAmount);
                     Current_Balance=Existing_Balance;
                  next_state = display_Balance;
                  end
                  //   else begin
                  //   Existing_Balance<=Existing_Balance;
                  //    Current_Balance<=Existing_Balance;
                  // next_state = display_Balance;end
                 
                 
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
default :          next_state = Idle;         
endcase
end
// next_state logic
always @(*)
 begin
  case(current_state)
  Idle :begin
                  ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b0;
  end
   choose_Language :begin
                                    ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b0;
  end
  enter_Pin :begin
                  ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b0;
  end
  choose_Transaction :begin
                  ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b1;
  end
  deposit :begin
                  ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b1;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b1;
  end
  withdraw :begin
                  ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b1;
                  correctPassword=1'b1;
  end
  //check_Balance :begin
    //              ATM_Usage_Finished        = 1'b0;   
			//						Balance_Shown             = 1'b0;
				//					Deposited_Successfully    = 1'b0;
					//				Withdrawed_Successfully   = 1'b0;
            //      correctPassword=1'b1;
 // end
  update_balance :begin
                  ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b1;
  end
  display_Balance :begin
                  ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b1;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b1;
  end
  eject_Card :begin
                  ATM_Usage_Finished        = 1'b1;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b1;
  end
  default :begin
                  ATM_Usage_Finished        = 1'b0;   
									Balance_Shown             = 1'b0;
									Deposited_Successfully    = 1'b0;
									Withdrawed_Successfully   = 1'b0;
                  correctPassword=1'b0;
  end
  
  endcase
 end
endmodule