package net.javaguiedes.Banking_app.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Entity
@Table(name = "transactions")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Transaction {
    @Id
    private Long id;

    private Integer amount;

    @Column(length = 100)
    private String transactionType;

    @Column(nullable = false)
    private Date transactionDate;

    @ManyToOne
    @JoinColumn(name = "payment_card_id", nullable = false)
    private PaymentCard paymentCard;

}
