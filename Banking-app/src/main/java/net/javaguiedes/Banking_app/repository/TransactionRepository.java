package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.Employee;
import net.javaguiedes.Banking_app.entity.Transaction;
import org.springframework.data.annotation.Id;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import net.javaguiedes.Banking_app.entity.Account;

import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {

    @Query("SELECT MAX(t.id) FROM Transaction t")
    Long findMaxId();

    @Query(value = "SELECT id FROM TRANSACTIONS WHERE transaction_date+30 >= SYSDATE", nativeQuery = true)
    List<Long> getTransactionsLast30Days();

    @Query(value = "SELECT get_transaction_count(:accountId) FROM DUAL", nativeQuery = true)
    Integer getTransactionCount(@Param("accountId") Long accountId);
}
