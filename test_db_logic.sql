SET SERVEROUTPUT ON;

--------------Test change_account_currency ----------------

BEGIN
        UPDATE accounts SET balance = 10000, currency = 'USD' WHERE id = 1001;
        commit;

        change_account_currency(1001, 'EUR', 0.85);

    DECLARE
        v_new_currency accounts.currency%TYPE;
        v_new_balance accounts.balance%TYPE;
    BEGIN
        SELECT currency, balance INTO v_new_currency, v_new_balance
        FROM accounts
        WHERE id = 1001;

        IF v_new_currency = 'EUR' AND v_new_balance = ROUND(10000 * 0.85) THEN
                    DBMS_OUTPUT.PUT_LINE('Test passed');
        ELSE
                    DBMS_OUTPUT.PUT_LINE('Test failed');
        END IF;
    END;
END;

--try to change to the same currency
BEGIN
        UPDATE accounts SET balance = 10000, currency = 'USD' WHERE id = 1001;
        change_account_currency(1001, 'USD', 1.0);

    DECLARE
        v_current_currency accounts.currency%TYPE;
        v_current_balance accounts.balance%TYPE;
    BEGIN
        SELECT currency, balance INTO v_current_currency, v_current_balance
        FROM accounts
        WHERE id = 1001;

        IF v_current_currency = 'USD' AND v_current_balance = 10000 THEN
                    DBMS_OUTPUT.PUT_LINE('Test passed');
        ELSE
                    DBMS_OUTPUT.PUT_LINE('Test failed');
        END IF;
    END;
END;

--customer does not exist
BEGIN
            change_account_currency(9999, 'EUR', 0.85);
    EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE = -20002 THEN
                    DBMS_OUTPUT.PUT_LINE('Test passed');
    ELSE
                    DBMS_OUTPUT.PUT_LINE('Test failed');
    END IF;
END;


---------------Test get_avg_salary-------------

DECLARE
v_result NUMBER;
BEGIN
    v_result := get_avg_salary(101);

    IF ROUND(v_result) = 2814 THEN
        DBMS_OUTPUT.PUT_LINE('Test passed');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test failed');
    END IF;
END;


--bank branch does not exist
DECLARE
v_result NUMBER;
    BEGIN
        v_result := get_avg_salary(3);

        IF v_result = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Test passed');
    ELSE
            DBMS_OUTPUT.PUT_LINE('Test failed');
    END IF;
END;

-----------------Test set_default_balance-----

BEGIN
    DELETE accounts WHERE id = 1;
    INSERT INTO accounts
    VALUES (1, 'Number', NULL,'USD', 1001);
    DECLARE
    v_balance NUMBER;
    BEGIN
        SELECT balance
        INTO v_balance
        FROM accounts
        WHERE id = 1;

        IF v_balance = 0 THEN
            DBMS_OUTPUT.PUT_LINE('Test passed: balance set to default value 0.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Test failed: balance not set to 0.');
        END IF;
    END;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test failed: ' || SQLERRM);
END;


------------------Test has_active_card----
DECLARE
v_result BOOLEAN;
BEGIN
    DELETE FROM payment_cards WHERE id = 1;
    INSERT INTO payment_cards
    VALUES (1, '23212131434', SYSDATE + 30, '234', 1001);

    v_result := has_active_card(1001);

    IF v_result = TRUE THEN
        DBMS_OUTPUT.PUT_LINE('Test passed: Account has an active card.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test failed: Account does not have an active card.');
    END IF;
    DELETE FROM payment_cards WHERE id = 1;
END;


-----------------Test  remove_customer_if_negative_balance---

DECLARE
v_balance NUMBER;
BEGIN
    DELETE FROM accounts WHERE id = 2;
    DELETE FROM customers WHERE id = 5;

    INSERT INTO customers
    VALUES (5, 'John22','Doe22', '12345678962', 'john.doe2@example.com', '555-12634', 101);

    INSERT INTO accounts
    VALUES (2, 'AA11', -100, 'USD', 5);

    remove_customer_if_negative_balance(5);
    BEGIN
        SELECT balance INTO v_balance
        FROM accounts
        WHERE id = 2;
        DBMS_OUTPUT.PUT_LINE('Test failed: Customer not removed.');
    EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Test passed: Customer successfully removed.');
    END;

    DELETE FROM accounts WHERE id = 2;
    DELETE FROM customers WHERE id = 5;
END;

---account does not exist

BEGIN
        remove_customer_if_negative_balance(9999);
        DBMS_OUTPUT.PUT_LINE('Test failed: No exception for non-existing customer.');
EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20002 THEN
                DBMS_OUTPUT.PUT_LINE('Test passed: Exception raised for non-existing customer.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Test failed: Unexpected error code: ' || SQLCODE);
            END IF;
END;



------------ TEST trigger update_account_balance
--deposit
BEGIN
    INSERT INTO accounts VALUES(2,'AAC22', 200, 'USD', 1001);
    INSERT INTO payment_cards VALUES(1, '2341124332',  SYSDATE + 30, '234', 2);
    INSERT INTO transactions VALUES (1, 100, 'Deposit', SYSDATE, 1);
    DECLARE
    v_new_balance NUMBER;
    BEGIN
        SELECT balance INTO v_new_balance
        FROM accounts
        WHERE id = 2;

        IF v_new_balance = 300 THEN
                    DBMS_OUTPUT.PUT_LINE('Test passed: Deposit correctly updated the balance.');
        ELSE
                    DBMS_OUTPUT.PUT_LINE('Test failed: Deposit did not update the balance correctly.');
        END IF;
    END;

    DELETE FROM transactions WHERE id = 1;
    DELETE FROM payment_cards WHERE id = 1;
    DELETE FROM accounts WHERE id = 2;
END;

--payments
BEGIN
    INSERT INTO accounts VALUES(2,'AAC22', 200, 'USD', 1001);
    INSERT INTO payment_cards VALUES(1, '2341124332',  SYSDATE + 30, '234', 2);
    INSERT INTO transactions VALUES (1, 100, 'Payment', SYSDATE, 1);

    DECLARE
    v_new_balance NUMBER;
    BEGIN
        SELECT balance INTO v_new_balance
        FROM accounts
        WHERE id = 2;

        IF v_new_balance = 100 THEN
                    DBMS_OUTPUT.PUT_LINE('Test passed: Payment correctly updated the balance.');
        ELSE
                    DBMS_OUTPUT.PUT_LINE('Test failed: Payment did not update the balance correctly.');
        END IF;
    END;

    DELETE FROM transactions WHERE id = 1;
    DELETE FROM payment_cards WHERE id = 1;
    DELETE FROM accounts WHERE id = 2;
END;


--------------------Test add_new_customer---
DECLARE
    v_customer_id INTEGER;
    v_address_id INTEGER;
BEGIN

        add_new_customer('Name', 'Last Name', '23891740997', 'name@gmail.com', '6789709032', 'Street', 'city', 'country');

        BEGIN
        SELECT id INTO v_customer_id
        FROM customers
        WHERE pesel = '23891740997';

        SELECT address_id INTO v_address_id
        FROM customers
        WHERE id = v_customer_id;

            IF v_customer_id IS NOT NULL AND v_address_id IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('Test passed: Customer added with new address.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('Test failed: Customer or address not found.');
            END IF;
        END;
        DELETE FROM customers WHERE pesel = '23891740997';
        DELETE FROM addresses WHERE street = 'Street' and country = 'country' and city = 'city';
        COMMIT;
END;
