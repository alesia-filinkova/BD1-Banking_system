INSERT INTO bank_branches VALUES (101, 'First Branch', '123-456-7890');
INSERT INTO bank_branches VALUES (102, 'Second Branch', '234-567-8901');
INSERT INTO bank_branches VALUES (103, 'Third Branch', '345-678-9012');

commit;


INSERT INTO addresses VALUES (101, 'Wall Street', 'New York', 'USA', 101);
INSERT INTO addresses VALUES (102, 'Karl-marx-allee', 'Berlin', 'Germany', 102);
INSERT INTO addresses VALUES (103, 'Aleje Jerozolimskie', 'Warsaw', 'Poland', 103);

commit;


INSERT INTO customers VALUES (1001, 'John', 'Doe', '12345678901', 'john.doe@example.com', '111-222-3333', 101);
INSERT INTO customers VALUES (1002, 'Jane', 'Smith', '23456789012', 'jane.smith@example.com', '222-333-4444', 102);
INSERT INTO customers VALUES (1003, 'Alice', 'Johnson', '34567890123', 'alice.johnson@example.com', '333-444-5555', 103);
INSERT INTO customers VALUES (1004, 'Alex', 'Smith', '45678901234', 'alex.smith@example.com', '444-555-6666', 102);
INSERT INTO customers VALUES (1005, 'Mike', 'Johnson', '56789012345', 'mike.johnson@example.com', '555-666-7777', 103);
INSERT INTO customers VALUES (1006, 'Isabella', 'Garcia', '67890123456', 'isabella.garcia@example.com', '666-777-8888', 101);
INSERT INTO customers VALUES (1007, 'Robert', 'Green', '78901234567', 'robert.green@example.com', '777-888-9999', 101);
INSERT INTO customers VALUES (1008, 'Richard', 'Miller', '89012345678', 'richard.miller@example.com', '888-999-0000', 103);
INSERT INTO customers VALUES (1009, 'Charlotte', 'Lee', '90123456789', 'charlotte.lee@example.com', '999-000-1111', 102);
INSERT INTO customers VALUES (1010, 'Aurora', 'Lewis', '01234567890', 'aurora.lewis@example.com', '000-111-2222', 103);
INSERT INTO customers VALUES (1011, 'Hannah', 'Carter', '11234567890', 'hannah.carter@example.com', '121-222-3333', 101);
INSERT INTO customers VALUES (1012, 'Matthew', 'Rivera', '22345678901', 'matthew.rivera@example.com', '232-333-4444', 102);
INSERT INTO customers VALUES (1013, 'Anthony', 'Garcia', '33456789012', 'anthony.garcia@example.com', '343-444-5555', 103);
INSERT INTO customers VALUES (1014, 'Nora', 'Hall', '44567890123', 'nora.hall@example.com', '454-555-6666', 102);
INSERT INTO customers VALUES (1015, 'Savannah', 'Ward', '55678901234', 'savannah.ward@example.com', '565-666-7777', 101);
INSERT INTO customers VALUES (1016, 'Joseph', 'Flores', '66789012345', 'joseph.flores@example.com', '676-777-8888', 101);
INSERT INTO customers VALUES (1017, 'Alexander', 'Young', '77890123456', 'alexander.young@example.com', '787-888-9999', 102);
INSERT INTO customers VALUES (1018, 'James', 'Nelson', '88901234567', 'james.nelson@example.com', '898-999-0000', 103);
INSERT INTO customers VALUES (1019, 'Sophie', 'Baker', '99012345678', 'sophie.baker@example.com', '909-000-1111', 102);
INSERT INTO customers VALUES (1020, 'Isla', 'Bennett', '00123456789', 'isla.bennett@example.com', '010-111-2222', 103);

commit;


