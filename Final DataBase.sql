--SavedProducts table
CREATE TABLE SavedProducts (
    SavedProductID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,

);
GO
    INSERT INTO SavedProducts (UserID, ProductID)
VALUES
(1, 2),
(1, 4),
(2, 1),
(2, 5),
(3, 3),
(3, 6),
(4, 7),
(4, 8),
(5, 9),
(5, 10);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(18, 2) NOT NULL,
    ShippingAddress NVARCHAR(255),
    ShippingCity NVARCHAR(100),
    ShippingState NVARCHAR(100),
    ShippingPostalCode NVARCHAR(20),
    ShippingCountry NVARCHAR(100),

);
GO
    INSERT INTO Orders (UserID, TotalAmount, ShippingAddress, ShippingCity, ShippingState, ShippingPostalCode, ShippingCountry)
VALUES 
(1, 150.75, '123 Main St', 'New York', 'NY', '10001', 'USA'),
(2, 299.99, '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA'),
(3, 89.50, '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA'),
(4, 420.00, '101 Maple Blvd', 'Houston', 'TX', '77001', 'USA'),
(5, 59.95, '202 Birch Ln', 'Phoenix', 'AZ', '85001', 'USA'),
(1, 230.25, '123 Main St', 'New York', 'NY', '10001', 'USA'),
(2, 199.99, '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA'),
(3, 320.10, '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA'),
(4, 150.00, '101 Maple Blvd', 'Houston', 'TX', '77001', 'USA'),
(5, 75.00, '202 Birch Ln', 'Phoenix', 'AZ', '85001', 'USA');

-- Order Items Table
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID) ON DELETE CASCADE,
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    CustomizationDetails NVARCHAR(MAX)
);
GO
    INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice, CustomizationDetails)
VALUES
(1, 2, 1, 49.99, 'Color: Red, Size: M'),
(1, 3, 2, 29.95, NULL),
(2, 5, 1, 99.00, 'Engraving: "Happy B-Day"'),
(2, 1, 3, 19.99, NULL),
(3, 6, 2, 45.50, 'Packaging: Gift wrap'),
(3, 7, 1, 89.99, NULL),
(4, 4, 5, 9.99, NULL),
(4, 8, 2, 39.95, 'Color: Black'),
(5, 9, 1, 120.00, NULL),
(5, 10, 1, 75.00, 'Material: Organic Cotton');

CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
);
GO

INSERT INTO Roles (RoleName)
VALUES 
('Administrator'),
('Manager'),
('Editor' ),
('Viewer'),
('Support'),
('HR'),
('Finance'),
('Developer'),
('QA Tester'),
('Guest');
GO




