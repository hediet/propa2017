import akka.actor.ActorRef;
import akka.actor.ActorSystem;
import akka.actor.Props;

public class TeaseLisa {
	public static void main(final String[] args) throws InterruptedException {
		ActorSystem actorSystem = ActorSystem.create("TeaseLisa");
		ActorRef lisa = actorSystem.actorOf(Props.create(Kid.class));
		lisa.tell("idiot", ActorRef.noSender());
		lisa.tell("muppet", ActorRef.noSender());
		lisa.tell("idiot", ActorRef.noSender());
		lisa.tell("muppet", ActorRef.noSender());
		Thread.sleep(1000);
		actorSystem.terminate();
	}
}

