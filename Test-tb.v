module ATM_Tbbbb();
reg  Clock_tb,Reset_tb,cardIn_tb,moneyDeposited_tb,ejectCard_tb,Another_Operation_tb, Language_tb;
reg [3:0]password_tb;
reg [1:0] opCode_tb;
reg [6:0] inputAmount_tb;
wire ATM_Usage_Finished_tb, Balance_Shown_tb, Deposited_Successfully_tb, Withdrawed_Successfully_tb,correctPassword_tb;
wire [31:0] Current_Balance_tb;
integer i;
ATM uUT(
.clk(Clock_tb), 
.reset(Reset_tb),  
.Language(Language_tb), 
.moneyDeposited(moneyDeposited_tb),  
// .Service_Chosen(Service_Chosen_tb),
.cardIn(cardIn_tb),  
.ejectCard(ejectCard_tb),
.Another_Operation(Another_Operation_tb),
.opCode(opCode_tb),
.inputAmount(inputAmount_tb),
.ATM_Usage_Finished(ATM_Usage_Finished_tb),
.Balance_Shown(Balance_Shown_tb), 
.Deposited_Successfully(Deposited_Successfully_tb), 
.Withdrawed_Successfully(Withdrawed_Successfully_tb), 
.password(password_tb),
.correctPassword(correctPassword_tb),.Current_Balance(Current_Balance_tb)
);

initial
begin
	Clock_tb = 0;
	forever
		#1 Clock_tb = ~Clock_tb;
	end
initial begin
    Reset_tb<=0;
    password_tb<=4'b1010;
    cardIn_tb<=1;
    ejectCard_tb<=0;
@(posedge Clock_tb);
for(i=0;i<9999999;i=i+1) begin
#10
    //Reset_tb=$random();
    Language_tb=$random();
    moneyDeposited_tb=$random();
    opCode_tb=$random();
    Another_Operation_tb=$random();
    inputAmount_tb=$random();
end
end





endmodule