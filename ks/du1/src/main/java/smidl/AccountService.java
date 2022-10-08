package smidl;

public class AccountService {
    private AccountRepository accountRepository = new AccountRepository();

    public boolean isAccountAbleToPay(int accountId, double amount) {
        Account acc = accountRepository.find(accountId);
        double total = amount;
        if (acc.getBalance() >= amount) {
            if (acc.getCard().isActive()) {
                for (double payment : acc.getCard().getPayments()) {
                    total += payment;
                }
                if (total <= acc.getCard().getLimit()) {
                    return true;
                }
            }
        }

        return false;
    }
}
