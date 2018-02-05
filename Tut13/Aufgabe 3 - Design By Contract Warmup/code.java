// Finde alle Contract-Verletzungen!
public interface Good { }
public interface Counter {
	/**
	  * Gibt ein Gut aus der Theke zurück. Gibt null zurück, falls sie leer ist
	  */
	public Good takeSomeGood();
}
public class Cart {
	private Set<Good> goods = new HashSet<Good>();
	/*@
	  @ requires good != null;
	  @ ensures getGoods().contains(good);
	  @ private behavior
	  @ ensures goods.contains(good);
	  @ ensures goods.contains(\old(good));
	  @ ensures goods.size() == \old(goods.size()) + 1;
	  @*/
	public void put(Good good) { goods.add(good); }
	public /*@ pure @*/ Collection<Good> getGoods() { return goods; }
}

public class Person {
	public void shop(Counter counter) {
		Cart cart = new Cart();
		for (int i = 0; i < new Random().nextInt(20); i++) {
			cart.put(counter.takeSomeGood());
		}
	}
}