
--change balance after transaction
CREATE OR REPLACE TRIGGER update_account_balance
AFTER INSERT ON transactions
FOR EACH ROW
DECLARE
    v_balance_change INTEGER;
    v_account_id INTEGER;
BEGIN

        CASE :NEW.transaction_type
                WHEN 'Deposit' THEN
                    v_balance_change := :NEW.amount;
        WHEN 'Refund' THEN
                    v_balance_change := :NEW.amount;
        WHEN 'Tax Refund' THEN
                    v_balance_change := :NEW.amount;
        WHEN 'Withdrawal' THEN
                    v_balance_change := -:NEW.amount;
        WHEN 'Payment' THEN
                    v_balance_change := -:NEW.amount;
        WHEN 'Purchase' THEN
                    v_balance_change := -:NEW.amount;
        WHEN 'Tax Payments' THEN
                    v_balance_change := -:NEW.amount;
        WHEN 'Bill Payment' THEN
                    v_balance_change := -:NEW.amount;
        WHEN 'Transfer' THEN
                    v_balance_change := :NEW.amount; -- assume that the balance changes for incoming transfers
        ELSE
                    RAISE_APPLICATION_ERROR(-20001, 'Unsupported transaction type');
        END CASE;

        SELECT account_id INTO v_account_id
        FROM payment_cards
        WHERE id = :NEW.payment_card_id;

        UPDATE accounts
        SET balance = balance + v_balance_change
        WHERE  id = v_account_id;
END;
/

--change currency
CREATE or REPLACE PROCEDURE change_account_currency(
    p_account_id IN accounts.id%TYPE,
    p_new_currency IN accounts.currency%TYPE,
    p_exchange_rate IN NUMBER
) AS
    v_current_currency accounts.currency%TYPE;
    v_current_balance accounts.balance%TYPE;
BEGIN
    SELECT currency, balance
    INTO v_current_currency, v_current_balance
    FROM accounts
    WHERE id = p_account_id;

    IF v_current_currency != p_new_currency THEN
        UPDATE accounts
        SET balance = ROUND(v_current_balance * p_exchange_rate),
            currency = p_new_currency
        WHERE id = p_account_id;
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'The account with ID does not exist.');
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'An error occurred: ' || SQLERRM);
END;
/


--return average salary per bank branch
CREATE OR REPLACE FUNCTION get_avg_salary(p_branch_id IN INTEGER)
RETURN NUMBER
AS
    v_avg_salary NUMBER;
BEGIN
    SELECT AVG(salary)
    INTO v_avg_salary
    FROM employees e
             JOIN employee_bankbranch eb ON e.id = eb.employee_id
    WHERE eb.bankbranch_id = p_branch_id;

RETURN NVL(v_avg_salary, 0);
END;
/


--create new customer + create new address if it doesn't exist
CREATE SEQUENCE addresses_seq START WITH 200 INCREMENT BY 1;
CREATE SEQUENCE customer_seq START WITH 2000 INCREMENT BY 1;

CREATE OR REPLACE PROCEDURE add_new_customer (
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2,
    p_pesel IN VARCHAR2,
    p_email IN VARCHAR2,
    p_phone_number IN VARCHAR2,
    p_street IN VARCHAR2,
    p_city IN VARCHAR2,
    p_country IN VARCHAR2
)
AS
    v_address_id INTEGER;
BEGIN
BEGIN
    SELECT id INTO v_address_id
    FROM addresses
    WHERE street = p_street AND city = p_city AND country = p_country
    FETCH FIRST 1 ROWS ONLY;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO addresses
            VALUES (addresses_seq.NEXTVAL, p_street, p_city, p_country)
            RETURNING id INTO v_address_id;
        END;

    INSERT INTO customers
    VALUES (customer_seq.NEXTVAL, p_first_name, p_last_name, p_pesel, p_email, p_phone_number, v_address_id);
END;
/


--set default value if balance is null
CREATE OR REPLACE TRIGGER set_default_balance
BEFORE INSERT ON accounts
FOR EACH ROW
BEGIN
    IF :NEW.balance IS NULL THEN
        :New.balance := 0;
    END IF;
END;
/


CREATE OR REPLACE FUNCTION has_active_card(p_account_id IN INTEGER)
RETURN INTEGER
AS
    v_card_id NUMBER;
BEGIN
    SELECT id
    INTO v_card_id
    FROM payment_cards
    WHERE account_id = p_account_id AND expiration_date > SYSDATE
    FETCH FIRST 1 ROW ONLY;
        RETURN 1;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
END;
/



--remove customer with negative balance
CREATE OR REPLACE PROCEDURE remove_customer_if_negative_balance(p_customer_id IN INTEGER)
AS
    v_balance INTEGER;
BEGIN
    SELECT balance
    INTO v_balance
    FROM accounts
    WHERE customer_id = p_customer_id;
    IF v_balance < 0 THEN
        DELETE FROM accounts
        WHERE customer_id = p_customer_id;
        COMMIT;
    END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'The account with ID does not exist.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/


--Automatyczne ustawianie daty utworzenia transakcji
CREATE OR REPLACE TRIGGER set_transaction_date
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN 
    :NEW.transaction_date := SYSDATE;
