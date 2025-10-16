CREATE DATABASE Bank;
USE Bank;
CREATE TABLE Branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50),
    assets REAL);
CREATE TABLE BankAccount (
    accno INT PRIMARY KEY,
    branch_name VARCHAR(50),
    balance REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name));
CREATE TABLE BankCustomer (
    customer_name VARCHAR(50) PRIMARY KEY,
    customer_street VARCHAR(50),
    customer_city VARCHAR(50));
CREATE TABLE Depositer (
    customer_name VARCHAR(50),
    accno INT,
    PRIMARY KEY (customer_name, accno),
    FOREIGN KEY (customer_name) REFERENCES BankCustomer(customer_name),
    FOREIGN KEY (accno) REFERENCES BankAccount(accno));
CREATE TABLE Loan (
    loan_number VARCHAR(10) PRIMARY KEY,
    branch_name VARCHAR(50),
    amount REAL,
    FOREIGN KEY (branch_name) REFERENCES Branch(branch_name));
INSERT INTO Branch VALUES
('SBI_Chamrajpet', 'Bangalore', 50000),
('SBI_ResidencyRoad', 'Bangalore', 10000),
('SBI_ShivajiRoad', 'Bombay', 20000),
('SBI_ParliamentRoad', 'Delhi', 10000),
('SBI_Jantarmantar', 'Delhi', 20000);
INSERT INTO BankAccount VALUES
(1, 'SBI_Chamrajpet', 2000),
(2, 'SBI_ResidencyRoad', 5000),
(3, 'SBI_ShivajiRoad', 6000),
(4, 'SBI_ParliamentRoad', 9000),
(5, 'SBI_Jantarmantar', 8000);
INSERT INTO BankCustomer VALUES
('Avinash', 'Bull_Temple_Road', 'Bangalore'),
('Dinesh', 'Bannergatta_Road', 'Bangalore'),
('Mohan', 'NationalCollege_Road', 'Bangalore'),
('Nikhil', 'Akbar_Road', 'Delhi'),
('Ravi', 'Prithviraj_Road', 'Delhi');
INSERT INTO Depositer VALUES
('Avinash', 1),
('Dinesh', 2),
('Nikhil', 3),
('Mohan', 4),
('Ravi', 5);
INSERT INTO Loan VALUES
('1', 'SBI_Chamrajpet', 1000),
('2', 'SBI_ResidencyRoad', 2000),
('3', 'SBI_ShivajiRoad', 3000),
('4', 'SBI_ParliamentRoad', 4000),
('5', 'SBI_Jantarmantar', 5000);

SELECT branch_name, (assets / 100000) AS "Assets_in_Lakhs"
FROM Branch;

SELECT d.customer_name, a.branch_name, COUNT(*) AS num_accounts
FROM Depositer d
JOIN BankAccount a ON d.accno = a.accno
GROUP BY d.customer_name, a.branch_name
HAVING COUNT(*) >= 2;

CREATE VIEW BranchLoanSummary AS
SELECT branch_name, SUM(amount) AS total_loan_amount
FROM Loan
GROUP BY branch_name;

SELECT * FROM BranchLoanSummary;

SELECT d.customer_name
FROM Depositer d
JOIN BankAccount a ON d.accno = a.accno
JOIN Branch b ON a.branch_name = b.branch_name
WHERE b.branch_city = 'Delhi'
GROUP BY d.customer_name
HAVING COUNT(DISTINCT b.branch_name) = (
    SELECT COUNT(branch_name)
    FROM Branch
    WHERE branch_city = 'Delhi'
);

SELECT c.customer_name
FROM BankCustomer c
JOIN Branch b ON c.customer_city = b.branch_city
JOIN Loan l ON l.branch_name = b.branch_name
WHERE c.customer_name NOT IN (SELECT customer_name FROM Depositer)
GROUP BY c.customer_name;

SELECT DISTINCT d.customer_name
FROM Depositer d
JOIN BankAccount a ON d.accno = a.accno
JOIN Branch b1 ON a.branch_name = b1.branch_name
WHERE b1.branch_city = 'Bangalore'
  AND b1.branch_name IN (
      SELECT l.branch_name
      FROM Loan l
      JOIN Branch b2 ON l.branch_name = b2.branch_name
      WHERE b2.branch_city = 'Bangalore'
  );

SELECT branch_name
FROM Branch
WHERE assets > ALL (
    SELECT assets
    FROM Branch
    WHERE branch_city = 'Bangalore'
);

DELETE FROM Depositer
WHERE accno IN (
    SELECT accno
    FROM BankAccount
    WHERE branch_name IN (
        SELECT branch_name
        FROM Branch
        WHERE branch_city = 'Bombay'
    )
);

DELETE FROM BankAccount
WHERE branch_name IN (
    SELECT branch_name
    FROM Branch
    WHERE branch_city = 'Bombay'
);

SELECT * FROM Depositer;

SELECT * FROM BankAccount;

UPDATE BankAccount
SET balance = balance * 1.05;
                                                                                                                                                     
SELECT accno, branch_name, balance AS new_balance
FROM BankAccount;

