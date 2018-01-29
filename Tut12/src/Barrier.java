import sun.reflect.generics.reflectiveObjects.NotImplementedException;

interface IBarrier {
	void await() throws InterruptedException;

	/*
	 * Löst eine manuelle Freigabe aus. Es wird jeder Thread, der zuvor await aufgerufen hat, freigegeben.
	 */
	void freeAll();
}

public class Barrier implements IBarrier {
	private int maxParties;
	private int currentParties;
	private boolean resetInProgress;
	private long irregularResetPhase;
	private long currentPhase;

	public Barrier(int maxParties) {
		if (maxParties <= 0)
			throw new IllegalArgumentException("maxParties has to be greater than zero.");
		this.maxParties = maxParties;
		currentParties = 0;
		resetInProgress = false;
		irregularResetPhase = 0;
		currentPhase = 1;
	}

	public synchronized void await() throws InterruptedException {
		long enteringPhase = irregularResetPhase;
		while (resetInProgress)
			wait();
		// if there was a freeAll in the meantime => return immediately
		// (because it was already freed and should not wait for next regular reset)
		if (irregularResetPhase > enteringPhase)
			return;
		currentParties++;
		if (currentParties < maxParties) {
			// wait for reset
			do {
				wait();
			} while (!resetInProgress);
		} else {
			// capacity reached => start reset, wake all
			resetInProgress = true;
			currentPhase++;
			notifyAll();
		}
		
		currentParties--;
		// end the reset progress, signal newcomer threads
		if (currentParties == 0) {
			resetInProgress = false;
			notifyAll();
		}
	}

	public synchronized void freeAll() {
		if (currentParties > 0) {
			resetInProgress = true;
			irregularResetPhase = currentPhase++;
			notifyAll();
		}
	}
}