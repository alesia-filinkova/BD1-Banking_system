package net.javaguiedes.Banking_app.controller;


import jakarta.validation.Valid;
import net.javaguiedes.Banking_app.dto.Currency;
import net.javaguiedes.Banking_app.dto.TransactionDto;
import net.javaguiedes.Banking_app.entity.*;
import net.javaguiedes.Banking_app.service.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;


import java.util.ArrayList;
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

    @GetMapping("/main")
    public String homePage(){
        return "main";
    }

    @GetMapping("/admin")
    public String adminPage(Model model) {
        Long banchId = 0L;
        model.addAttribute("branchId", banchId);
        Integer bonusAmount = 0;
        model.addAttribute("bonusAmount", bonusAmount);
        return "admin";
    }

    @GetMapping("/customer")
    public String customerPage(Model model) {
        Currency currency = new Currency();
        model.addAttribute("currency", currency);
        TransactionDto transaction = new TransactionDto();
        model.addAttribute("transactionDto", transaction);
        Long accountId = 0L;
        model.addAttribute("accountId", accountId);
        Long customerId = 0L;
        model.addAttribute("customerId", customerId);
        return "customer";
    }

    @GetMapping("/employee")
    public String employeePage(Model model) {
        Long accountId = 0L;
        model.addAttribute("accountId", accountId);

        Long customerId = 0L;
        model.addAttribute("customerId", customerId);
        Long customerIdWithNegativeBalance = 0L;
        model.addAttribute("customerIdWithNegativeBalance", customerIdWithNegativeBalance);
        Account account = new Account();
        model.addAttribute("account", account);
        return "employee";
    }

    @PostMapping("/changeCurrency")
    public String changeCurrency(
            @Valid @ModelAttribute("customer") Currency currency, Model model) {
        Account changedAccount = new Account();
        try {
            changedAccount = customerService.changeCurrency(currency.getAccountId(), currency.getNewCurrency(), currency.getExchangeRate());
            model.addAttribute("changedAccount", changedAccount);
        }
        catch (Exception e) {
            model.addAttribute("changedAccount", changedAccount);
        }
        return "/changeCurrency";
    }

    @PostMapping("/transaction")
    public String addTransaction(@Valid @ModelAttribute("transactionDto") TransactionDto transactionDto, Model model) {
        Transaction transaction = new Transaction();
        try {
            transaction = transactionService.createTransaction(
                    transactionService.findByCardNumber(transactionDto.getPaymentCard()).getId(),
                    transactionDto.getAmount(),
                    transactionDto.getTransactionType());
            model.addAttribute("transaction", transaction);
        }
        catch (Exception e) {
            model.addAttribute("transaction", transaction);
        }
        return "/transaction";
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

    @PostMapping("/avgSalaryResult")
    public String getBranchAvgSalary(@Valid @ModelAttribute("branchId") Long branchId, Model model){

        Double avgSalary = bankBranchService.getBranchAvgSalary(branchId);
        model.addAttribute("avgSalary", avgSalary);
        return "/avgSalaryResult";
    }


    @PostMapping("/last30DaysTransactions")
    public String getTransactionsLast30Days(Model model){
        List<Transaction> transactions = transactionService.getAllTransactions();
        model.addAttribute("transactions", transactions);
        return "/last30DaysTransactions";
    }


    @PostMapping("/hasActiveCard")
    public String hasActiveCard(@Valid @ModelAttribute("accountId") Long accountId, Model model
    ){
        System.out.println(accountId);
        String result = "";
        if(accountId==null){
            result = "Account id not provided";
        }
        else {
            Integer value = accountService.hasActiveCard(accountId);

            if (value == 1) {
                result = "Account has active card";
            } else {
                result = "Account hasn't active card";
            }
        }
        model.addAttribute("result", result);
        return "/hasActiveCard";
    }


    @PostMapping("/getInfo")
    public String getCustomerInfoById(@Valid @ModelAttribute("customerId") Long id,
                                                            Model model){
        List<String> info = new ArrayList<>();
        try{
            info = customerService.getCustomerInfoById(id);
        }
        catch (Exception e){
            info.add("Customer not found");
        }
        model.addAttribute("info", info);
        return "/getInfo";
    }


    @PostMapping("/removeIfNegativeBalance")
    public String removeCustomerIfNegativeBalance(
            @Valid @ModelAttribute("customerIdWithNegativeBalance") Long customerId, Model model) {
        String result = "";
        try{
            result = customerService.removeCustomerIfNegativeBalance(customerId);
        }
        catch(Exception e){
            result = "Customer not found";
        }
        model.addAttribute("result", result);
        return "removeIfNegativeBalance";
    }


    @PostMapping("/customerBalance")
    public String getBalance(
            @Valid @ModelAttribute("customerId") Long customerId,
            Model model){
        Integer result = accountService.getBalance(customerId);
        System.out.println("+++++");
        model.addAttribute("result", result);
        return "/customerBalance";
    }

    @PostMapping("/createAccount")
    public String createAccount(
            @Valid @ModelAttribute("account") Account account,
            Model model
    ){
        Account createdAccount = accountService.createAccount(account.getAccountNumber(),
                account.getBalance(), account.getCurrency(), account.getCustomer().getId());
        model.addAttribute("createdAccount", createdAccount);
        return "/createAccount";
    }

    @PostMapping("/transactionCount")
    public String getTransactionCount(
            @Valid @ModelAttribute("accountId") Long accountId,
            Model model
    ) {
        String result;
        try {
            Integer transactionCount = transactionService.getTransactionCountForAccount(accountId);
            result = "The account has " + transactionCount + " transactions.";
        } catch (Exception e) {
            result = "Error: " + e.getMessage();
        }
        model.addAttribute("result", result);
        return "/transactionCount";
    }

    @PostMapping("/transactionHistory")
    public String getTransactionHistory(@RequestParam("paymentCardId") Long paymentCardId, Model model) {
        System.out.println(paymentCardId);
        List<TransactionDto> transactions = transactionService.getTransactionHistory(paymentCardId);
        System.out.println(transactions);
        model.addAttribute("transactions", transactions);
        return "/transactionHistory";
    }

    @PostMapping("/distributeBonus")
    public String distributeBonus(@RequestParam("bonusAmount") Integer bonusAmount, Model model) {
        employeeService.distributeBonus(bonusAmount);
        model.addAttribute("result", "Bonus distribute successfully");
        return "/distributeBonus";
    }

    @GetMapping("/deleteInactiveAccounts")
    public String deleteInactiveAccounts(Model model) {
        employeeService.deleteInactiveAccounts();
        model.addAttribute("result", "Inactive account deleted successfully");
        return "/deleteInactiveAccounts";
    }

    @PostMapping("/newPaymentCard")
    public String createNewPaymentCard(@RequestParam("accountId") Long accountId, Model model) {
        try {
            accountService.createNewPaymentCard(accountId);
            PaymentCard newCard = accountService.getLastPaymentCard(accountId);

            model.addAttribute("card", newCard);
            return "newPaymentCard";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to create a payment card: " + e.getMessage());
            return "newPaymentCard";
        }
    }

    @PostMapping("/assignEmployee")
    public String assignEmployee(
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            Model model) {
        try {
            employeeService.assignEmployee(firstName, lastName);
            model.addAttribute("success", "Employee successfully assigned.");
        } catch (Exception e) {
            model.addAttribute("error", "Failed to assign employee: " + e.getMessage());
        }
        return "assignEmployee";
    }

}
