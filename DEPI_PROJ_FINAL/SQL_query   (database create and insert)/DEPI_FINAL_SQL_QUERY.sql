-- Customers table
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1),
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    DateOfBirth DATE,
    CustomerType NVARCHAR(50),
    CONSTRAINT PK_CustomerID PRIMARY KEY (CustomerID),
	CONSTRAINT CK_CustomerType CHECK (CustomerType IN ('Gold', 'Silver', 'Bronze'))
);

-- Transactions table
CREATE TABLE Transactions (
    TransactionID INT IDENTITY(1,1),
    CustomerID INT NOT NULL,
    TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
    Amount DECIMAL(10, 2) NOT NULL,
    TransactionType NVARCHAR(50) NOT NULL,
    ProductCategory NVARCHAR(100),
    CONSTRAINT PK_TransactionID PRIMARY KEY (TransactionID),
    CONSTRAINT FK_Transactions_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
	CONSTRAINT CK_TransactionType CHECK (TransactionType IN ('Purchase', 'Refund', 'Exchange')),
    CONSTRAINT CK_ProductCategory CHECK (ProductCategory IN ('Electronics', 'Clothing', 'Supplies', 'Other'))
);

-- Interactions table
CREATE TABLE Interactions (
    InteractionID INT IDENTITY(1,1),
    CustomerID INT NOT NULL,
    InteractionDate DATETIME NOT NULL DEFAULT GETDATE(),
    InteractionType NVARCHAR(50) NOT NULL,
    InteractionChannel NVARCHAR(50) NOT NULL,
    InteractionDetails NVARCHAR(MAX),
    CONSTRAINT PK_InteractionID PRIMARY KEY (InteractionID),
    CONSTRAINT FK_Interactions_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
	CONSTRAINT CK_InteractionType CHECK (InteractionType IN ('Inquiry', 'Complaint', 'Feedback', 'Support', 'Other')),
	CONSTRAINT CK_InteractionChannel CHECK (InteractionChannel IN ('Email', 'Phone', 'Web', 'Chat', 'Other'))
);
-- Inserting 700 customer records with more randomness
DECLARE @i INT = 1;
WHILE @i <= 700
BEGIN
    INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, DateOfBirth, CustomerType)
    VALUES (
        CONCAT('First', @i),  -- FirstName
        CONCAT('Last', @i),   -- LastName
        CONCAT('customer', @i, '@example.com'),  -- Email
        CONCAT('555-', FLOOR(RAND(CHECKSUM(NEWID())) * 899) + 100, '-', FLOOR(RAND(CHECKSUM(NEWID())) * 8999) + 1000),  -- Random Phone number (555-XXX-XXXX)
        CONCAT(FLOOR(RAND(CHECKSUM(NEWID())) * 9999) + 1, ' Street Name, Springfield, IL'),  -- Random Address number
        DATEADD(DAY, -FLOOR(RAND(CHECKSUM(NEWID())) * 15000), GETDATE()),  -- Random DateOfBirth (up to ~41 years ago)
        CASE 
            WHEN @i % 3 = 0 THEN 'Gold'
            WHEN @i % 3 = 1 THEN 'Silver'
            ELSE 'Bronze'
        END  -- Rotate CustomerType between Gold, Silver, Bronze
    );
    SET @i = @i + 1;
END;


-- Inserting 700 transaction records with more randomness
DECLARE @i INT = 1;
WHILE @i <= 700
BEGIN
    INSERT INTO Transactions (CustomerID, TransactionDate, Amount, TransactionType, ProductCategory)
    VALUES (
        FLOOR(RAND(CHECKSUM(NEWID())) * 100) + 1,  -- Random CustomerID between 1 and 100
        DATEADD(DAY, FLOOR(RAND(CHECKSUM(NEWID())) * 365), '2023-01-01'),  -- Random TransactionDate within 2023
        RAND() * 1000 + 50,  -- Random Amount between 50 and 1050
        CASE 
            WHEN @i % 3 = 0 THEN 'Purchase'
            WHEN @i % 3 = 1 THEN 'Refund'
            ELSE 'Exchange'
        END,  -- Rotate TransactionType
        CASE 
            WHEN @i % 5 = 0 THEN 'Electronics' 
            WHEN @i % 5 = 1 THEN 'Clothing' 
            WHEN @i % 5 = 2 THEN 'Supplies' 
            WHEN @i % 5 = 3 THEN 'Groceries'
            ELSE 'Other' 
        END  -- Rotate ProductCategory
    );
    SET @i = @i + 1;
END;







-- Inserting 700 interaction records with more categories and random data
DECLARE @i INT = 1;
WHILE @i <= 700
BEGIN
    INSERT INTO Interactions (CustomerID, InteractionDate, InteractionType, InteractionChannel, InteractionDetails)
    VALUES (
        FLOOR(RAND(CHECKSUM(NEWID())) * 100) + 1,  -- Random CustomerID between 1 and 100
        DATEADD(DAY, FLOOR(RAND(CHECKSUM(NEWID())) * 365), '2023-01-01'),  -- Random InteractionDate within 2023
        CASE 
            WHEN @i % 4 = 0 THEN 'Inquiry' 
            WHEN @i % 4 = 1 THEN 'Complaint' 
            WHEN @i % 4 = 2 THEN 'Feedback' 
            ELSE 'Support' 
        END,  -- Rotate InteractionType
        CASE 
            WHEN @i % 5 = 0 THEN 'Email' 
            WHEN @i % 5 = 1 THEN 'Phone' 
            WHEN @i % 5 = 2 THEN 'Web' 
            WHEN @i % 5 = 3 THEN 'Chat' 
            ELSE 'In-person' 
        END,  -- Rotate InteractionChannel
        CONCAT('Details for interaction ', @i, ' - ', NEWID())  -- Random InteractionDetails
    );
    SET @i = @i + 1;
END;
