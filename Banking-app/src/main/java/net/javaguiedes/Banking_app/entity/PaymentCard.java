package net.javaguiedes.Banking_app.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "paymentCards")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PaymentCard {

    @Id
    private Long id;

    @Column(nullable = false, length = 50, unique = true)
    private String cardNumber;

    @Column(nullable = false)
    private Date expirationDate;

    @Column(nullable = false, length = 3)
    private String cvv;

    @ManyToOne
    @JoinColumn(name = "account_id", nullable = false)
    private Account account;
}
