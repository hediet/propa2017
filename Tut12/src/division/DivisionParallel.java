package division;

import java.util.HashSet;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

public final class PrimeCounterParallelSupplier {	
	public static void main(String[] args) {
		final long startTime = System.currentTimeMillis();
		int until = Integer.valueOf(args[0]);
		int threads = Integer.valueOf(args[1]);
		int count = countPrimes(until, threads);
		final long endTime = System.currentTimeMillis();
		System.out.println(threads + " thread duration for interval [2, " + until + "] is "
			+ (endTime - startTime) + " ms\n" + count + " primes");
	}

	/* Lösung: */
	private static class State {
		private int currentNumber = 1;
		private int result = 0;
		private final int target;
		State(int target) {
			this.target = target;
		}
		synchronized int nextNumber() {
			return currentNumber < target ? ++currentNumber : -1;
		}
		synchronized void addToResult(Integer count) {
			this.result += count;
		}
		int getResult() {
			return result;
		}
	}

	public static int countPrimes(final int until, final int threads) {
		final State state = new State(until);
		Set<CompletableFuture<Void>> futures = new HashSet<>();
		for (int i = 0; i < threads; ++i) {
			futures.add(CompletableFuture.supplyAsync(() -> {
				int currentNumber = 0;
				int partialCount = 0;
				while (currentNumber != -1) {
					if (PrimeTester.isPrime(currentNumber))
					++partialCount;
					currentNumber = state.nextNumber();
				}
				return partialCount;
			}).thenAccept(state::addToResult));
		}

		for (CompletableFuture<Void> future : futures) {
			try {
				future.get();
			} catch (InterruptedException | ExecutionException e) {
				e.printStackTrace();
				return -1;
			}
		}
		return state.getResult();
	}

	/* Lösung Ende */
}