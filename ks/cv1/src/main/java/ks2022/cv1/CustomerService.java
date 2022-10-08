package ks2022.cv1;

import java.util.List;

public class CustomerService {
	private CustomerRepository customerRepository = new CustomerRepository();

	public boolean isCredible(long customerId) {
		List<Invoice> invoices = customerRepository.getInvoicesFor(customerId);
		Customer customer = customerRepository.find(customerId);
		int price = 0;
		for (Invoice invoice : invoices) {
			if (!invoice.isPaid()) {
				price += invoice.getPrice();
			}
		}
		if (price < 200 || customer.isGoldPartner()) {
			return true;
		}
		return false;
	}

}