INSERT INTO accounts VALUES (1001, 'ACC1001', 10000, 'USD', 1001);
INSERT INTO accounts VALUES (1002, 'ACC1002', 20000, 'EUR', 1002);
INSERT INTO accounts VALUES (1003, 'ACC1003', 30000, 'PL', 1003);
INSERT INTO accounts VALUES (1004, 'ACC1004', 40000, 'USD', 1004);
INSERT INTO accounts VALUES (1005, 'ACC1005', 50000, 'USD', 1005);
INSERT INTO accounts VALUES (1006, 'ACC1006', 15000, 'EUR', 1006);
INSERT INTO accounts VALUES (1007, 'ACC1007', 62000, 'PL', 1007);
INSERT INTO accounts VALUES (1008, 'ACC1008', 53000, 'EUR', 1008);
INSERT INTO accounts VALUES (1009, 'ACC1009', 70000, 'PL', 1009);
INSERT INTO accounts VALUES (1010, 'ACC1010', 25000, 'USD', 1010);
INSERT INTO accounts VALUES (1011, 'ACC1011', 57000, 'EUR', 1011);
INSERT INTO accounts VALUES (1012, 'ACC1012', 29000, 'USD', 1012);
INSERT INTO accounts VALUES (1013, 'ACC1013', 14000, 'USD', 1013);
INSERT INTO accounts VALUES (1014, 'ACC1014', 30000, 'EUR', 1014);
INSERT INTO accounts VALUES (1015, 'ACC1015', 48000, 'PL', 1015);
INSERT INTO accounts VALUES (1016, 'ACC1016', 13000, 'EUR', 1016);
INSERT INTO accounts VALUES (1017, 'ACC1017', 32000, 'USD', 1017);
INSERT INTO accounts VALUES (1018, 'ACC1018', 68000, 'PL', 1018);
INSERT INTO accounts VALUES (1019, 'ACC1019', 56000, 'USD', 1019);
INSERT INTO accounts VALUES (1020, 'ACC1020', 34000, 'EUR', 1020);

commit;


INSERT INTO employees VALUES (2001, 'Robert', 'Brown', 2000);
INSERT INTO employees VALUES (2002, 'Emily', 'Davis', 3000);
INSERT INTO employees VALUES (2003, 'Michael', 'Wilson', 4000);
INSERT INTO employees VALUES (2004, 'Steve', 'Knight', 2500);
INSERT INTO employees VALUES (2005, 'Kate', 'Holmes', 3500);
INSERT INTO employees VALUES (2006, 'Skylar', 'Powell', 4800);
INSERT INTO employees VALUES (2007, 'Anna', 'Evans', 2000);
INSERT INTO employees VALUES (2008, 'Cora', 'Butler', 4100);
INSERT INTO employees VALUES (2009, 'Andrew', 'Hernandez', 3500);
INSERT INTO employees VALUES (2010, 'William', 'Williams', 1700);
INSERT INTO employees VALUES (2011, 'Jacob', 'Nguyen', 3300);
INSERT INTO employees VALUES (2012, 'Gary', 'Torres', 3500);
INSERT INTO employees VALUES (2013, 'Timothy', 'Harris', 2400);
INSERT INTO employees VALUES (2014, 'James', 'Lopez', 4600);
INSERT INTO employees VALUES (2015, 'Thomas', 'Robinson', 2200);
INSERT INTO employees VALUES (2016, 'Jade', 'Bryant', 1900);
INSERT INTO employees VALUES (2017, 'Stella', 'Mitchell', 4200);
INSERT INTO employees VALUES (2018, 'Naomi', 'Rogers', 3500);
INSERT INTO employees VALUES (2019, 'Zoey', 'Ward', 3000);
INSERT INTO employees VALUES (2020, 'Adeline', 'Foster', 3200);

commit;


