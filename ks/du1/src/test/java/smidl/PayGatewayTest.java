package smidl;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.Arrays;
import java.util.stream.Stream;

import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
public class PayGatewayTest {
    @InjectMocks
    private AccountService accountService;

    @Mock
    private AccountRepository accountRepository;

    @ParameterizedTest(name = "Payment test balance={0}, amount={1}, card={2}, res={3}")
    @MethodSource("generateData")
    public void testPayment(double balance, double amount, Card card, boolean result) {


    Mockito.when(accountRepository.find(1)).thenReturn(new Account(balance,card));

    assertEquals(result, accountService.isAccountAbleToPay(1, amount));


    }

    static Stream<Arguments> generateData() {
        return Stream.of(
                Arguments.of(5000, 100, new Card(5000, true, Arrays.asList(500.25, 1111.11, 555.1)), true),
                Arguments.of(10000, 200, new Card(100, true, Arrays.asList(500.25, 1111.11, 555.1)), false),
                Arguments.of(10000, 500, new Card(5000, true, Arrays.asList(500.25, 4500.5, 10.1)), false),
                Arguments.of(400, 400, new Card(400, true, Arrays.asList()), true),
                Arguments.of(400, 400, new Card(400, false, Arrays.asList()), false));

    }

}
