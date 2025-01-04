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


--Obliczanie całkowitej liczby kont w banku
SELECT COUNT(*) AS total_accounts
FROM accounts;


--Zwracanie listy klientów w określonej lokalizacji (kraj)
SELECT c.id, c.first_name, c.last_name, a.city, a.country
FROM customers c
JOIN addresses a ON c.address_id = a.id
WHERE a.country = 'USA';


--Test bank branches with the lowest number of employee
SELECT bb.branch_name,
    (SELECT COUNT(*) FROM employee_bankbranch eb
     WHERE eb.bankbranch_id = bb.id) AS employee_count
FROM bank_branches bb
WHERE (SELECT COUNT(*)
       FROM employee_bankbranch eb
       WHERE eb.bankbranch_id = bb.id) = (SELECT MIN((SELECT COUNT(*)
                                                      FROM employee_bankbranch eb2
                                                      WHERE eb2.bankbranch_id = bb2.id))
                                                      FROM bank_branches bb2);


--Wyszukiwanie transakcji po typie dla konkretnego użytkownika(np. przelewy, wpłaty, wypłaty)
SELECT t.id AS transaction_id, 
       t.amount, 
       t.transaction_type, 
       t.transaction_date, 
       t.payment_card_id
FROM transactions t
JOIN payment_cards pc ON t.payment_card_id = pc.id
JOIN accounts ac ON pc.account_id = ac.id
JOIN customers c ON ac.customer_id = c.id 
WHERE c.pesel = '12345678901'
  AND t.transaction_type = 'Deposit'
ORDER BY t.transaction_date DESC;


--Test connection between employees, their positions, bankbranches and their addresses
SELECT e.id AS employee_id, 
       e.first_name || ' ' || e.last_name AS employee_name, 
       p.name AS position_name, 
       bb.branch_name AS branch_name, 
       a.street || ', ' || a.city || ', ' || a.country AS branch_address 
FROM employees e
JOIN employee_positions ep ON e.id = ep.employee_id
JOIN positions p ON ep.positions_id = p.id
JOIN employee_bankbranch eb ON e.id = eb.employee_id
JOIN bank_branches bb ON eb.bankbranch_id = bb.id
JOIN addresses a ON bb.address_id = a.id
ORDER BY e.id;


--TEST: Transactions Summary by Type and Month
SELECT TO_CHAR(t.transaction_date, 'YYYY-MM') AS transaction_month, 
       t.transaction_type, 
       COUNT(t.id) AS transaction_count, 
       ROUND(SUM(t.amount), 2) AS total_amount
FROM transactions t
GROUP BY TO_CHAR(t.transaction_date, 'YYYY-MM'), t.transaction_type
ORDER BY transaction_month DESC, total_amount DESC;


--TEST: list of all branches, including the names of positions that have or do not have employees in a given branch
WITH branch_positions AS (
    SELECT 
        bb.id AS branch_id,
        bb.branch_name AS branch_name,
        p.id AS position_id,
        p.name AS position_name
    FROM bank_branches bb
    CROSS JOIN positions p
),
filled_positions AS (
    SELECT 
        eb.bankbranch_id AS branch_id,
        p.id AS position_id,
        p.name
    FROM employee_bankbranch eb
    JOIN employee_positions ep ON eb.employee_id = ep.employee_id
    JOIN positions p ON ep.positions_id = p.id
    GROUP BY eb.bankbranch_id, p.id, p.name
)
SELECT 
    bp.branch_id,
    bp.branch_name,
    bp.position_name AS position_in_branch,
    CASE 
        WHEN fp.position_id IS NOT NULL THEN 'FILLED'
        ELSE 'EMPTY'
    END AS position_status
FROM branch_positions bp
LEFT JOIN filled_positions fp 
    ON bp.branch_id = fp.branch_id AND bp.position_id = fp.position_id
ORDER BY bp.branch_id, position_status DESC, bp.position_name;