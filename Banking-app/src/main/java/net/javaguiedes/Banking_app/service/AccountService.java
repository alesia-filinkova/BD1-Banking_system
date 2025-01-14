package net.javaguiedes.Banking_app.service;

import net.javaguiedes.Banking_app.entity.Account;
import net.javaguiedes.Banking_app.entity.Customer;
import net.javaguiedes.Banking_app.entity.PaymentCard;
import net.javaguiedes.Banking_app.repository.AccountRepository;
import net.javaguiedes.Banking_app.repository.CustomerRepository;
import net.javaguiedes.Banking_app.repository.PaymentCardRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
public class AccountService {
    private final AccountRepository accountRepository;
    private final CustomerRepository customerRepository;
    private final PaymentCardRepository paymentCardRepository;

    public AccountService(AccountRepository accountRepository, CustomerRepository customerRepository, PaymentCardRepository paymentCardRepository) {
        this.accountRepository = accountRepository;
        this.customerRepository = customerRepository;
        this.paymentCardRepository = paymentCardRepository;
    }

    public Integer hasActiveCard(Long accountId) {
        return accountRepository.hasActiveCard(accountId);
    }

    public Integer getBalance(Long accountId) {
        System.out.println("________");
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

    public PaymentCard getLastPaymentCard(Long accountId) {
        return paymentCardRepository.findTopByAccountIdOrderByIdDesc(accountId);
    }

    public String createNewPaymentCard(Long accountId) {
        accountRepository.createNewPaymentCard(accountId);
        return "Card was successfully created";
    }
}
