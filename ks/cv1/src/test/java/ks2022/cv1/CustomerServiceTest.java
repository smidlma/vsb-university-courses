package ks2022.cv1;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Arrays;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class CustomerServiceTest {

	@InjectMocks
	private CustomerService customerServ;

	@Mock
	private CustomerRepository customerRepo;

	@Test
	void testIsCredible() {

		Mockito.when(customerRepo.find(1))
				.thenReturn(new Customer("Pepa", true));
		Mockito.when(customerRepo.getInvoicesFor(1))
				.thenReturn(Arrays.asList(new Invoice(1000, false), new Invoice(500, false)));

		assertTrue(customerServ.isCredible(1));
	}

	@Test
	void testIsCredible2() {

		Mockito.when(customerRepo.find(1))
				.thenReturn(new Customer("Pepa", false));
		Mockito.when(customerRepo.getInvoicesFor(1))
				.thenReturn(Arrays.asList(new Invoice(1000, false), new Invoice(500, false)));

		assertFalse(customerServ.isCredible(1));
	}
}
