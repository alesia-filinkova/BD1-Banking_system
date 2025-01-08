package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.PaymentCard;
import net.javaguiedes.Banking_app.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentCardRepository extends JpaRepository<PaymentCard, Long> {
    PaymentCard findByCardNumber(String cardNumber);
}
