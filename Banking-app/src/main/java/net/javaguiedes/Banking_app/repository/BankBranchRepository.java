package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.Account;
import net.javaguiedes.Banking_app.entity.BankBranch;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface BankBranchRepository extends JpaRepository<BankBranch, Long> {

    @Query(value = "SELECT get_avg_salary(:branchId) FROM DUAL", nativeQuery = true)
    Double getBranchAverageSalary(
            @Param("branchId") Long branchId
    );
}
