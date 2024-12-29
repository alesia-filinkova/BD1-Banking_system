package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.Customer;
import net.javaguiedes.Banking_app.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {
}
