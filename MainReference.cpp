#include <iostream>
#include <cstdlib>
#include <ctime>
using namespace std;

class ATM {
public:
    // Inputs
    bool  reset = false, cardIn = false, ejectCard = false, Language = false, timer = false;
     int password=0;
     int opCode=0;
     int inputAmount=0;

    // Outputs
    bool ATM_Usage_Finished=false, Balance_Shown = false, Deposited_Successfully = false, Withdrawed_Successfully = false, correctPassword = false, Input_Approved = false, Balance_Updated = false;
     int Current_Balance=0;

    // states
     int Existing_Balance=0;
     int Correct_Pass=0;
     enum State {
         Idle,
         choose_Language,
         enter_Pin,
         choose_Transaction,
         deposit,
         check_Balance,
         withdraw,
         update_balance,
         display_Balance,
         eject_Card
     } current_state, next_state;

    ATM() {
        Existing_Balance = 100000; 
        Correct_Pass = 10;                         
        current_state = Idle;
        next_state = Idle;
    }

    void state_transition() {
        Current_Balance = Existing_Balance;
        if (reset) {
            current_state = Idle;
        }
        else if (timer) {
            current_state = choose_Language;
        }
        else {
            current_state = next_state;
        }
    }

    void next_state_logic() {
        switch (current_state) {
        case Idle:
            if (cardIn) {
                next_state = choose_Language;
            }
            else {
                next_state = Idle;
            }
            break;
        case choose_Language:
            if (Language) {
                next_state = enter_Pin;
            }
            else {
                next_state = choose_Language;
            }
            break;
        case enter_Pin:
            if (password != Correct_Pass) {
                next_state = enter_Pin;
            }
            else if (password == Correct_Pass) {
                next_state = choose_Transaction;
            }
            else {
                next_state = enter_Pin;
            }
            break;
        case choose_Transaction:
            if (opCode == 0) {
                next_state = choose_Transaction;
            }
            else if (opCode == 1) {
                next_state = display_Balance;
            }
            else if (opCode == 2) {
                next_state = deposit;
            }
            else if (opCode == 3) {
                next_state = check_Balance;
            }
            else {
                next_state = choose_Transaction;
            }
            break;
        case deposit:
            if (inputAmount > 0) {
                next_state = update_balance;
            }
            else {
                next_state = deposit;
            }
            break;
        case check_Balance:
            if (inputAmount < Existing_Balance) {
                next_state = withdraw;
            }
            else {
                next_state = choose_Transaction;
            }
            break;
        case withdraw:
            if (inputAmount > 0) {
                next_state = update_balance;
            }
            else {
                next_state = choose_Transaction;
            }
            break;
        case update_balance:
            if (opCode == 3) {
                Existing_Balance -= inputAmount;
                Current_Balance = Existing_Balance;
                next_state = display_Balance;
            }
            else if (opCode == 2) {
                Existing_Balance += inputAmount;
                Current_Balance = Existing_Balance;
                next_state = display_Balance;
            }
            break;
        case display_Balance:
            if (ejectCard) {
                next_state = eject_Card;
            }
            else {
                next_state = choose_Transaction;
            }
            break;
        case eject_Card:
            next_state = Idle;
            break;
        default:
            next_state = Idle;
            break;
        }
    }

    void execute() {
        state_transition();
        next_state_logic();

        ATM_Usage_Finished = (current_state == eject_Card);
        Input_Approved = (current_state == withdraw || current_state == update_balance);
        Balance_Updated = (current_state==update_balance);
        Balance_Shown = (current_state == display_Balance);
        Deposited_Successfully = (current_state==deposit);
        Withdrawed_Successfully = (current_state==withdraw);
        correctPassword = (current_state == choose_Transaction || current_state == deposit || current_state == withdraw || current_state == update_balance || current_state == display_Balance || current_state == check_Balance);
        print();
    }
    void clock_pos_edge() {
        execute();
    }
    void print() {
        cout << "ATM_Usage_Finished: " << ATM_Usage_Finished << " \t";
        cout << "Balance_Shown: " <<Balance_Shown << " \t";
        cout << "Deposited_Successfully: " << Deposited_Successfully << " \t";
        cout << "Withdrawed_Successfully: " << Withdrawed_Successfully << " \t";
        cout << "correctPassword: " << correctPassword << " \t";
        cout << "Input_Approved: " << Input_Approved << " \t";
        cout << "Balance_Updated: " << Balance_Updated << " \t";
        cout << "Current_Balance: " << Current_Balance<<endl ;
    }
};

