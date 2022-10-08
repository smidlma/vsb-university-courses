package smidl;

public class Account {
    private double balance;
    private Card card;

    public Account(double balance, Card card) {
        this.balance = balance;
        this.card = card;
    }

    public double getBalance() {
        return balance;
    }

    public Card getCard() {
        return card;
    }

}