INSERT INTO employee_bankbranch VALUES (2001, 101);
INSERT INTO employee_bankbranch VALUES (2002, 102);
INSERT INTO employee_bankbranch VALUES (2003, 103);
INSERT INTO employee_bankbranch VALUES (2004, 101);
INSERT INTO employee_bankbranch VALUES (2005, 103);
INSERT INTO employee_bankbranch VALUES (2006, 102);
INSERT INTO employee_bankbranch VALUES (2007, 101);
INSERT INTO employee_bankbranch VALUES (2008, 103);
INSERT INTO employee_bankbranch VALUES (2009, 103);
INSERT INTO employee_bankbranch VALUES (2010, 102);
INSERT INTO employee_bankbranch VALUES (2011, 102);
INSERT INTO employee_bankbranch VALUES (2012, 101);
INSERT INTO employee_bankbranch VALUES (2013, 103);
INSERT INTO employee_bankbranch VALUES (2014, 101);
INSERT INTO employee_bankbranch VALUES (2015, 102);
INSERT INTO employee_bankbranch VALUES (2016, 101);
INSERT INTO employee_bankbranch VALUES (2017, 103);
INSERT INTO employee_bankbranch VALUES (2018, 102);
INSERT INTO employee_bankbranch VALUES (2019, 102);
INSERT INTO employee_bankbranch VALUES (2020, 101);

commit;

INSERT INTO positions VALUES (201, 'Manager');
INSERT INTO positions VALUES (202, 'Banker');
INSERT INTO positions VALUES (203, 'Admin');
INSERT INTO positions VALUES (204, 'Analyst');
INSERT INTO positions VALUES (205, 'Clerk');

commit;


INSERT INTO employee_positions VALUES (2001, 201);
INSERT INTO employee_positions VALUES (2002, 202);
INSERT INTO employee_positions VALUES (2003, 203);
INSERT INTO employee_positions VALUES (2004, 204);
INSERT INTO employee_positions VALUES (2005, 205);
INSERT INTO employee_positions VALUES (2006, 201);
INSERT INTO employee_positions VALUES (2007, 205);
INSERT INTO employee_positions VALUES (2008, 201);
INSERT INTO employee_positions VALUES (2009, 203);
INSERT INTO employee_positions VALUES (2010, 205);
INSERT INTO employee_positions VALUES (2011, 204);
INSERT INTO employee_positions VALUES (2012, 202);
INSERT INTO employee_positions VALUES (2013, 203);
INSERT INTO employee_positions VALUES (2014, 205);
INSERT INTO employee_positions VALUES (2015, 202);
INSERT INTO employee_positions VALUES (2016, 204);
INSERT INTO employee_positions VALUES (2017, 204);
INSERT INTO employee_positions VALUES (2018, 201);
INSERT INTO employee_positions VALUES (2019, 202);
INSERT INTO employee_positions VALUES (2020, 201);

commit;


