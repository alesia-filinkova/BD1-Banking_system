package net.javaguiedes.Banking_app.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
public class Currency {

    private Long accountId;
    private String newCurrency;
    private Double exchangeRate;
}
