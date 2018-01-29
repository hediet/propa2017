package division;

public final class PrimeTester {
	public static boolean isPrime(int n) {
		if (n < 2) return false;
		for (int i = 2; i <= Math.sqrt(n); ++i) {
			if (n % i == 0) return false;
		}
		return true;
	}
}

public final class PrimeCounterSequential {
	public static int countPrimes(final int until) {
		int count = 0;
		for (int i = 2; i <= until; ++i) {
			if (PrimeTester.isPrime(i)) ++count;
		}
		return count;
	}
	
	public static void main(String[] args) {
		final int target = 100000000;
		final long startTime = System.currentTimeMillis();
		int count = countPrimes(target);
		final long endTime = System.currentTimeMillis();
			System.out.println("Duration for interval [2, " + target + "] is "
				+ (endTime - startTime) + " ms\n" + count + " primes");
	}
}