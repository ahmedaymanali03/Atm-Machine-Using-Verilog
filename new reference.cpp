#include <iostream>

class ATM {
public:
    // Inputs
    bool clk, reset, cardIn, moneyDeposited, ejectCard, Another_Operation, Language;
    unsigned char password;
    unsigned char opCode;
    int inputAmount;

    // Outputs
    bool ATM_Usage_Finished, Balance_Shown, Deposited_Successfully, Withdrawed_Successfully, correctPassword;

    // Internal state and variables
    unsigned int Existing_Balance;
    unsigned char Correct_Pass;

    enum State {
        Idle, choose_Language, enter_Pin, choose_Transaction, deposit,
        withdraw, check_Balance, update_balance, display_Balance, eject_Card
    };

    State current_state, next_state;

    // Constructor
    ATM() : Existing_Balance(1000000), Correct_Pass(10) {
        resetState();
    }

    // Methods
    void resetState() {
        current_state = Idle;
        next_state = Idle;
        ATM_Usage_Finished = false;
        Balance_Shown = false;
        Deposited_Successfully = false;
        Withdrawed_Successfully = false;
        correctPassword = false;
    }

    void transition() {
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
                if (inputAmount)
                    next_state = check_Balance;
                else
                    next_state = withdraw;
                break;

            case check_Balance:
                if (inputAmount > Existing_Balance)
                    next_state = withdraw;
                else
                    next_state = update_balance;
                break;

            case update_balance:
                next_state = display_Balance;
                if (moneyDeposited)
                    Existing_Balance = Existing_Balance + inputAmount;
                else if (inputAmount)
                    Existing_Balance = Existing_Balance - inputAmount;
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
                break;
        }
    }

    void updateOutputs() {
        switch (current_state) {
            case Idle:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = false;
                break;

            case choose_Language:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = false;
                break;

            case enter_Pin:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = false;
                break;

            case choose_Transaction:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = true;
                break;

            case deposit:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = true;
                Withdrawed_Successfully = false;
                correctPassword = true;
                break;

            case withdraw:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = true;
                correctPassword = true;
                break;

            case check_Balance:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = true;
                break;

            case update_balance:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = true;
                break;

            case display_Balance:
                ATM_Usage_Finished = false;
                Balance_Shown = true;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = true;
                break;

            case eject_Card:
                ATM_Usage_Finished = true;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = true;
                break;

            default:
                ATM_Usage_Finished = false;
                Balance_Shown = false;
                Deposited_Successfully = false;
                Withdrawed_Successfully = false;
                correctPassword = false;
                break;
        }
    }

    void simulateClockCycle() {
        if (reset) {
            resetState();
        } else {
            current_state = next_state;
        }

        transition();
        updateOutputs();
    }
};

int main() {
    ATM atm;

    // Simulation loop
    for (int i = 0; i < 100; ++i) {
        // Update inputs randomly (replace with your input logic)
        atm.clk = i % 2 == 0;
        atm.reset = i < 10;
        atm.cardIn = i % 3 == 0;
        atm.moneyDeposited = i % 4 == 0;
        atm.opCode = i % 4;
        atm.inputAmount = i * 100;
        atm.Language = true;
        atm.Another_Operation = false;
        atm.ejectCard = false;

        // Simulate one clock cycle
        atm.simulateClockCycle();

        // Display outputs (replace with your output handling logic)
        std::cout << "ATM_Usage_Finished: " << atm.ATM_Usage_Finished << std::endl;
        std::cout << "Balance_Shown: " << atm.Balance_Shown << std::endl;
        std::cout << "Deposited_Successfully: " << atm.Deposited_Successfully << std::endl;
        std::cout << "Withdrawed_Successfully: " << atm.Withdrawed_Successfully << std::endl;
        std::cout << "correctPassword: " << atm.correctPassword << std::endl;

        // Add delay or handle time progression as needed
    }

    return 0;
}
