module ATM_TB();
reg  Clock_tb,Reset_tb,cardIn_tb,moneyDeposited_tb,ejectCard_tb,Another_Operation_tb, Language_tb;
reg [3:0]password_tb;
reg [1:0] opCode_tb;
integer inputAmount_tb;

wire ATM_Usage_Finished_tb, Balance_Shown_tb, Deposited_Successfully_tb, Withdrawed_Successfully_tb,correctPassword_tb;
integer seed , j, i;
initial 
	begin
	Clock_tb = 0;
	forever
		#5 Clock_tb = ~Clock_tb;
	end

initial
begin
    // Open VCD file for dumping
    $dumpfile("ATM.vcd");
    // Dump the current values of all signals
    $dumpvars;
        Clock_tb 					= 1'b1;
		Reset_tb					= 1'b0;
		Language_tb					= 1'b0;
		moneyDeposited_tb			= 1'b0;
		// Service_Chosen_tb           = 1'b0;
		cardIn_tb                   = 1'b0;
		Another_Operation_tb		= 1'b0;
		opCode_tb					= 2'b00;
		password_tb 				= 4'b0000;
		inputAmount_tb              = 32'h00000000;



//         //Directed Testing	
// 		#10
// 		Reset_tb = 1'b1;
// 		#10
// 		Reset_tb = 1'b0;
// 		#10



//     //Withdraw test//
// 			Reset_tb 					= 1'b1;
// 			#10
// 			cardIn_tb                   =1'b1;
//             #10
//             Language_tb 				= 1'b1;
// 			#10
// 			password_tb 				= 4'b1010;
// 			#10
// 			opCode_tb 					= 2'b11;
// 			#10
// 			inputAmount_tb     			= 32'h00000040;
// 			#10
// 			Another_Operation_tb 		= 1'b0;
// 			#10
// 			//end of withdraw test


//         Clock_tb 					= 1'b1;
// 		Reset_tb					= 1'b0;
// 		Language_tb					= 1'b0;
// 		moneyDeposited_tb			= 1'b0;
// 		// Service_Chosen_tb           = 1'b0;
// 		cardIn_tb                   = 1'b0;
// 		Another_Operation_tb		= 1'b0;
// 		opCode_tb					= 2'b00;
// 		password_tb 				= 4'b0000;
// 		inputAmount_tb			= 32'h00000000;
// 		#10           


// //View Balance
// 			Reset_tb 					= 1'b1;
// 			#10
//             cardIn_tb                   =1'b1;
//             #10
// 			Language_tb 				= 1'b1;
// 			#10
// 			password_tb 				= 4'b1010;
// 			#10
// 			opCode_tb 					= 2'b01;
// 			#10
// 			inputAmount_tb      			= 32'h00000040;
// 			#10
// 			Another_Operation_tb 		= 1'b0;
// 			#10

// 			//end of view balance test



//         Clock_tb 					= 1'b1;
// 		Reset_tb					= 1'b0;
// 		Language_tb					= 1'b0;
// 		moneyDeposited_tb			= 1'b0;
// 		// Service_Chosen_tb           = 1'b0;
// 		cardIn_tb                   = 1'b0;
// 		Another_Operation_tb		= 1'b0;
// 		opCode_tb					= 2'b00;
// 		password_tb 				= 4'b0000;
// 		inputAmount_tb			= 32'h00000000;
// 		#10


// //Deposit
// 			Reset_tb 					= 1'b1;
// 			#10
//             cardIn_tb                   =1'b1;
//             #10
// 			Language_tb 				= 1'b1;
// 			#10
// 			password_tb 				= 4'b1010;
// 			#10
// 			opCode_tb 					= 2'b10;
// 			#10
// 			inputAmount_tb      			= 32'h00000040;
// 			#10
// 			Another_Operation_tb 		= 1'b0;
// 			#10
// 			// end of deposit test 


// #100

// Clock_tb 					= 1'b1;
// 		Reset_tb					= 1'b0;
// 		Language_tb					= 1'b0;
// 		moneyDeposited_tb			= 1'b0;
// 		// Service_Chosen_tb           = 1'b0;
// 		cardIn_tb                   = 1'b0;
// 		Another_Operation_tb		= 1'b0;
// 		opCode_tb					= 2'b00;
// 		password_tb 				= 4'b0000;
// 		inputAmount_tb			= 32'h00000000;
// 		#20   



//Randomized Testing
			for(j=0 ; j<70 ; j=j+1)
			begin
			
				// seed =j;
				// $display("seed is %d" , seed);

					for(i=0 ; i<100 ; i=i+1)
					begin
					
						#10
						Reset_tb				  =$random();             
						Language_tb               =$random();
						Money_Deposited_tb         =$random();
						// Service_Chosen_tb         =$random(seed);
						cardIn_tb                 =$random();
						Another_Operation_tb      =$random();
						opCode_tb                 =$random();
						inputAmount_tb            =$random();
		end
					
					
		$finish;


end
 ATM DUT(
.clk(Clock_tb), 
.reset(Reset_tb),  
.Language(Language_tb), 
.moneyDeposited(Money_Deposited_tb),  
// .Service_Chosen(Service_Chosen_tb),
.cardIn(cardIn_tb),  
.ejectCard(ejectCard_tb),
.Another_Operation(Another_Operation_tb),
.opCode(opCode_tb),
.ATM_Usage_Finished(ATM_Usage_Finished_tb),
.Balance_Shown(Balance_Shown_tb), 
.Deposited_Successfully(Deposited_Successfully_tb), 
.Withdrawed_Successfully(Withdrawed_Successfully_tb), 
.password(password_tb),
.correctPassword(correctPassword_tb)
);
endmodule

