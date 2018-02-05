import akka.actor.*;

public class Kid extends AbstractActor {
	private int counter = 0;

	@Override
	public Receive createReceive() {
		return receiveBuilder()
			.match(String.class, this::handleMessage).build();
	}

	private void handleMessage(String message) {
		if (message.equals("idiot") || message.equals("muppet")) {
			counter++;
			
			if (counter >= 4) 
				System.out.println("Mum, help me!");
			else
				System.out.println("Stop it!");
		}
	}
}