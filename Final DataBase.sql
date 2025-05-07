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
(3, 3);


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
('Guest User'),
('Customer'),
('Admin' );
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
('viewer@example.com', 'hashed_pw_4', 'Diana', 'Viewer', '4567890123', '101 Viewer Rd', 'Houston', 'TX', '77001', 'USA', 1),
('support@example.com', 'hashed_pw_5', 'Ethan', 'Support', '5678901234', '202 Support Ln', 'Phoenix', 'AZ', '85001', 'USA', 2),
('hr@example.com', 'hashed_pw_6', 'Fiona', 'HR', '6789012345', '303 HR Pkwy', 'Philadelphia', 'PA', '19101', 'USA', 3);
GO



-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
);
GO

INSERT INTO Categories (Name, Description, ParentCategoryID, ImageURL)
VALUES
('Sofa'),
('Dining Table'),
('Bed'),
('Flower Vase');
GO


CREATE TABLE ProductImages (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    ImageURL NVARCHAR(255) NOT NULL,
);
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





CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(18, 2) NOT NULL,
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID),
    ModelURL NVARCHAR(255) NOT NULL, -- URL to 3D model file
    ThumbnailURL NVARCHAR(255),
    Quantity INT DEFAULT 0,
);
GO


INSERT INTO Products (Name, Description, Price, CategoryID, ModelURL, ThumbnailURL, Quantity)
VALUES 
('sofa1', 'Sofa for 2 members', 129.99, 1,
 'https://example.com/models/headphones.glb', 'https://example.com/images/headphones.jpg', 50),

('Dining Table', 'Very comfortable dining tablw to eat with family', 199.49, 2,
 'https://example.com/models/smartwatch.glb', 'https://example.com/images/smartwatch.jpg', 35),

('Bed', 'King size bed', 249.99, 3,
 'https://example.com/models/actioncamera.glb', 'https://example.com/images/actioncamera.jpg', 20),

('Flower vase', 'decorative flower vase.', 59.99, 4,
 'https://example.com/models/speaker.glb', 'https://example.com/images/speaker.jpg', 75),

('Sofa2', 'Sofa for 5 members', 39.99, 1,
 'https://example.com/models/gamingmouse.glb', 'https://example.com/images/gamingmouse.jpg', 100);




