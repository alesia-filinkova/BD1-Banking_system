package net.javaguiedes.Banking_app.service;

import net.javaguiedes.Banking_app.entity.PaymentCard;
import net.javaguiedes.Banking_app.entity.Transaction;
import net.javaguiedes.Banking_app.repository.PaymentCardRepository;
import net.javaguiedes.Banking_app.repository.TransactionRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class TransactionService {
    private final TransactionRepository transactionRepository;
    private final PaymentCardRepository paymentCardRepository;
    public TransactionService(TransactionRepository transactionRepository, PaymentCardRepository paymentCardRepository) {
        this.transactionRepository = transactionRepository;
        this.paymentCardRepository = paymentCardRepository;
    }

    public Transaction createTransaction(Long paymentCardId, Integer amount, String transactionType) {
        PaymentCard paymentCard = paymentCardRepository.findById(paymentCardId)
                .orElseThrow(() -> new IllegalArgumentException("Payment card not found for ID: " + paymentCardId));

        Transaction transaction = new Transaction();
        transaction.setId(transactionRepository.findMaxId()+1);
        transaction.setAmount(amount);
        transaction.setTransactionType(transactionType);
        transaction.setTransactionDate(LocalDate.now());
        transaction.setPaymentCard(paymentCard);

        return transactionRepository.save(transaction); // use trigger update_account_balance
    }

    public List<Transaction> getAllTransactions() {
        List<Long> transactionsId = transactionRepository.getTransactionsLast30Days();
        List<Transaction> transactions = new ArrayList<>();
        transactionsId.forEach(e->transactions.add(transactionRepository
                .findById(e).orElseThrow(() -> new IllegalArgumentException("Transaction not found for ID: " + e))));
        return transactions;
    }

    public PaymentCard findByCardNumber(String cardNumber) {
        return paymentCardRepository.findByCardNumber(cardNumber);
    }

}
