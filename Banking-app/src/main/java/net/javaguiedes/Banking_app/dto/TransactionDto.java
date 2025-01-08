package net.javaguiedes.Banking_app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.web.bind.annotation.RequestParam;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class TransactionDto {
    String paymentCard;
    Integer amount;
    String transactionType;
}
