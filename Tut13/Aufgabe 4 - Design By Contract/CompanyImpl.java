import java.util.ArrayList;
import java.util.List;

public class CompanyImpl implements Company {
	private List<Employee> employees;

	public CompanyImpl() { employees = new ArrayList<>(); }

	@Override
	public List<Employee> getEmployees() { return new ArrayList<>(employees); }

	@Override
	public void hire(final Employee employee) {
		assert employee != null;
		assert !getEmployees().contains(employee);
		assert !employee.isEmployed();
		List<Employee> oldEmployees = getEmployees();

		employees.add(employee);
		employee.hire();

		assert employee.isEmployed();
		assert getEmployees().contains(employee);
		assert getEmployees().containsAll(oldEmployees);
		assert getEmployees().size() == oldEmployees.size() + 1;
	}

	@Override
	public void fire(final Employee employee) {
		assert employee != null;
		assert getEmployees().contains(employee);
		List<Employee> oldEmployees = getEmployees();
		List<Employee> emp = getEmployees();
		emp.remove(employee);

		employees.remove(employee);
		employee.fire();

		assert !employee.isEmployed();
		assert !getEmployees().contains(employee);
		assert getEmployees().containsAll(emp);
		assert getEmployees().size() == oldEmployees.size() - 1;
	}
}
