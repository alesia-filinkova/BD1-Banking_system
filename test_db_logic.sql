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