public class Employee {
	private boolean isEmployed;
	public Employee() { isEmployed = false; }
	protected void hire() { isEmployed = true; }
	protected void fire() { isEmployed = false; }
	public boolean isEmployed() { return isEmployed; }
}