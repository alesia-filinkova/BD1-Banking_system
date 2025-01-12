package net.javaguiedes.Banking_app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.bind.annotation.RequestParam;
import java.util.Date;

@Setter
@Getter
@NoArgsConstructor
public class TransactionDto {
    Long id;
    String paymentCard;
    Integer amount;
    String transactionType;
    Date transactionDate;

    public TransactionDto(Long id, Integer amount, String transactionType, Date transactionDate) {
        this.id = id;
        this.amount = amount;
        this.transactionType = transactionType;
        this.transactionDate = transactionDate;
    }
}
