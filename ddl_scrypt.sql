CREATE TABLE accounts (
    id            INTEGER NOT NULL,
    account_number VARCHAR2(50 CHAR) NOT NULL UNIQUE,
    balance       INTEGER,
    currency      VARCHAR2(50 CHAR) NOT NULL,
    customer_id   INTEGER NOT NULL
);

ALTER TABLE accounts ADD CONSTRAINT account_pk PRIMARY KEY ( id );

CREATE TABLE addresses (
    id            INTEGER NOT NULL,
    street        VARCHAR2(100 CHAR) NOT NULL,
    city          VARCHAR2(100 CHAR) NOT NULL,
    country       VARCHAR2(100 CHAR) NOT NULL,
    bank_branch_id INTEGER NOT NULL
);

ALTER TABLE addresses ADD CONSTRAINT address_pk PRIMARY KEY ( id );


CREATE TABLE bank_branches (
    id          INTEGER NOT NULL,
    branch_name VARCHAR2(100 CHAR) NOT NULL UNIQUE,
    phone_number VARCHAR2(20 CHAR) UNIQUE
);

ALTER TABLE bank_branches ADD CONSTRAINT bankbranch_pk PRIMARY KEY ( id );

CREATE TABLE customers (
    id          INTEGER NOT NULL,
    first_name  VARCHAR2(50 CHAR) NOT NULL,
    last_name   VARCHAR2(50 CHAR) NOT NULL,
    pesel       VARCHAR2(11 CHAR) UNIQUE,
    email       VARCHAR2(50 CHAR) UNIQUE,
    phone_number VARCHAR2(20 CHAR) UNIQUE,
    address_id   INTEGER
);

ALTER TABLE customers ADD CONSTRAINT customer_pk PRIMARY KEY ( id );


CREATE TABLE employees (
    id          INTEGER NOT NULL,
    first_name  VARCHAR2(50 CHAR) NOT NULL,
    last_name   VARCHAR2(50 CHAR) NOT NULL,
    salary      INTEGER
);

ALTER TABLE employees ADD CONSTRAINT employee_pk PRIMARY KEY ( id );

CREATE TABLE employee_bankbranch (
    employee_id   INTEGER NOT NULL,
    bankbranch_id INTEGER NOT NULL
);

ALTER TABLE employee_bankbranch ADD CONSTRAINT employee_bankbranch_pk PRIMARY KEY ( employee_id, bankbranch_id );

CREATE TABLE employee_positions (
    employee_id  INTEGER NOT NULL,
    positions_id INTEGER NOT NULL
);

ALTER TABLE employee_positions ADD CONSTRAINT employee_positions_pk PRIMARY KEY ( employee_id, positions_id );

CREATE TABLE payment_cards (
    id             INTEGER NOT NULL,
    card_number     VARCHAR2(50 CHAR) NOT NULL UNIQUE,
    expiration_date DATE NOT NULL,
    cvv            VARCHAR2(3 CHAR) NOT NULL,
    account_id      INTEGER NOT NULL
);

ALTER TABLE payment_cards ADD CONSTRAINT paymentcard_pk PRIMARY KEY ( id );


CREATE TABLE positions (
    id   INTEGER NOT NULL,
    name VARCHAR2(50 CHAR) NOT NULL UNIQUE
);

ALTER TABLE positions ADD CONSTRAINT positions_pk PRIMARY KEY ( id );

CREATE TABLE transactions (
    id              INTEGER NOT NULL,
    amount          INTEGER,
    transaction_type VARCHAR2(100 CHAR),
    payment_card_id       INTEGER NOT NULL
);

ALTER TABLE transactions ADD CONSTRAINT transaction_pk PRIMARY KEY ( id );


ALTER TABLE accounts ADD CONSTRAINT account_customer_fk FOREIGN KEY ( customer_id ) REFERENCES customers ( id );
ALTER TABLE addresses ADD CONSTRAINT address_bankbranch_fk FOREIGN KEY ( bank_branch_id ) REFERENCES bank_branches ( id );
ALTER TABLE customers ADD CONSTRAINT customer_address_fk FOREIGN KEY ( address_id ) REFERENCES addresses ( id );
ALTER TABLE employee_bankbranch ADD CONSTRAINT employee_bankbranch_bankbranch_fk FOREIGN KEY ( bankbranch_id ) REFERENCES bank_branches ( id );
ALTER TABLE employee_bankbranch ADD CONSTRAINT employee_bankbranch_employee_fk FOREIGN KEY ( employee_id ) REFERENCES employees ( id );

ALTER TABLE employee_positions ADD CONSTRAINT employee_positions_employee_fk FOREIGN KEY ( employee_id ) REFERENCES employees ( id );
ALTER TABLE employee_positions ADD CONSTRAINT employee_positions_positions_fk FOREIGN KEY ( positions_id ) REFERENCES positions ( id );
ALTER TABLE payment_cards ADD CONSTRAINT paymentcard_account_fk FOREIGN KEY ( account_id ) REFERENCES accounts ( id );

ALTER TABLE transactions ADD transaction_date DATE NOT NULL;

ALTER TABLE transactions ADD payment_card_id INTEGER NOT NULL;
ALTER TABLE transactions ADD CONSTRAINT transaction_payment_card_fk FOREIGN KEY ( payment_card_id ) REFERENCES payment_cards ( id );
