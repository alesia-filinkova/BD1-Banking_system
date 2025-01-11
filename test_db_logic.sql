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
/

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
/

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
/


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
/


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
/

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
/


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
/


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
/

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
/



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
/

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
/


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
/


-------Test set_transaction_date-------
DECLARE
    v_transaction_id NUMBER;
    v_transaction_date DATE;
BEGIN
    INSERT INTO transactions (id, amount, transaction_type, payment_card_id)
    VALUES (66, 100, 'Payment', 3002);

    SELECT transaction_date
    INTO v_transaction_date
    FROM transactions
    WHERE id = 66;

    --DBMS_OUTPUT.PUT_LINE('Today''s date (TRUNC(SYSDATE)): ' || TRUNC(SYSDATE));
    --DBMS_OUTPUT.PUT_LINE('Today''s date: ' || v_transaction_date);
    IF TRUNC(v_transaction_date) = TRUNC(SYSDATE) THEN
        DBMS_OUTPUT.PUT_LINE('Test passed');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test failed');
    END IF;

    DELETE FROM transactions WHERE id = 66;
    COMMIT;
END;
/


-------Test delete_related_transactions-------
DECLARE
    v_count_transactions_before NUMBER;
    v_count_transactions_after NUMBER;
BEGIN
    INSERT INTO payment_cards
    VALUES (3028, 2800333344445555, TO_DATE('2028-08-31', 'YYYY-MM-DD'), 208, 1001);
    
    INSERT INTO transactions (id, amount, transaction_type, payment_card_id)
    VALUES (70, 600, 'Deposit', 3028);
    
    INSERT INTO transactions (id, amount, transaction_type, payment_card_id)
    VALUES (71, 600, 'Deposit', 3028);

    SELECT COUNT(*) INTO v_count_transactions_before FROM transactions WHERE payment_card_id = 3028;
    DBMS_OUTPUT.PUT_LINE('Number of transactions before deleting card: ' || v_count_transactions_before);

    DELETE FROM payment_cards WHERE id = 3028;

    SELECT COUNT(*) INTO v_count_transactions_after FROM transactions WHERE payment_card_id = 3028;
    DBMS_OUTPUT.PUT_LINE('Number of transactions after deleting card: ' || v_count_transactions_after);

    IF v_count_transactions_after = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Test passed: Related transactions were successfully deleted.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test failed: Related transactions were not deleted.');
    END IF;

    COMMIT;
END;
/


-------Test delete_related_cards-------
DECLARE
    v_count_cards_before NUMBER;
    v_count_cards_after NUMBER;
BEGIN
    INSERT INTO accounts (id, account_number, currency, customer_id)
    VALUES (1050, 'ACC1050', 'PL', 2000);

    INSERT INTO payment_cards (id, card_number, expiration_date, cvv, account_id)
    VALUES (3028, '2800333344445555', TO_DATE('12-31-2030', 'MM-DD-YYYY'), '328', 1050);
    
    INSERT INTO payment_cards (id, card_number, expiration_date, cvv, account_id)
    VALUES (3029, '2900333344445555', TO_DATE('12-31-2030', 'MM-DD-YYYY'), '329', 1050);

    SELECT COUNT(*) INTO v_count_cards_before FROM payment_cards WHERE account_id = 1050;
    DBMS_OUTPUT.PUT_LINE('Number of cards before deleting account: ' || v_count_cards_before);

    DELETE FROM accounts WHERE id = 1050;

    SELECT COUNT(*) INTO v_count_cards_after FROM payment_cards WHERE account_id = 1050;
    DBMS_OUTPUT.PUT_LINE('Number of cards after deleting account: ' || v_count_cards_after);

    IF v_count_cards_after = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Test passed: Related cards were successfully deleted.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test failed: Related cards were not deleted.');
    END IF;

    --DELETE FROM payment_cards WHERE id IN (201, 202);
    --DELETE FROM accounts WHERE id = 101;
    COMMIT;
END;
/


