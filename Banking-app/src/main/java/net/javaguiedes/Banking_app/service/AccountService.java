package net.javaguiedes.Banking_app.service;

import net.javaguiedes.Banking_app.entity.Account;
import net.javaguiedes.Banking_app.entity.Customer;
import net.javaguiedes.Banking_app.repository.AccountRepository;
import net.javaguiedes.Banking_app.repository.CustomerRepository;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class AccountService {
    private final AccountRepository accountRepository;
    private final CustomerRepository customerRepository;

    public AccountService(AccountRepository accountRepository, CustomerRepository customerRepository) {
        this.accountRepository = accountRepository;
        this.customerRepository = customerRepository;
    }

    public Integer hasActiveCard(Long accountId) {
        return accountRepository.hasActiveCard(accountId);
    }

    public Integer getBalance(Long accountId) {
        return accountRepository.getBalance(accountId);
    }

    public Account createAccount(String accountNumber, Integer balance,
                                 String currency, Long customerId) {
        Customer cutomer = customerRepository.findById(customerId).get();
        Optional<Account> existingAccount = accountRepository.findByCustomerId(customerId);
        if(existingAccount.isPresent()) {
            return existingAccount.get();
        }
        Account account = new Account();
        account.setId(accountRepository.findMaxId()+1);
        account.setAccountNumber(accountNumber);
        account.setBalance(balance);
        account.setCurrency(currency);
        account.setCustomer(cutomer);
        return accountRepository.save(account);
    }
}