int main() {
    ATM atm;

    cout << "Directed testing :"<<endl;
    // Directed testing

    cout << "deposit test" << endl;
    //deposit
    atm.cardIn = true;
    atm.clock_pos_edge();
    atm.Language = true;
    atm.clock_pos_edge();
    atm.password = 10; 
    atm.clock_pos_edge();
    atm.opCode = 2;  
    atm.clock_pos_edge();
    atm.inputAmount = 1100;
    atm.clock_pos_edge();
    atm.clock_pos_edge();
    atm.ejectCard = true;
    atm.clock_pos_edge();
    atm.clock_pos_edge();
    if (atm.Current_Balance == 0)cout << "error while depositing"<<endl;
    cout << "--------------------" << endl;

    cout << "reset test" << endl;
    //reset
    atm.cardIn = true;
    atm.clock_pos_edge();
    atm.Language = true;
    atm.clock_pos_edge();
    atm.password = 10;
    atm.clock_pos_edge();
    atm.clock_pos_edge();
    atm.reset = true;
    atm.clock_pos_edge();
    if (atm.correctPassword)cout << "reset doesn't work correctly" << endl;
    cout << "--------------------" << endl;

    cout << "display test" << endl;
    //Display Balance
    atm.reset = false;
    atm.Language = true;
    atm.clock_pos_edge();
    atm.password = 10;
    atm.clock_pos_edge();
    atm.opCode = 1;
    atm.clock_pos_edge();
    atm.ejectCard = true;
    atm.clock_pos_edge();
    if (!atm.Balance_Shown)cout << "error while displaying balance" << endl;
    atm.clock_pos_edge();
    cout << "--------------------" << endl;

    cout << "withdraw test" << endl;
    //withdraw
    atm.cardIn = true;
    atm.clock_pos_edge();
    atm.Language = true;
    atm.clock_pos_edge();
    atm.password = 10;
    atm.clock_pos_edge();
    atm.opCode = 3;
    atm.clock_pos_edge();
    atm.inputAmount =200 ;
    atm.clock_pos_edge();
    atm.clock_pos_edge();
    atm.clock_pos_edge();
    atm.ejectCard = true;
    atm.clock_pos_edge();
    atm.clock_pos_edge();
    if (atm.Current_Balance != 100900)cout << "error while withdrawing" << endl;
    cout << "--------------------" << endl;

    cout << "timer test" << endl;
    //timer
    atm.cardIn = true;
    atm.clock_pos_edge();
    atm.Language = true;
    atm.clock_pos_edge();
    atm.password = 10;
    atm.clock_pos_edge();
    atm.opCode = 2;
    atm.clock_pos_edge();
    atm.timer = true;
    atm.clock_pos_edge();
    atm.ejectCard = true;
    atm.clock_pos_edge();

    cout << "reset state"<<endl;
    atm.cardIn = false;
    atm.reset = true;
    atm.clock_pos_edge();

    cout << "------------------------------------------------------------------" << "\n"<<"\n"<<"\n"<<"\n" << endl;

    cout << "Randomized testing:" <<"\n" << endl;

    //randomized testing 
    atm.reset = false;
    atm.timer = false;
    atm.cardIn = false;
    atm.ejectCard = false;
    atm.Language = true;
    
    std::srand(std::time(0));
    
    for (int i = 0; i < 10; i++) {
      

        atm.cardIn = true;
        atm.clock_pos_edge();
        atm.Language = true;
        atm.clock_pos_edge();
        atm.password = 10;
        atm.clock_pos_edge();
        atm.opCode = rand() % 4;
        atm.clock_pos_edge();
        atm.inputAmount = rand() % 1000;
        atm.clock_pos_edge();
        atm.clock_pos_edge();
        atm.clock_pos_edge();
        atm.ejectCard = true;
        atm.clock_pos_edge();
        atm.clock_pos_edge();
        
       
    }




   
    return 0;
}
