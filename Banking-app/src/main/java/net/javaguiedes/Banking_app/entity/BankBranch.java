package net.javaguiedes.Banking_app.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Set;

@Entity
@Table(name = "bankBranches")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class BankBranch {

    @Id
    private Long id;

    @Column(nullable = false, length = 100, unique = true)
    private String branchName;

    @Column(unique = true, length = 20)
    private String phoneNumber;

    @ManyToMany(mappedBy = "bankBranches")
    private Set<Employee> employees;

    @OneToOne
    @JoinColumn(name = "address_id", nullable = false)
    private Address address;
}
