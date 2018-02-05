import akka.actor.*;

public class PingPongMain {
	public static void main(final String[] args) {
		ActorSystem actorSystem = ActorSystem.create("PingPong");
		ActorRef pong = actorSystem.actorOf(Props.create(PingPong.class, "pong"));
		ActorRef ping = actorSystem.actorOf(Props.create(PingPong.class, "ping"));
		ping.tell(0, pong);
	}
}

class PingPong extends AbstractActor {
	private String name;
	public PingPong(final String name) throws Throwable {
		this.name = name;
	}

	@Override
	public Receive createReceive() {
		return receiveBuilde()
			.match(Integer.class, this::handleMessage)
			.matchAny(message -> System.exit(0))
			.build();
	}

	private void handleMessage(Integer value) throws InterruptedException {
		System.out.println(name + " received " + receivedValue);
		Thread.sleep(500);
		getSender().tell(receivedValue + 1, getSelf());
	}
}
