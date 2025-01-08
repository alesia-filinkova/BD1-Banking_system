package net.javaguiedes.Banking_app.repository;

import net.javaguiedes.Banking_app.entity.Customer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

public interface CustomerRepository extends JpaRepository<Customer, Long> {

    @Procedure(name = "change_account_currency")
    void changeAccountCurrency(
            @Param("p_account_id") Long accountId,
            @Param("p_new_currency") String newCurrency,
            @Param("p_exchange_rate") Double exchangeRate
    );

    @Procedure(name = "add_new_customer")
    void addNewCustomer(
            @Param("p_first_name") String firstName,
            @Param("p_last_name") String lastName,
            @Param("p_pesel") String pesel,
            @Param("p_email") String email,
            @Param("p_phone_number") String phoneNumber,
            @Param("p_street") String street,
            @Param("p_city") String city,
            @Param("p_country") String country
    );

    Optional<Customer> findByPesel(String pesel);

    @Query(value = "SELECT first_name, last_name, pesel, email, phone_number, street, city, country FROM customers c LEFT JOIN addresses a on (c.address_id = a.id) WHERE c.id = :id", nativeQuery = true)
    String getCustomerInfoById(Long id);

    @Procedure(name = "remove_customer_if_negative_balance")
    void removeCustomerIfNegativeBalance(
            @Param("p_customer_id") Long customerId);

    Customer findByEmail(String email);

}