END;
/


--Usunięcie karty konsumenta (Przy usunięciu karty, wszystkie związane z nią transakcje są również usuwane.)
CREATE OR REPLACE TRIGGER delete_related_transactions
BEFORE DELETE ON payment_cards
FOR EACH ROW
BEGIN
    DELETE FROM transactions WHERE payment_card_id = :OLD.id;
END;
/


--Usunięcie konta konsumenta (Przy usunięciu konta, wszystkie związane z nim karty są również usuwane.)
CREATE OR REPLACE TRIGGER delete_related_cards
BEFORE DELETE ON accounts
FOR EACH ROW
BEGIN
    DELETE FROM payment_cards WHERE account_id = :OLD.id;
END;
/


--Obsługa zamówienia nowej karty płatniczej(Procedura generuje nową kartę płatniczą dla konta klienta)
CREATE OR REPLACE PROCEDURE new_payment_card(p_account_id IN NUMBER)
AS 
    v_card_id NUMBER;
    v_card_number VARCHAR2(50);
    v_expiration_date DATE;
    v_cvv VARCHAR2(3);
BEGIN
    SELECT MAX(id) + 1 INTO v_card_id
    FROM payment_cards;
    v_expiration_date := ADD_MONTHS(SYSDATE, 60);
    v_card_number := LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 9999999999999999)), 16, '0');
    v_cvv := LPAD(TRUNC(DBMS_RANDOM.VALUE(1, 999)), 3, '0');
    INSERT INTO payment_cards (id, card_number, expiration_date, cvv, account_id) 
    VALUES(
        v_card_id,
        v_card_number,
        v_expiration_date,
        v_cvv,
        p_account_id  
    );
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20002, 'The account with ID does not exist.');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/


--Dodanie pracownika 
-- + Automatyczne przypisanie pracownika do oddziału z najmniejszą liczbą pracowników
-- +przypisanie do posycji z najmniejszą liczbą pracowników
-- + nadanie najmniejszego zakładu dla tej pozycji
CREATE OR REPLACE PROCEDURE assign_employee 
(
    p_first_name IN VARCHAR2,
    p_last_name IN VARCHAR2
)
AS 
    v_employee_id NUMBER;
    v_branch_id NUMBER;
    v_position_id NUMBER;
    v_salary NUMBER;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM employees
    WHERE LOWER(first_name) = LOWER(p_first_name)
    AND LOWER(last_name) = LOWER(p_last_name);

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Employee with such first name and last name already exists');
    END IF;
    SELECT bankbranch_id
    INTO v_branch_id
    FROM(
        SELECT bankbranch_id, COUNT(*) AS employee_count
        FROM employee_bankbranch
        GROUP BY bankbranch_id
        ORDER BY employee_count ASC
    ) WHERE ROWNUM = 1;
    
    SELECT positions_id
    INTO v_position_id
    FROM (
        SELECT ep.positions_id, COUNT(ep.employee_id) AS employee_count
        FROM employee_positions ep
        INNER JOIN employee_bankbranch eb ON ep.employee_id = eb.employee_id
        WHERE eb.bankbranch_id = v_branch_id
        GROUP BY ep.positions_id
        ORDER BY employee_count ASC
    ) WHERE ROWNUM = 1;
    
    SELECT MIN(salary)
    INTO v_salary
    FROM employees e
    INNER JOIN employee_positions ep ON e.id = ep.employee_id
    WHERE ep.positions_id = v_position_id;
    
    SELECT MAX(id) + 1 INTO v_employee_id FROM employees;
    
    INSERT INTO employees (id, first_name, last_name, salary)
    VALUES (
        v_employee_id,
        p_first_name,
        p_last_name,
        v_salary
    );
    
    INSERT INTO employee_bankbranch (employee_id, bankbranch_id)
    VALUES (v_employee_id, v_branch_id);
    
    INSERT INTO employee_positions (employee_id, positions_id)
    VALUES (v_employee_id, v_position_id);
    
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20005, 'No available bank_branch or position');
        WHEN OTHERS THEN
            RAISE_APPLICATION_ERROR(-20003, 'An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/


--Sprawdzanie historii transakcji karty
CREATE OR REPLACE FUNCTION get_transaction_history (p_payment_card_id IN NUMBER)
RETURN SYS_REFCURSOR IS
    v_history SYS_REFCURSOR;
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM payment_cards
    WHERE id = p_payment_card_id;

    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Payment card does not exist.');
    END IF;
    OPEN v_history FOR
    SELECT id, amount, transaction_type, transaction_date
    FROM transactions
    WHERE payment_card_id = p_payment_card_id
    ORDER BY transaction_date DESC;

    RETURN v_history;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20003, 'An error occurred: ' || SQLERRM);
END;
/


--Obliczanie liczby transakcji na koncie
CREATE OR REPLACE FUNCTION get_transaction_count (p_account_id IN NUMBER)
RETURN NUMBER IS
    v_transaction_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_transaction_count
    FROM transactions t
    JOIN payment_cards pc
    ON t.payment_card_id = pc.id
    WHERE pc.account_id = p_account_id;
    RETURN v_transaction_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'The account with ID does not exist.');
        RETURN 0;
END;
/
