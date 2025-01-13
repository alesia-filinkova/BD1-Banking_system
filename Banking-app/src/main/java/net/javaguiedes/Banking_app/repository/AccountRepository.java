package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.Account;
import net.javaguiedes.Banking_app.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.Optional;
import java.util.List;

public interface AccountRepository extends JpaRepository<Account, Long> {

    @Query(value = "SELECT has_active_card(:accountId) FROM DUAL", nativeQuery = true)
    Integer hasActiveCard(@Param("accountId") Long accountId);

    Optional<Account> findByCustomerId(Long customer);

    @Query(value="SELECT balance FROM accounts WHERE customer_id = :customerId", nativeQuery = true)
    Integer getBalance(Long customerId);

    @Query("SELECT MAX(a.id) FROM Account a")
    Long findMaxId();

    @Procedure(procedureName = "new_payment_card")
    void createNewPaymentCard(@Param("p_account_id") Long accountId);
}
