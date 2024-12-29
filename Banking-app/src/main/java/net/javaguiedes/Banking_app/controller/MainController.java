package net.javaguiedes.Banking_app.controller;



import net.javaguiedes.Banking_app.service.CustomerService;
import net.javaguiedes.Banking_app.service.EmployeeService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
public class MainController {
    private CustomerService customerService;
    private EmployeeService employeeService;

    public MainController(CustomerService customerService, EmployeeService employeeService) {
        this.customerService = customerService;
        this.employeeService = employeeService;
    }

    @GetMapping("/home")
    public String homePage(){
        return "home";
    }
}
