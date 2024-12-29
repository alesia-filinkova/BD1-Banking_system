--Test connection between customers, their accounts, and their addresses
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       a.account_number, a.balance, ad.city || ', ' || ad.country AS address
FROM customers c
       JOIN accounts a ON c.id = a.customer_id
       JOIN addresses ad ON c.address_id = ad.id;


--Test bank branches with the highest number of employee
SELECT bb.branch_name,
    (SELECT COUNT(*) FROM employee_bankbranch eb
     WHERE eb.bankbranch_id = bb.id) AS employee_count
FROM bank_branches bb
WHERE (SELECT COUNT(*)
       FROM employee_bankbranch eb
       WHERE eb.bankbranch_id = bb.id) = (SELECT MAX((SELECT COUNT(*)
                                                      FROM employee_bankbranch eb2
                                                      WHERE eb2.bankbranch_id = bb2.id))
                                                      FROM bank_branches bb2);


--Test: Customers who have more than one card
SELECT account_id, c.first_name, c.last_name, COUNT(*) as number_cards
FROM payment_cards pc
         JOIN accounts a on (a.id = pc.account_id)
         JOIN customers c on (c.id = a.customer_id)
GROUP BY account_id, c.first_name, c.last_name
HAVING COUNT(*) > 1;

--Test: Customers who have made transactions using more than one card
SELECT
    c.first_name, c.last_name AS customer_name,
    (SELECT COUNT(DISTINCT t.payment_card_id)
     FROM transactions t
     WHERE t.payment_card_id IN
           (SELECT pc.id
            FROM payment_cards pc
            WHERE pc.account_id = a.id)) AS number_of_cards
FROM
    customers c
        JOIN accounts a ON c.id = a.customer_id
WHERE
    (SELECT COUNT(DISTINCT t.payment_card_id)
     FROM transactions t
     WHERE t.payment_card_id IN
           (SELECT pc.id
            FROM payment_cards pc
            WHERE pc.account_id = a.id)) > 1;



--TEST: number of transactions per card
SELECT
    pc.account_id,
    COUNT(t.id) AS transaction_count
FROM
    payment_cards pc
    LEFT JOIN transactions t ON pc.id = t.payment_card_id
GROUP BY
    pc.account_id;

