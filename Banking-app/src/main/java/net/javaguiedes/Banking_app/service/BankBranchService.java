package net.javaguiedes.Banking_app.service;

import net.javaguiedes.Banking_app.repository.BankBranchRepository;
import org.springframework.stereotype.Service;

@Service
public class BankBranchService {
    private final BankBranchRepository bankBranchRepository;
    public BankBranchService(BankBranchRepository bankBranchRepository) {
        this.bankBranchRepository = bankBranchRepository;
    }

    public Double getBranchAvgSalary(Long branchId) {
        return bankBranchRepository.getBranchAverageSalary(branchId);
    }
}
