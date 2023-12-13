#include <iostream>
#include <cstdlib>
#include <ctime>

class ATM {
public:
    // Inputs
    bool clk;
    bool reset;
    bool cardIn;
    bool moneyDeposited;
    bool ejectCard;
    bool Another_Operation;
    bool Language;
    unsigned char password;  // Assuming 4-bit password
    unsigned char opCode;    // Assuming 2-bit opCode
    unsigned int inputAmount;

    // Outputs
    bool ATM_Usage_Finished;
    bool Balance_Shown;
    bool Deposited_Successfully;
    bool Withdrawed_Successfully;
    bool correctPassword;
    unsigned int Current_Balance;

    // Internal State
    unsigned int Existing_Balance;
    unsigned char Correct_Pass;
    enum State {
        Idle,
        choose_Language,
        enter_Pin,
        choose_Transaction,
        deposit,
        withdraw,
        update_balance,
        display_Balance,
        eject_Card
    } current_state, next_state;

    // Constructor
    ATM() : Existing_Balance(100000), Correct_Pass(0xA) {
        reset_internal();
    }

    // Member functions
    void reset_internal() {
        Current_Balance = Existing_Balance;
        current_state = Idle;
        ATM_Usage_Finished = false;
        Balance_Shown = false;
        Deposited_Successfully = false;
        Withdrawed_Successfully = false;
        correctPassword = false;
    }

    void update() {
        Current_Balance = Existing_Balance;

        switch (current_state) {
        case Idle:
            if (cardIn)
                next_state = choose_Language;
            else
                next_state = Idle;
            break;

        case choose_Language:
            if (Language)
                next_state = enter_Pin;
            else
                next_state = choose_Language;
            break;

        case enter_Pin:
            if (password != Correct_Pass)
                next_state = enter_Pin;
            else if (password == Correct_Pass)
                next_state = choose_Transaction;
            else
                next_state = enter_Pin;
            break;

        case choose_Transaction:
            if (opCode == 0b00)
                next_state = choose_Transaction;
            else if (opCode == 0b01)
                next_state = display_Balance;
            else if (opCode == 0b10)
                next_state = deposit;
            else if (opCode == 0b11)
                next_state = withdraw;
            else
                next_state = choose_Transaction;
            break;

        case deposit:
            if (moneyDeposited)
                next_state = update_balance;
            else
                next_state = deposit;
            break;

        case withdraw:
            if (inputAmount <= Existing_Balance)
                next_state = update_balance;
            else
                next_state = choose_Transaction;
            break;
        case update_balance:
            if (inputAmount <= Existing_Balance) {
                if (moneyDeposited) {
                    Existing_Balance += inputAmount;
                    next_state = display_Balance;
                }
                else {
                    Existing_Balance -= inputAmount;
                    Withdrawed_Successfully = true;
                    next_state = display_Balance;
                }
            }
            else {
                next_state = display_Balance;
            }
            break;

        case display_Balance:
            if (ejectCard)
                next_state = eject_Card;
            else
                next_state = choose_Transaction;
            break;

        case eject_Card:
            next_state = Idle;
            break;

        default:
            next_state = Idle;
        }

        // Update outputs based on the current state
        ATM_Usage_Finished = (next_state == Idle);
        Balance_Shown = (next_state == display_Balance);
        Deposited_Successfully = (next_state == update_balance && moneyDeposited);
        correctPassword = (next_state == choose_Transaction || next_state == deposit || next_state == withdraw || next_state == update_balance);

        // Reset Withdrawed_Successfully flag
        Withdrawed_Successfully = false;
        if (next_state == display_Balance) {
            Withdrawed_Successfully = false;
        }
        // Update internal state
        current_state = next_state;
    }

    // Function to simulate clock edge
    void clock_edge() {
        update();
    }
};

int main() {
    ATM atm;

    // Seed for random number generation
    std::srand(std::time(0));
    atm.reset = false;  // Assuming not resetting during simulation
    atm.cardIn = true;  // Assuming card is inserted
    atm.Language = true;  // Assuming English language for simplicity
   
    atm.ejectCard = false;  // Assuming not ejecting during simulation
    atm.Another_Operation = false;  // Assuming not choosing another operation during simulation
    atm.password = 0xA;

    for (int i = 0; i < 100; ++i) {
        // Simulate clock edges
        atm.clk = true;
        atm.clock_edge();

        atm.clk = false;
        atm.clock_edge();
        atm.moneyDeposited = rand() % 2 == 1;
        // Update inputs based on your test scenario
         // Assuming correct password
        atm.opCode = rand() % 4;  // Assuming random opCode for testing
        atm.inputAmount = rand() % 1000;  // Assuming random inputAmount for testing

        // Print outputs for debugging
        std::cout << "Current State: " << atm.current_state << std::endl;
        std::cout << "Current Balance: " << atm.Current_Balance << std::endl;
        std::cout << "ATM Usage Finished: " << atm.ATM_Usage_Finished << std::endl;
        std::cout << "Balance Shown: " << atm.Balance_Shown << std::endl;
        std::cout << "Deposited Successfully: " << atm.Deposited_Successfully << std::endl;
        std::cout << "Withdrawed Successfully: " << atm.Withdrawed_Successfully << std::endl;
        std::cout << "Correct Password: " << atm.correctPassword << std::endl;
        std::cout << "------------------------" << std::endl;

        // Sleep for a short duration to simulate time passing
        // Sleep function depends on your environment (e.g., std::this_thread::sleep_for)
    }

    return 0;
}
