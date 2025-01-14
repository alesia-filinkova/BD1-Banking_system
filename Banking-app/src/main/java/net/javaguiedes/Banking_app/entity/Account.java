package net.javaguiedes.Banking_app.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Entity
@NamedStoredProcedureQuery(
        name = "new_payment_card",
        procedureName = "new_payment_card",
        parameters = {
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_account_id", type = Long.class)
        }
)

@Table(name = "accounts")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Account {

    @Id
    private Long id;

    @Column(unique = true, nullable = false, length = 50)
    private String accountNumber;

    private Integer balance;

    @Column(nullable = false, length = 50)
    private String currency;

    @ManyToOne
    @JoinColumn(name = "customer_id", nullable = false)
    private Customer customer;
}
