package net.javaguiedes.Banking_app.controller;



import net.javaguiedes.Banking_app.entity.Account;
import net.javaguiedes.Banking_app.entity.Customer;
import net.javaguiedes.Banking_app.entity.Transaction;
import net.javaguiedes.Banking_app.service.*;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
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

    @PostMapping("/add-customer")
    public ResponseEntity<Customer> addCustomer(
            @RequestParam String firstName,
            @RequestParam String lastName,
            @RequestParam String pesel,
            @RequestParam String email,
            @RequestParam String phoneNumber,
            @RequestParam String street,
            @RequestParam String city,
            @RequestParam String country
    ){
        return ResponseEntity.ok().body(customerService.addCustomer(firstName, lastName, pesel,
                email, phoneNumber, street, city, country));
    }

    @GetMapping("/avg-salary/{branchId}")
    public ResponseEntity<Double> getBranchAvgSalary(
            @PathVariable Long branchId
    ){
        return ResponseEntity.ok().body(bankBranchService.getBranchAvgSalary(branchId));
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

    @GetMapping("last-30-days-transactions")
    public ResponseEntity<List<Transaction>> getTransactionsLast30Days(){
        return ResponseEntity.ok().body(transactionService.getAllTransactions());
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
