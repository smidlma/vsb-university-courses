package ks2022.cv1;

import java.util.Arrays;
import java.util.List;

public class CustomerRepository {
	public List<Invoice> getInvoicesFor(long customerId){
		return Arrays.asList(
					new Invoice(100, false), 
					new Invoice(5000, false));
	}

	public Customer find(long customerId) {
		Customer cus = new Customer("", false);
		if(customerId == 0)
			cus.setGoldPartner(true);
		cus.setName("Dave Mustaine");
		return cus;
	}
}
