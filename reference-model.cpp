#include <iostream>
#include <string>
using namespace std;


class Account {
private:
    int balance;

public:

    Account(int initialBalance = 100000) {
        balance = initialBalance;
    }


    void deposit(int amount) {
        balance += amount;
    }


    void withdraw(int amount) {
        if (amount <= balance) {
            balance -= amount;
        }
        else {
            cout << "Insufficient balance!" << std::endl;
        }
    }


    int checkBalance() {
        return balance;
    }
};

class ATM {
private:
    int pin = 1010;
    Account account;

public:
    ATM(int entered_pin, int initial_balance = 100000) {
        if (entered_pin == pin) {
            cout << "Welcome to the ATM" << endl;
            account = Account(initial_balance);
        }
        else {
            cout << "Incorrect PIN" << endl;
            exit(0);
        }
    }

    void deposit(int amount) {
        account.deposit(amount);
    }

    void withdraw(int amount) {
        account.withdraw(amount);
    }

    int checkBalance() {
        return account.checkBalance();
    }
};



int main() {

    ATM atm(1010);
    atm.deposit(1000);
    cout << "Balance: " << atm.checkBalance() << endl;
    atm.withdraw(500);
    cout << "Balance: " << atm.checkBalance() << endl;


    return 0;
}
