package ks2022.cv1;

public class Invoice {
	private int price;
	private boolean paid;
	
	public Invoice(int price, boolean paid) {
		super();
		this.price = price;
		this.paid = paid;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public boolean isPaid() {
		return paid;
	}
	public void setPaid(boolean paid) {
		this.paid = paid;
	}
	
	
}
