module ATM_Tbbbb();
reg  Clock_tb,Reset_tb,cardIn_tb,ejectCard_tb, Language_tb,Timer_tb;
reg [3:0]password_tb;
reg [1:0] opCode_tb;
reg [19:0] inputAmount_tb;
wire ATM_Usage_Finished_tb, Balance_Shown_tb,Balance_Updated_tb, Deposited_Successfully_tb, Withdrawed_Successfully_tb,correctPassword_tb,Input_Approved_tb;
wire [31:0] Current_Balance_tb;
integer i;
ATM uUT(
.clk(Clock_tb), 
.reset(Reset_tb),  
.Language(Language_tb), 
  
.cardIn(cardIn_tb),  
.ejectCard(ejectCard_tb),
.Balance_Updated(Balance_Updated_tb),
.opCode(opCode_tb),
.inputAmount(inputAmount_tb),
.ATM_Usage_Finished(ATM_Usage_Finished_tb),
.Balance_Shown(Balance_Shown_tb), 
.Deposited_Successfully(Deposited_Successfully_tb), 
.Withdrawed_Successfully(Withdrawed_Successfully_tb), 
.password(password_tb),.timer(Timer_tb),
.correctPassword(correctPassword_tb),.Current_Balance(Current_Balance_tb)
,.Input_Approved(Input_Approved_tb)
);

initial
begin
	Clock_tb = 0;
	forever
		#1 Clock_tb = ~Clock_tb;
	end



 initial begin


// Directed testing

//Deposit test
 Reset_tb=1'b0;
 Timer_tb=1'b0;
 #1
 cardIn_tb=1'b1;
 #1
 Language_tb=1'b1;
 #1
 password_tb=4'b1010;
 #1
 opCode_tb=2'b10;
 #5
 inputAmount_tb=20'h00488;
 #5
 ejectCard_tb=1'b1;
@(posedge Clock_tb)
 if(Current_Balance_tb==0)
 $display("error when depositing money");
 #6


//reset test
    Reset_tb = 1'b1;
    @(posedge Clock_tb)
    if((correctPassword_tb||Input_Approved_tb||Withdrawed_Successfully_tb||Deposited_Successfully_tb||Balance_Shown_tb||ATM_Usage_Finished_tb))
    $display("reset doesnt work ");
    #6
                


//Display balance

 Reset_tb=1'b0;
 Timer_tb=1'b0;
 cardIn_tb=1'b1;
 #1
 Language_tb=1'b1;
 #1
 password_tb=4'b1010;
 #1
 cardIn_tb=1'b1;
 #1
 Language_tb=1'b1;
 #1
 password_tb=4'b1010;
 #1
 opCode_tb=2'b01;
 #1
 ejectCard_tb=1'b1;
@(posedge Clock_tb)
 if(!Balance_Shown_tb)
 $display("error when showing balance");
#5


//withdraw test
Reset_tb=1'b0;
 Timer_tb=1'b0;
 #1
 cardIn_tb=1'b1;
 #1
 Language_tb=1'b1;
 #1
 password_tb=4'b1010;
 #1
 opCode_tb=2'b11;
 #5
 inputAmount_tb=20'h00100;
 #5
 ejectCard_tb=1'b1;
#5

 //timer test

 Reset_tb=1'b0;
 #1
 cardIn_tb=1'b1;
 #1
 Language_tb=1'b1;
 #1
 password_tb=4'b1010;
 #1
 opCode_tb=2'b10;
 #2
 Timer_tb=1'b1;
 #5
 ejectCard_tb=1'b1;

#10
    //randomized testing
    Reset_tb<=0;
    cardIn_tb<=1;
    ejectCard_tb<=0;
    Language_tb=1;
    Timer_tb=0;
for(i=0;i<999;i=i+1) begin
//#10
@(posedge Clock_tb);
   
   
    opCode_tb=$random();
    
    #12
    inputAmount_tb=$unsigned($random());
end

$stop;

end

initial begin
    $monitor("clk = %b , rst= %b,correct password = %b,usage finished= %b,balance shown= %b , deposit = %b , withdraw= %b, input approved = %b ,current balance = %d  ",Clock_tb,Reset_tb,correctPassword_tb,ATM_Usage_Finished_tb, Balance_Shown_tb, Deposited_Successfully_tb, Withdrawed_Successfully_tb,Input_Approved_tb,Current_Balance_tb);
end
//psl reset_assertion: assert always ((Reset_tb==1)->((~(correctPassword_tb&&Input_Approved_tb&&Withdrawed_Successfully_tb&&Deposited_Successfully_tb&&Balance_Shown_tb&&ATM_Usage_Finished_tb))) ) @(posedge Clock_tb);
//psl timer_assertion: assert always ((Timer_tb==1)->(~(correctPassword_tb&&Input_Approved_tb&&Withdrawed_Successfully_tb&&Deposited_Successfully_tb&&Balance_Shown_tb&&ATM_Usage_Finished_tb))) @(posedge Clock_tb);
//psl deposit_assertion: assert always ((password_tb==4'b1010 && Reset_tb==0 && Timer_tb==0 && correctPassword_tb==1&& inputAmount_tb>0&& opCode_tb==2'b10&&Deposited_Successfully_tb==1)->next(Balance_Updated_tb)) @(posedge Clock_tb);
//psl withdraw_assertion: assert always ((password_tb==4'b1010 && Reset_tb==0 && Timer_tb==0 && correctPassword_tb==1&& inputAmount_tb>0&& opCode_tb==2'b11&&Withdrawed_Successfully_tb==1)->next(Balance_Updated_tb)) @(posedge  Clock_tb);







endmodule