package net.javaguiedes.Banking_app.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@NamedStoredProcedureQuery(
        name = "change_account_currency",
        procedureName = "change_account_currency",
        parameters = {
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_account_id", type = Long.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_new_currency", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_exchange_rate", type = Double.class)
        }
)
@NamedStoredProcedureQuery(
        name = "add_new_customer",
        procedureName = "add_new_customer",
        parameters = {
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_first_name", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_last_name", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_pesel", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_email", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_phone_number", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_street", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_city", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_country", type = String.class),

        }
)
@NamedStoredProcedureQuery(
        name = "remove_customer_if_negative_balance",
        procedureName = "remove_customer_if_negative_balance",
        parameters = {
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "p_customer_id", type = Long.class)
        }
)

@Table(name = "customers")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String firstName;

    @Column(nullable = false, length = 50)
    private String lastName;

    @Column(unique = true, length = 11)
    private String pesel;

    @Column(unique = true, length = 50)
    private String email;

    @Column(unique = true, length = 20)
    private String phoneNumber;

    @ManyToOne
    @JoinColumn(name = "address_id", nullable = false)
    private Address address;
}
