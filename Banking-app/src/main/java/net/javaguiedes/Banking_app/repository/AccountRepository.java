package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.Account;
import net.javaguiedes.Banking_app.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.Optional;

public interface AccountRepository extends JpaRepository<Account, Long> {

    @Query(value = "SELECT has_active_card(:accountId) FROM DUAL", nativeQuery = true)
    Integer hasActiveCard(@Param("accountId") Long accountId);

    Optional<Account> findByCustomerId(Long customer);

    @Query(value="SELECT balance FROM accounts WHERE customer_id = :customerId", nativeQuery = true)
    Integer getBalance(Long customerId);

    @Query("SELECT MAX(a.id) FROM Account a")
    Long findMaxId();

    @Query(value = "{call new_payment_card(:accountId)}", nativeQuery = true)
    void createNewPaymentCard(@Param("accountId") Long accountId);
}
