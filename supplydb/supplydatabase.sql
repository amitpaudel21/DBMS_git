create database supply;
use supply;


CREATE TABLE Supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE Parts (
    pid INT PRIMARY KEY,
    pname VARCHAR(50),
    color VARCHAR(20)
);

CREATE TABLE Catalog (
    sid INT,
    pid INT,
    cost DECIMAL(10,2),
    PRIMARY KEY (sid, pid),
    FOREIGN KEY (sid) REFERENCES Supplier(sid),
    FOREIGN KEY (pid) REFERENCES Parts(pid)
);




-- SUPPLIERS
INSERT INTO Supplier VALUES (10001, 'Acme Widget', 'Bangalore');
INSERT INTO Supplier VALUES (10002, 'Johns', 'Kolkata');
INSERT INTO Supplier VALUES (10003, 'Vimal', 'Mumbai');
INSERT INTO Supplier VALUES (10004, 'Reliance', 'Delhi');

-- PARTS
INSERT INTO Parts VALUES (20001, 'Book', 'Red');
INSERT INTO Parts VALUES (20002, 'Pen', 'Red');
INSERT INTO Parts VALUES (20003, 'Pencil', 'Green');
INSERT INTO Parts VALUES (20004, 'Mobile', 'Green');
INSERT INTO Parts VALUES (20005, 'Charger', 'Black');

-- CATALOG
INSERT INTO Catalog VALUES (10001, 20001, 10);
INSERT INTO Catalog VALUES (10001, 20002, 10);
INSERT INTO Catalog VALUES (10001, 20003, 30);
INSERT INTO Catalog VALUES (10001, 20004, 10);
INSERT INTO Catalog VALUES (10001, 20005, 10);
INSERT INTO Catalog VALUES (10002, 20001, 10);
INSERT INTO Catalog VALUES (10002, 20002, 20);
INSERT INTO Catalog VALUES (10003, 20003, 30);
INSERT INTO Catalog VALUES (10004, 20003, 40);


SELECT DISTINCT p.pname
FROM Parts p
JOIN Catalog c ON p.pid = c.pid
ORDER BY p.pname;


SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE NOT EXISTS (
        SELECT c.pid
        FROM Catalog c
        WHERE c.sid = s.sid AND c.pid = p.pid
    )
);


SELECT s.sname
FROM Supplier s
WHERE NOT EXISTS (
    SELECT p.pid
    FROM Parts p
    WHERE p.color = 'Red'
      AND NOT EXISTS (
          SELECT c.pid
          FROM Catalog c
          WHERE c.sid = s.sid AND c.pid = p.pid
      )
);




SELECT p.pname
FROM Parts p
WHERE EXISTS (
    SELECT 1 FROM Catalog c
    JOIN Supplier s ON c.sid = s.sid
    WHERE s.sname = 'Acme Widget' AND c.pid = p.pid
)
AND NOT EXISTS (
    SELECT 1 FROM Catalog c2
    JOIN Supplier s2 ON c2.sid = s2.sid
    WHERE c2.pid = p.pid AND s2.sname <> 'Acme Widget'
);



SELECT DISTINCT c.sid
FROM Catalog c
JOIN (
    SELECT pid, AVG(cost) AS avg_cost
    FROM Catalog
    GROUP BY pid
) AS avgc ON c.pid = avgc.pid
WHERE c.cost > avgc.avg_cost;




SELECT p.pname, s.sname, c.cost
FROM Catalog c
JOIN Supplier s ON c.sid = s.sid
JOIN Parts p ON c.pid = p.pid
WHERE c.cost = (
    SELECT MAX(cost)
    FROM Catalog c2
    WHERE c2.pid = c.pid
)
ORDER BY p.pid;