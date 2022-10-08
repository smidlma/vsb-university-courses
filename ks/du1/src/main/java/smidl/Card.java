package smidl;

import java.util.List;

public class Card {
    private double limit;
    private boolean active;
    private List<Double> payments;

    public Card(double limit, boolean active, List<Double> payments) {
        this.limit = limit;
        this.active = active;
        this.payments = payments;
    }

    public double getLimit() {
        return limit;
    }

    public boolean isActive() {
        return active;
    }

    public List<Double> getPayments() {
        return payments;
    }

    @Override
    public String toString() {
        return "Card [limit=" + limit + ", active=" + active + ", payments=" + payments + "]";
    }

}
