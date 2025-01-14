package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.PaymentCard;
import net.javaguiedes.Banking_app.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PaymentCardRepository extends JpaRepository<PaymentCard, Long> {
    PaymentCard findByCardNumber(String cardNumber);

    PaymentCard findTopByAccountIdOrderByIdDesc(Long accountId);
}
