package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.Customer;
import net.javaguiedes.Banking_app.entity.Employee;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

public interface EmployeeRepository extends JpaRepository<Employee, Long> {

    @Procedure(name = "distribute_bonus")
    void distributeBonus(@Param("p_bonus_amount") Integer bonus_amount);

    @Procedure(name = "delete_inactive_accounts")
    void deleteInactiveAccounts();
}
