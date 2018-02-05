import akka.actor.*;

public class Main {
	public static void main(final String[] args) {
		ActorSystem actorSystem = ActorSystem.create("DiningPhilosophers");
		actorSystem.actorOf(Props.create(Table.class, actorSystem));
	}
}

public class Table extends AbstractActor {
	public static final String AKKA_MSG_APPLY_FOR_SPOONS = "Apply for Spoons";
	public static final String AKKA_MSG_RETURN_SPOONS = "Return Spoons";

	private static final String[] philosopherNames = { "Sokrates", "Kant", "Laozi", "Epikur", "Platon" };


	private Table(final ActorSystem actorSystem) {
		
	}
}