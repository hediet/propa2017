package petri;

public interface Token {}

public class Place {
	private final List<Token> tokens;
	private final int capacity;

	public Place(Collection<Token> initialTokens, int capacity) {
		this.tokens = new ArrayList<>();
		this.tokens.addAll(initialTokens);
		this.capacity = capacity;
	}

	/**
	* Bewegt ein Token von diesem in den übergebenen Place.
	* Das Token kann sich in einem Übergangszustand befinden,
	* in dem es weder in diesem noch in dem Ziel-Place vorhanden ist.
	*/
	public void moveTokenTo(Place otherPlace) {
		Token token = this.takeAnyToken();
		otherPlace.putToken(token);
	}

	/**
	* Fügt der "tokens"-Liste das übergebene Token hinzu.
	* Falls die Kapazität der Liste aktuell erschöpft ist, wartet
	* die Methode, bis ein Token entfernt wurde.
	*/
	private void putToken(Token token) {
		/* Lösung: */
		synchronized(this) {
			while (this.tokens.size() >= capacity) {
				try {
					wait();
				} catch (InterruptedException e) {}
			}
			this.tokens.add(token);
			notifyAll();
		}
		/* Lösung Ende */
	}
	/**
	* Gibt ein beliebiges Token aus der "tokens"-Liste zurück.
	* Falls aktuell kein Token vorhanden ist, wartet die Methode,
	* bis ein Token hinzugefügt wurde.
	*/
	private Token takeAnyToken() {
		/* Lösung: */
		synchronized(this) {
			while (this.tokens.size() == 0) {
				try {
					wait();
				} catch (InterruptedException e) {}
			}
			notifyAll();
			return this.tokens.remove(0);
		}
		/* Lösung Ende */
	}
}