package net.javaguiedes.Banking_app.controller;


import jakarta.validation.Valid;
import net.javaguiedes.Banking_app.entity.Account;
import net.javaguiedes.Banking_app.entity.Address;
import net.javaguiedes.Banking_app.entity.Customer;
import net.javaguiedes.Banking_app.entity.Transaction;
import net.javaguiedes.Banking_app.service.*;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@Controller
public class MainController {
    private EmployeeService employeeService;
    private final CustomerService customerService;
    private final TransactionService transactionService;
    private final BankBranchService bankBranchService;
    private final AccountService accountService;

    public MainController(CustomerService customerService, EmployeeService employeeService,
                          TransactionService transactionService, BankBranchService bankBranchService,
                          AccountService accountService) {
        this.employeeService = employeeService;
        this.customerService = customerService;
        this.transactionService = transactionService;
        this.bankBranchService = bankBranchService;
        this.accountService = accountService;
    }

    @GetMapping("/home")
    public String homePage(){
        return "home";
    }
    @PostMapping("/{accountId}/change-currency")
    public ResponseEntity<Account> changeCurrency(
            @PathVariable Long accountId,
            @RequestParam String newCurrency,
            @RequestParam Double exchangeRate
    ) {

        Account cchangedAccount = customerService.changeCurrency(accountId, newCurrency, exchangeRate);
        return ResponseEntity.ok().body(cchangedAccount);
    }

    @PostMapping("/transaction/{paymentCardId}")
    public ResponseEntity<Transaction> addTransaction(
            @PathVariable Long paymentCardId,
            @RequestParam Integer amount,
            @RequestParam String transactionType){
        return ResponseEntity.ok().body(transactionService.createTransaction(paymentCardId, amount, transactionType));
    }

    @GetMapping("/addCustomer")
    public String showRegistrationForm(Model model) {
        Customer customer = new Customer();
        Address address = new Address();
        customer.setAddress(address);
        model.addAttribute("customer", customer);
        return "addCustomer";
    }

    @PostMapping("/addCustomer/save")
    public String registration(@Valid @ModelAttribute("customer") Customer customer,
                               BindingResult result,
                               Model model) {
        Customer existingCustomer = customerService.findCustomerByEmail(customer.getEmail());

        if (existingCustomer != null && existingCustomer.getEmail() != null && !existingCustomer.getEmail().isEmpty()) {
            result.rejectValue("email", null,
                    "There is already an account registered with the same email");
        }

        if (result.hasErrors()) {
            model.addAttribute("customer", customer);
            return "/addCustomer";
        }

        customerService.addCustomer(customer.getFirstName(), customer.getLastName(), customer.getPesel(), customer.getEmail(),
                customer.getPhoneNumber(), customer.getAddress().getStreet(), customer.getAddress().getCity(), customer.getAddress().getCountry());
        return "redirect:/addCustomer?success";
    }


    @GetMapping("/admin")
    public String adminPage(Model model) {
        Long banchId = 0L;
        model.addAttribute("branchId", banchId);
        return "admin";
    }

    @PostMapping("/avgSalaryResult")
    public String getBranchAvgSalary(@Valid @ModelAttribute("branchId") Long branchId, Model model){

        Double avgSalary = bankBranchService.getBranchAvgSalary(branchId);
        model.addAttribute("avgSalary", avgSalary);
        return "/avgSalaryResult";
    }


    @GetMapping("has-active-card/{accountId}")
    public ResponseEntity<String> hasActiveCard(
            @PathVariable Long accountId
    ){
        Integer value = accountService.hasActiveCard(accountId);
        if(value ==1){
            return ResponseEntity.ok().body("Account has active card");
        }
        return ResponseEntity.ok().body("Account hasn't active card");
    }

    @GetMapping("/last30DaysTransactions")
    public String getTransactionsLast30Days(Model model){
        List<Transaction> transactions = transactionService.getAllTransactions();
        model.addAttribute("transactions", transactions);
        return "/last30DaysTransactions";
    }


    @GetMapping("get-info/{id}")
    public ResponseEntity<List<String>> getCustomerInfoById(
            @PathVariable Long id){
        return ResponseEntity.ok().body(customerService.getCustomerInfoById(id));
    }

    @DeleteMapping("/remove-if-negative-balance/{id}")
    public ResponseEntity<String> removeCustomerIfNegativeBalance(@PathVariable("id") Long customerId) {
        return ResponseEntity.ok().body(customerService.removeCustomerIfNegativeBalance(customerId));
    }

    @GetMapping("/customer-balance/{customerId}")
    public ResponseEntity<Integer> getBalance(@PathVariable Long customerId){
        return ResponseEntity.ok().body(accountService.getBalance(customerId));
    }

    @PostMapping("/create-account/{customerId}")
    public ResponseEntity<Account> createAccount(
            @RequestParam String accountNumber,
            @RequestParam Integer balance,
            @RequestParam String currency,
            @PathVariable Long customerId
    ){
        return ResponseEntity.ok().body(accountService.createAccount(accountNumber, balance, currency, customerId));
    }


}
