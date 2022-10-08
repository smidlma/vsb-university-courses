package smidl;

import java.util.Arrays;

public class AccountRepository {

    public Account find(int accId) {
        Account acc = new Account(5000, new Card(5000, true, Arrays.asList(500.5, 200.9, 300.44, 400.25)));
        return acc;
    }
}