-------Test delete_related_cards and delete_related_transactions-------
DECLARE
    v_count_cards_before NUMBER;
    v_count_cards_after NUMBER;
    v_count_transactions_before NUMBER;
    v_count_transactions_after NUMBER;
BEGIN
    INSERT INTO accounts (id, account_number, currency, customer_id)
    VALUES (1050, 'ACC1050', 'PL', 2000);

    INSERT INTO payment_cards (id, card_number, expiration_date, cvv, account_id)
    VALUES (3028, '2800333344445555', TO_DATE('12-31-2030', 'MM-DD-YYYY'), '328', 1050);
    
    INSERT INTO payment_cards (id, card_number, expiration_date, cvv, account_id)
    VALUES (3029, '2900333344445555', TO_DATE('12-31-2030', 'MM-DD-YYYY'), '329', 1050);
    
    INSERT INTO transactions (id, amount, transaction_type, payment_card_id)
    VALUES (70, 600, 'Deposit', 3028);
    
    INSERT INTO transactions (id, amount, transaction_type, payment_card_id)
    VALUES (71, 600, 'Deposit', 3028);

    SELECT COUNT(*) INTO v_count_transactions_before FROM transactions WHERE payment_card_id = 3028;
    DBMS_OUTPUT.PUT_LINE('Number of transactions before deleting card: ' || v_count_transactions_before);

    SELECT COUNT(*) INTO v_count_cards_before FROM payment_cards WHERE account_id = 1050;
    DBMS_OUTPUT.PUT_LINE('Number of cards before deleting account: ' || v_count_cards_before);

    DELETE FROM accounts WHERE id = 1050;

    SELECT COUNT(*) INTO v_count_cards_after FROM payment_cards WHERE account_id = 1050;
    DBMS_OUTPUT.PUT_LINE('Number of cards after deleting account: ' || v_count_cards_after);
    
    SELECT COUNT(*) INTO v_count_transactions_after FROM transactions WHERE payment_card_id = 3028;
    DBMS_OUTPUT.PUT_LINE('Number of transactions after deleting card: ' || v_count_transactions_after);

    IF v_count_cards_after = 0 AND v_count_transactions_after = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Test passed: Related cards and transactions were successfully deleted.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test failed: Related cards and transactions were not deleted.');
    END IF;

    COMMIT;
END;
/


-------Tests new_payment_card-------

---Payment card created sucsessfully---
DECLARE
    v_card_count_before NUMBER;
    v_card_count_after NUMBER;
    v_expiration_date DATE;
BEGIN
    INSERT INTO accounts (id, account_number, currency, customer_id)
    VALUES (1050, 'ACC1050', 'PL', 2000);
    COMMIT;

    SELECT COUNT(*) INTO v_card_count_before FROM payment_cards WHERE account_id = 1050;

    new_payment_card(1050);

    SELECT COUNT(*) INTO v_card_count_after FROM payment_cards WHERE account_id = 1050;

    IF v_card_count_after = v_card_count_before + 1 THEN
        DBMS_OUTPUT.PUT_LINE('Test 1 passed: New card created successfully.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test 1 failed: New card not created.');
    END IF;

    SELECT expiration_date INTO v_expiration_date 
    FROM payment_cards 
    WHERE account_id = 1050;

    IF TRUNC(v_expiration_date) = ADD_MONTHS(TRUNC(SYSDATE), 60) THEN
        DBMS_OUTPUT.PUT_LINE('Test 2 passed: Expiration date is correct.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test 2 failed: Expiration date is incorrect.');
    END IF;

    DELETE FROM payment_cards WHERE account_id = 1050;
    DELETE FROM accounts WHERE id = 1050;
    COMMIT;
END;
/

---no_data_found error call---
BEGIN
    -- no such account exists
    BEGIN
        new_payment_card(999);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 3 passed: Exception handled correctly - ' || SQLERRM);
    END;
END;
/

---other error call---
BEGIN
    BEGIN
        new_payment_card(NULL);
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 4 passed: Exception handled correctly - ' || SQLERRM);
    END;
