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


CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    Email NVARCHAR(255) NOT NULL UNIQUE,
    PasswordHash NVARCHAR(255) NOT NULL,
    FirstName NVARCHAR(100),
    LastName NVARCHAR(100),
    PhoneNumber NVARCHAR(20),
    Address NVARCHAR(255),
    City NVARCHAR(100),
    State NVARCHAR(100),
    PostalCode NVARCHAR(20),
    Country NVARCHAR(100),
    RoleID INT NOT NULL FOREIGN KEY REFERENCES Roles(RoleID)
);
GO
    
INSERT INTO Users (Email, PasswordHash, FirstName, LastName, PhoneNumber, Address, City, State, PostalCode, Country, RoleID)
VALUES 
('admin@example.com', 'hashed_pw_1', 'Alice', 'Admin', '1234567890', '123 Admin St', 'New York', 'NY', '10001', 'USA', 1),
('manager@example.com', 'hashed_pw_2', 'Bob', 'Manager', '2345678901', '456 Manager Ave', 'Los Angeles', 'CA', '90001', 'USA', 2),
('editor@example.com', 'hashed_pw_3', 'Charlie', 'Editor', '3456789012', '789 Editor Blvd', 'Chicago', 'IL', '60601', 'USA', 3),
('viewer@example.com', 'hashed_pw_4', 'Diana', 'Viewer', '4567890123', '101 Viewer Rd', 'Houston', 'TX', '77001', 'USA', 4),
('support@example.com', 'hashed_pw_5', 'Ethan', 'Support', '5678901234', '202 Support Ln', 'Phoenix', 'AZ', '85001', 'USA', 5),
('hr@example.com', 'hashed_pw_6', 'Fiona', 'HR', '6789012345', '303 HR Pkwy', 'Philadelphia', 'PA', '19101', 'USA', 6),
('finance@example.com', 'hashed_pw_7', 'George', 'Finance', '7890123456', '404 Finance Way', 'San Antonio', 'TX', '78201', 'USA', 7),
('dev@example.com', 'hashed_pw_8', 'Hannah', 'Developer', '8901234567', '505 Dev Cir', 'San Diego', 'CA', '92101', 'USA', 8),
('qa@example.com', 'hashed_pw_9', 'Ivan', 'Tester', '9012345678', '606 QA Dr', 'Dallas', 'TX', '75201', 'USA', 9),
('guest@example.com', 'hashed_pw_10', 'Judy', 'Guest', '0123456789', '707 Guest Pl', 'San Jose', 'CA', '95101', 'USA', 10);
GO



-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    ParentCategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    ImageURL NVARCHAR(255),
);
GO

INSERT INTO Categories (Name, Description, ParentCategoryID, ImageURL)
VALUES
('Electronics', 'Devices and gadgets', NULL, 'https://example.com/images/electronics.jpg'),
('Computers', 'Desktops, laptops, and accessories', 1, 'https://example.com/images/computers.jpg'),
('Mobile Phones', 'Smartphones and mobile accessories', 1, 'https://example.com/images/mobiles.jpg'),
('Home Appliances', 'Appliances for household use', NULL, 'https://example.com/images/home_appliances.jpg'),
('Kitchen Appliances', 'Appliances used in the kitchen', 4, 'https://example.com/images/kitchen.jpg'),
('Fashion', 'Clothing and accessories', NULL, 'https://example.com/images/fashion.jpg'),
('Men Clothing', 'Apparel for men', 6, 'https://example.com/images/men.jpg'),
('Women Clothing', 'Apparel for women', 6, 'https://example.com/images/women.jpg'),
('Books', 'Printed and digital books', NULL, 'https://example.com/images/books.jpg'),
('Fiction', 'Fictional books and novels', 9, 'https://example.com/images/fiction.jpg');
GO


INSERT INTO ProductImages (ProductID, ImageURL)
VALUES
(1, 'https://example.com/images/product1_img1.jpg'),
(1, 'https://example.com/images/product1_img2.jpg'),
(2, 'https://example.com/images/product2_img1.jpg'),
(2, 'https://example.com/images/product2_img2.jpg'),
(3, 'https://example.com/images/product3_img1.jpg'),
(3, 'https://example.com/images/product3_img2.jpg'),
(4, 'https://example.com/images/product4_img1.jpg'),
(4, 'https://example.com/images/product4_img2.jpg'),
(5, 'https://example.com/images/product5_img1.jpg'),
(5, 'https://example.com/images/product5_img2.jpg');
GO


