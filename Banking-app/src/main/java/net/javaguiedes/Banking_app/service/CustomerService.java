package net.javaguiedes.Banking_app.service;


import net.javaguiedes.Banking_app.entity.Account;
import net.javaguiedes.Banking_app.entity.Customer;
import net.javaguiedes.Banking_app.repository.AccountRepository;
import net.javaguiedes.Banking_app.repository.CustomerRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class CustomerService {
    private CustomerRepository customerRepository;
    private AccountRepository accountRepository;
    public CustomerService(CustomerRepository customerRepository, AccountRepository accountRepository) {
        this.customerRepository = customerRepository;
        this.accountRepository = accountRepository;
    }

    public Account changeCurrency(Long accountId, String newCurrency, Double exchangeRate) {
        customerRepository.changeAccountCurrency(accountId, newCurrency, exchangeRate);
        System.out.println("done");
        return accountRepository.findById(accountId)
                .orElseThrow(() -> new IllegalArgumentException("Account not found for ID: " + accountId));

    }

    public Customer addCustomer(String firstName, String lastName, String pesel,
                                String email, String phoneNumber, String street,
                                String city, String country) {
        customerRepository.addNewCustomer(firstName, lastName, pesel, email, phoneNumber,
                street, city, country);
        return customerRepository.findByPesel(pesel)
                .orElseThrow(() -> new IllegalArgumentException("Customer not found"));
    }


    public  List<String> getCustomerInfoById(Long id){
        String t = customerRepository.getCustomerInfoById(id);
        return List.of(t.split(","));
    }

    public String removeCustomerIfNegativeBalance(Long customerId) {
        customerRepository.removeCustomerIfNegativeBalance(customerId);
        Optional<Account> account = accountRepository.findByCustomerId(customerId);
        if(account.isEmpty()){
            return "Customer remove successful";
        }
        return "Customer has positive balance";

    }

}
