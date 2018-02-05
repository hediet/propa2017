import java.util.List;

public interface Company {
	public /*@ pure @*/ List<Employee> getEmployees();

	/*@
	  @ requires employee != null
	  @ requires !getEmployees().contains(employee)
	  @ requires !employee.isEmployed();
	  @ ensures employee.isEmployed()
	  @ ensures getEmployees().contains(employee)
	  @ ensures getEmployees().containsAll(\old(getEmployees());
	  @ ensures getEmployees().size() == \old(getEmployees().size()) + 1
	 * 
	 */
	public void hire(Employee employee);

	/**
	 * Vorbedingungen:
	 *   employee != null
	 *   && getEmployees().contains(employee)
	 *   && employee.isEmployed
	 * 
	 * Nachbedingungen:
	 *   !employee.isEmployed()
	 *   && !getEmployees().contains(employee)
	 *   && \old(getEmployees()).containsAll(getEmployees())
	 *   && !getEmployees().contains(employee)
	 *   && getEmployees().size() == \old(getEmployees()).size() - 1
	 */
	public void fire(Employee employee);
}