END;
/


-------Tests get_transaction_history-------

---Test history exist---
DECLARE
    v_history SYS_REFCURSOR;
    v_id NUMBER;
    v_amount NUMBER;
    v_transaction_type VARCHAR2(50);
    v_transaction_date DATE;
BEGIN
    v_history := get_transaction_history(3001);

    LOOP
        FETCH v_history INTO v_id, v_amount, v_transaction_type, v_transaction_date;
        EXIT WHEN v_history%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('ID: ' || v_id || ', Amount: ' || v_amount || 
                             ', Type: ' || v_transaction_type || 
                             ', Date: ' || TO_CHAR(v_transaction_date, 'YYYY-MM-DD'));
    END LOOP;
    CLOSE v_history;
END;
/

---Test raise no such card id error---
DECLARE
    v_history SYS_REFCURSOR;
    v_id NUMBER;
    v_amount NUMBER;
    v_transaction_type VARCHAR2(50);
    v_transaction_date DATE;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 2: Checking transaction history for non-existent card');
    v_history := get_transaction_history(1); -- Non-existent card ID
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            IF v_history IS NOT NULL THEN
                CLOSE v_history;
            END IF;
END;
/


-------Test get_transaction_count-------
---Test count transactions sucsessfully---
DECLARE
    v_transaction_count NUMBER;
BEGIN
    -- Test 1: Check transaction count for an existing account with transactions
    DBMS_OUTPUT.PUT_LINE('Test 1: Transaction count for an account with transactions');
    v_transaction_count := get_transaction_count(1001); -- Assuming account_id 1001 exists with transactions

    IF v_transaction_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Test 1 passed: Transaction count = ' || v_transaction_count);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test 1 failed: No transactions found for the account.');
    END IF;

    -- Test 3: Check transaction count for an account with multiple transactions
    DBMS_OUTPUT.PUT_LINE('Test 3: Transaction count for an account with multiple transactions');
    v_transaction_count := get_transaction_count(1003); -- Assuming account_id 1003 exists with multiple transactions

    IF v_transaction_count > 1 THEN
        DBMS_OUTPUT.PUT_LINE('Test 3 passed: Transaction count = ' || v_transaction_count);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Test 3 failed: Incorrect transaction count for the account.');
    END IF;
END;
/

---Test no such account id error---
DECLARE
    v_transaction_count NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 2: Transaction count for a non-existent account');
    BEGIN
        v_transaction_count := get_transaction_count(0); -- Non-existent account
        DBMS_OUTPUT.PUT_LINE('Test 2 failed: No error raised for non-existent account.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 2 passed: Error occurred as expected - ' || SQLERRM);
    END;
END;
/


-------Tests assign_employee-------
---Test 1: Check for successfully adding a new employee
DECLARE
    v_employee_id NUMBER;
    v_first_name VARCHAR2(50);
    v_last_name VARCHAR2(50);
    v_salary NUMBER;
    v_branch_id NUMBER;
    v_position_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 1: Add a new employee');
    v_first_name := 'James';
    v_last_name := 'Dr';

    BEGIN
        assign_employee(v_first_name, v_last_name);
        SELECT id INTO v_employee_id 
        FROM employees 
        WHERE first_name = v_first_name AND last_name = v_last_name;
        DBMS_OUTPUT.PUT_LINE('Test 1 passed: Employee added successfully');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 1 failed: ' || SQLERRM);
    END;
    DELETE FROM employee_positions WHERE employee_id = v_employee_id;
    DELETE FROM employee_bankbranch WHERE employee_id = v_employee_id;
    DELETE FROM employees WHERE id = v_employee_id;
END;
/

---Test 2: Attempt to add an employee with a duplicate first and last name
DECLARE
    v_employee_id NUMBER;
    v_first_name VARCHAR2(50);
    v_last_name VARCHAR2(50);
    v_salary NUMBER;
    v_branch_id NUMBER;
    v_position_id NUMBER;