INSERT INTO payment_cards VALUES (3001, '1111222233334444', TO_DATE('2028-12-31', 'YYYY-MM-DD'), '123', 1001);
INSERT INTO payment_cards VALUES (3002, '2222333344445555', TO_DATE('2029-10-31', 'YYYY-MM-DD'), '234', 1002);
INSERT INTO payment_cards VALUES (3003, '3333444455556666', TO_DATE('2027-03-31', 'YYYY-MM-DD'), '345', 1003);
INSERT INTO payment_cards VALUES (3004, '4444555566667777', TO_DATE('2025-06-30', 'YYYY-MM-DD'), '456', 1004);
INSERT INTO payment_cards VALUES (3005, '5555666677778888', TO_DATE('2027-09-30', 'YYYY-MM-DD'), '567', 1005);
INSERT INTO payment_cards VALUES (3006, '6666777788889999', TO_DATE('2028-11-30', 'YYYY-MM-DD'), '677', 1006);
INSERT INTO payment_cards VALUES (3007, '7777888899990000', TO_DATE('2029-01-31', 'YYYY-MM-DD'), '789', 1007);
INSERT INTO payment_cards VALUES (3008, '8888999900001111', TO_DATE('2026-04-30', 'YYYY-MM-DD'), '890', 1008);
INSERT INTO payment_cards VALUES (3009, '9999000011112222', TO_DATE('2026-08-31', 'YYYY-MM-DD'), '901', 1009);
INSERT INTO payment_cards VALUES (3010, '1000111122223333', TO_DATE('2029-02-28', 'YYYY-MM-DD'), '100', 1010);
INSERT INTO payment_cards VALUES (3011, '1100222233334444', TO_DATE('2027-07-31', 'YYYY-MM-DD'), '101', 1011);
INSERT INTO payment_cards VALUES (3012, '1200222233334444', TO_DATE('2027-03-31', 'YYYY-MM-DD'), '102', 1012);
INSERT INTO payment_cards VALUES (3013, '1300222233334444', TO_DATE('2026-01-31', 'YYYY-MM-DD'), '103', 1013);
INSERT INTO payment_cards VALUES (3014, '1400222233334444', TO_DATE('2029-08-31', 'YYYY-MM-DD'), '104', 1014);
INSERT INTO payment_cards VALUES (3015, '1500222233334444', TO_DATE('2026-11-30', 'YYYY-MM-DD'), '105', 1015);
INSERT INTO payment_cards VALUES (3016, '1600222233334444', TO_DATE('2027-03-31', 'YYYY-MM-DD'), '106', 1016);
INSERT INTO payment_cards VALUES (3017, '1700222233334444', TO_DATE('2028-08-31', 'YYYY-MM-DD'), '107', 1017);
INSERT INTO payment_cards VALUES (3018, '1800222233334444', TO_DATE('2026-05-31', 'YYYY-MM-DD'), '108', 1018);
INSERT INTO payment_cards VALUES (3019, '1900222333334444', TO_DATE('2027-02-28', 'YYYY-MM-DD'), '109', 1019);
INSERT INTO payment_cards VALUES (3020, '2000333344445555', TO_DATE('2029-06-30', 'YYYY-MM-DD'), '200', 1020);
INSERT INTO payment_cards VALUES (3021, '2100333344445555', TO_DATE('2025-07-31', 'YYYY-MM-DD'), '201', 1015);
INSERT INTO payment_cards VALUES (3022, '2200333344445555', TO_DATE('2025-10-31', 'YYYY-MM-DD'), '202', 1006);
INSERT INTO payment_cards VALUES (3023, '2300333344445555', TO_DATE('2028-01-31', 'YYYY-MM-DD'), '203', 1020);
INSERT INTO payment_cards VALUES (3024, '2400333344445555', TO_DATE('2026-09-30', 'YYYY-MM-DD'), '204', 1012);
INSERT INTO payment_cards VALUES (3025, '2500333344445555', TO_DATE('2027-04-30', 'YYYY-MM-DD'), '205', 1008);

commit;


