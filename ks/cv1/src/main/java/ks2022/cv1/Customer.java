package ks2022.cv1;

public class Customer {
	private String name;
	private boolean goldPartner;
	
	public Customer(String name, boolean goldPartner) {
		super();
		this.name = name;
		this.goldPartner = goldPartner;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public boolean isGoldPartner() {
		return goldPartner;
	}
	public void setGoldPartner(boolean goldPartner) {
		this.goldPartner = goldPartner;
	}
	
	
}
