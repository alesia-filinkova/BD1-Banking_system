
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


--create new customer + create new address if it doesn't exist
CREATE SEQUENCE addresses_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;

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


--set default value if balance is null
CREATE OR REPLACE TRIGGER set_default_balance
BEFORE INSERT ON accounts
FOR EACH ROW
BEGIN
    IF :NEW.balance IS NULL THEN
        :New.balance := 0;
    END IF;
END;


CREATE OR REPLACE FUNCTION has_active_card(p_account_id IN INTEGER)
RETURN BOOLEAN
AS
    v_card_id NUMBER;
BEGIN
    SELECT id
    INTO v_card_id
    FROM payment_cards
    WHERE account_id = p_account_id AND expiration_date > SYSDATE
    FETCH FIRST 1 ROW ONLY;
        RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN FALSE;
END;



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

