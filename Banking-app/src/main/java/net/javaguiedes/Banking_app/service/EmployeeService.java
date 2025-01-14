package net.javaguiedes.Banking_app.service;

import net.javaguiedes.Banking_app.repository.EmployeeRepository;
import org.springframework.stereotype.Service;

@Service
public class EmployeeService {
    private final EmployeeRepository employeeRepository;
    public EmployeeService(EmployeeRepository employeeRepository) {
        this.employeeRepository = employeeRepository;
    }

    public void distributeBonus(Integer bonus_amount){
        employeeRepository.distributeBonus(bonus_amount);
    }

    public void deleteInactiveAccounts(){
        employeeRepository.deleteInactiveAccounts();
    }

    public void assignEmployee(String firstName, String lastName) {
        employeeRepository.assignEmployee(firstName, lastName);
    }
}