BEGIN
    v_first_name := 'Anna';
    v_last_name := 'Evans';
    DBMS_OUTPUT.PUT_LINE('Test 2: Add an employee with duplicate name');
    BEGIN
        assign_employee(v_first_name, v_last_name); -- Same name as the previous one
        DBMS_OUTPUT.PUT_LINE('Test 2 failed: No error for duplicate employee name');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 2 passed: ' || SQLERRM);
    END;
END;
/

---Test 3: Check if the employee is assigned to the branch with the least employees
DECLARE
    v_employee_id NUMBER;
    v_first_name VARCHAR2(50);
    v_last_name VARCHAR2(50);
    v_salary NUMBER;
    v_branch_id NUMBER;
    v_least_employee_branch_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 3: Check branch assignment');
    
    SELECT bankbranch_id
    INTO v_least_employee_branch_id
    FROM (
        SELECT bankbranch_id, COUNT(*) AS employee_count
        FROM employee_bankbranch
        GROUP BY bankbranch_id
        ORDER BY employee_count ASC
    ) WHERE ROWNUM = 1;

    v_first_name := 'J';
    v_last_name := 'S';

    BEGIN
        assign_employee(v_first_name, v_last_name);

        SELECT id INTO v_employee_id 
        FROM employees 
        WHERE first_name = v_first_name AND last_name = v_last_name;

        SELECT bankbranch_id 
        INTO v_branch_id 
        FROM employee_bankbranch 
        WHERE employee_id = v_employee_id;

        IF v_branch_id = v_least_employee_branch_id THEN
            DBMS_OUTPUT.PUT_LINE('Test 3 passed: Employee assigned to branch with least employees');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Test 3 failed: Incorrect branch assignment');
        END IF;

        DELETE FROM employee_positions WHERE employee_id = v_employee_id;
        DELETE FROM employee_bankbranch WHERE employee_id = v_employee_id;
        DELETE FROM employees WHERE id = v_employee_id;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 3 failed: ' || SQLERRM);
    END;
END;
/

---Test 4: Check if the employee is assigned to the position with the least employees
DECLARE
    v_employee_id NUMBER;
    v_first_name VARCHAR2(50);
    v_last_name VARCHAR2(50);
    v_branch_id NUMBER;
    v_position_id NUMBER;
    v_least_employee_position_id NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Test 4: Check position assignment');
    SELECT bankbranch_id
    INTO v_branch_id
    FROM (
        SELECT bankbranch_id, COUNT(*) AS employee_count
        FROM employee_bankbranch
        GROUP BY bankbranch_id
        ORDER BY employee_count ASC
    ) WHERE ROWNUM = 1;

    SELECT positions_id
    INTO v_least_employee_position_id
    FROM (
        SELECT ep.positions_id, COUNT(ep.employee_id) AS employee_count
        FROM employee_positions ep
        INNER JOIN employee_bankbranch eb ON ep.employee_id = eb.employee_id
        WHERE eb.bankbranch_id = v_branch_id
        GROUP BY ep.positions_id
        ORDER BY employee_count ASC
    ) WHERE ROWNUM = 1;

    v_first_name := 'A';
    v_last_name := 'J';

    BEGIN
        assign_employee(v_first_name, v_last_name);

        SELECT id INTO v_employee_id 
        FROM employees 
        WHERE first_name = v_first_name AND last_name = v_last_name;

        SELECT positions_id 
        INTO v_position_id 
        FROM employee_positions 
        WHERE employee_id = v_employee_id;

        IF v_position_id = v_least_employee_position_id THEN
            DBMS_OUTPUT.PUT_LINE('Test 4 passed: Employee assigned to position with least employees');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Test 4 failed: Incorrect position assignment');
        END IF;

        DELETE FROM employee_positions WHERE employee_id = v_employee_id;
        DELETE FROM employee_bankbranch WHERE employee_id = v_employee_id;
        DELETE FROM employees WHERE id = v_employee_id;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Test 4 failed: ' || SQLERRM);
    END;
END;
/