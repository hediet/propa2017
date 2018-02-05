import java.util.Random;
import akka.actor.*;

public class Philosopher extends AbstractActor {
	public static final String AKKA_MSG_GIVE_SPOONS = "Give Spoons";
	public static final String AKKA_MSG_START = "Start";
	private static final int MAX_SLEEP_SIZE_IN_MS = 10000;

	private final ActorRef table;
	private final String name;

	public Philosopher(final ActorRef table, final String name) {
		this.table = table;
		this.name = name;
	}

	private void sleepRandom() throws InterruptedException {
		Thread.sleep(Math.abs(new Random().nextLong() % MAX_SLEEP_SIZE_IN_MS));
	}
}