INSERT INTO transactions VALUES (4001, 500, 'Deposit', TO_DATE('2024-12-15', 'YYYY-MM-DD'), 3001);
INSERT INTO transactions VALUES (4002, 722, 'Withdrawal', TO_DATE('2024-12-15', 'YYYY-MM-DD'), 3002);
INSERT INTO transactions VALUES (4003, 434, 'Payment', TO_DATE('2024-12-15', 'YYYY-MM-DD'), 3003);
INSERT INTO transactions VALUES (4004, 618, 'Purchase', TO_DATE('2024-12-15', 'YYYY-MM-DD'), 3004);
INSERT INTO transactions VALUES (4005, 234, 'Tax Payments', TO_DATE('2024-12-15', 'YYYY-MM-DD'), 3005);
INSERT INTO transactions VALUES (4006, 917, 'Tax Refund', TO_DATE('2024-12-16', 'YYYY-MM-DD'), 3006);
INSERT INTO transactions VALUES (4007, 109, 'Bill Payment', TO_DATE('2024-12-16', 'YYYY-MM-DD'), 3007);
INSERT INTO transactions VALUES (4008, 213, 'Refund', TO_DATE('2024-12-16', 'YYYY-MM-DD'), 3008);
INSERT INTO transactions VALUES (4009, 950, 'Transfer', TO_DATE('2024-12-16', 'YYYY-MM-DD'), 3009);
INSERT INTO transactions VALUES (4010, 38, 'Deposit', TO_DATE('2024-12-16', 'YYYY-MM-DD'), 3010);
INSERT INTO transactions VALUES (4011, 800, 'Refund', TO_DATE('2024-12-17', 'YYYY-MM-DD'), 3011);
INSERT INTO transactions VALUES (4012, 695, 'Bill Payment', TO_DATE('2024-12-17', 'YYYY-MM-DD'), 3012);
INSERT INTO transactions VALUES (4013, 877, 'Tax Refund', TO_DATE('2024-12-17', 'YYYY-MM-DD'), 3013);
INSERT INTO transactions VALUES (4014, 771, 'Deposit', TO_DATE('2024-12-17', 'YYYY-MM-DD'), 3014);
INSERT INTO transactions VALUES (4015, 173, 'Payment', TO_DATE('2024-12-17', 'YYYY-MM-DD'), 3015);
INSERT INTO transactions VALUES (4016, 129, 'Withdrawal', TO_DATE('2024-12-18', 'YYYY-MM-DD'), 3016);
INSERT INTO transactions VALUES (4017, 854, 'Transfer', TO_DATE('2024-12-18', 'YYYY-MM-DD'), 3017);
INSERT INTO transactions VALUES (4018, 689, 'Purchase', TO_DATE('2024-12-18', 'YYYY-MM-DD'), 3018);
INSERT INTO transactions VALUES (4019, 302, 'Refund', TO_DATE('2024-12-18', 'YYYY-MM-DD'), 3019);
INSERT INTO transactions VALUES (4020, 680, 'Tax Payments', TO_DATE('2024-12-18', 'YYYY-MM-DD'), 3020);
INSERT INTO transactions VALUES (4021, 783, 'Tax Refund', TO_DATE('2024-12-19', 'YYYY-MM-DD'), 3021);
INSERT INTO transactions VALUES (4022, 585, 'Payment', TO_DATE('2024-12-19', 'YYYY-MM-DD'), 3022);
INSERT INTO transactions VALUES (4023, 225, 'Transfer', TO_DATE('2024-12-19', 'YYYY-MM-DD'), 3023);
INSERT INTO transactions VALUES (4024, 992, 'Withdrawal', TO_DATE('2024-12-19', 'YYYY-MM-DD'), 3024);
INSERT INTO transactions VALUES (4025, 837, 'Tax Payments', TO_DATE('2024-12-19', 'YYYY-MM-DD'), 3025);
INSERT INTO transactions VALUES (4026, 192, 'Purchase', TO_DATE('2024-12-20', 'YYYY-MM-DD'), 3025);
INSERT INTO transactions VALUES (4027, 201, 'Bill Payment', TO_DATE('2024-12-20', 'YYYY-MM-DD'), 3024);
INSERT INTO transactions VALUES (4028, 995, 'Tax Refund', TO_DATE('2024-12-20', 'YYYY-MM-DD'), 3023);
INSERT INTO transactions VALUES (4029, 635, 'Deposit', TO_DATE('2024-12-20', 'YYYY-MM-DD'), 3022);
INSERT INTO transactions VALUES (4030, 296, 'Refund', TO_DATE('2024-12-20', 'YYYY-MM-DD'), 3021);
INSERT INTO transactions VALUES (4031, 844, 'Bill Payment', TO_DATE('2024-12-21', 'YYYY-MM-DD'), 3020);
INSERT INTO transactions VALUES (4032, 69, 'Purchase', TO_DATE('2024-12-21', 'YYYY-MM-DD'), 3019);
INSERT INTO transactions VALUES (4033, 754, 'Tax Refund', TO_DATE('2024-12-21', 'YYYY-MM-DD'), 3018);
INSERT INTO transactions VALUES (4034, 519, 'Tax Payments', TO_DATE('2024-12-21', 'YYYY-MM-DD'), 3017);
INSERT INTO transactions VALUES (4035, 739, 'Refund', TO_DATE('2024-12-21', 'YYYY-MM-DD'), 3016);
INSERT INTO transactions VALUES (4036, 643, 'Transfer', TO_DATE('2024-12-22', 'YYYY-MM-DD'), 3015);
INSERT INTO transactions VALUES (4037, 839, 'Deposit', TO_DATE('2024-12-22', 'YYYY-MM-DD'), 3014);
INSERT INTO transactions VALUES (4038, 366, 'Tax Payments', TO_DATE('2024-12-22', 'YYYY-MM-DD'), 3013);
INSERT INTO transactions VALUES (4039, 714, 'Deposit', TO_DATE('2024-12-22', 'YYYY-MM-DD'), 3012);
INSERT INTO transactions VALUES (4040, 659, 'Bill Payment', TO_DATE('2024-12-22', 'YYYY-MM-DD'), 3011);
INSERT INTO transactions VALUES (4041, 970, 'Refund', TO_DATE('2024-12-23', 'YYYY-MM-DD'), 3010);
INSERT INTO transactions VALUES (4042, 83, 'Transfer', TO_DATE('2024-12-23', 'YYYY-MM-DD'), 3009);
INSERT INTO transactions VALUES (4043, 483, 'Tax Refund', TO_DATE('2024-12-23', 'YYYY-MM-DD'), 3008);
INSERT INTO transactions VALUES (4044, 772, 'Refund', TO_DATE('2024-12-23', 'YYYY-MM-DD'), 3007);
INSERT INTO transactions VALUES (4045, 405, 'Payment', TO_DATE('2024-12-23', 'YYYY-MM-DD'), 3006);
INSERT INTO transactions VALUES (4046, 67, 'Bill Payment', TO_DATE('2024-12-24', 'YYYY-MM-DD'), 3005);
INSERT INTO transactions VALUES (4047, 233, 'Transfer', TO_DATE('2024-12-24', 'YYYY-MM-DD'), 3004);
INSERT INTO transactions VALUES (4048, 611, 'Withdrawal', TO_DATE('2024-12-24', 'YYYY-MM-DD'), 3003);
INSERT INTO transactions VALUES (4049, 108, 'Deposit', TO_DATE('2024-12-24', 'YYYY-MM-DD'), 3002);
INSERT INTO transactions VALUES (4050, 759, 'Tax Payments', TO_DATE('2024-12-24', 'YYYY-MM-DD'), 3001);
INSERT INTO transactions VALUES (4051, 239, 'Refund', TO_DATE('2024-12-25', 'YYYY-MM-DD'), 3013);
INSERT INTO transactions VALUES (4052, 722, 'Purchase', TO_DATE('2024-12-25', 'YYYY-MM-DD'), 3022);
INSERT INTO transactions VALUES (4053, 865, 'Withdrawal', TO_DATE('2024-12-25', 'YYYY-MM-DD'), 3023);
INSERT INTO transactions VALUES (4054, 69, 'Payment', TO_DATE('2024-12-25', 'YYYY-MM-DD'), 3007);
INSERT INTO transactions VALUES (4055, 311, 'Transfer', TO_DATE('2024-12-25', 'YYYY-MM-DD'), 3012);
INSERT INTO transactions VALUES (4056, 320, 'Deposit', TO_DATE('2024-12-26', 'YYYY-MM-DD'), 3002);
INSERT INTO transactions VALUES (4057, 11, 'Payment', TO_DATE('2024-12-26', 'YYYY-MM-DD'), 3020);
INSERT INTO transactions VALUES (4058, 25, 'Transfer', TO_DATE('2024-12-26', 'YYYY-MM-DD'), 3003);
INSERT INTO transactions VALUES (4059, 477, 'Refund', TO_DATE('2024-12-26', 'YYYY-MM-DD'), 3010);
INSERT INTO transactions VALUES (4060, 639, 'Tax Refund', TO_DATE('2024-12-26', 'YYYY-MM-DD'), 3012);

commit;