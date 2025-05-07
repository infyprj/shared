-- Database Creation
CREATE DATABASE Ecommerce3D;
GO

USE Ecommerce3D;
GO

-- User Roles Table
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Insert default roles
INSERT INTO Roles (RoleName, Description) 
VALUES 
('Admin', 'System administrator with full access'),
('Customer', 'Regular customer account'),
('Guest', 'Unauthenticated user');
Go


INSERT INTO Roles (RoleName, Description)
VALUES 
('Administrator', 'Has full access to all system features and settings.'),
('Manager', 'Oversees operations and manages user activities.'),
('Editor', 'Can edit content but has limited access to settings.'),
('Viewer', 'Read-only access to view system data.'),
('Support', 'Handles support tickets and user queries.'),
('HR', 'Manages employee records and HR tasks.'),
('Finance', 'Access to financial data and reporting tools.'),
('Developer', 'Works on application development and maintenance.'),
('QA Tester', 'Responsible for testing and quality assurance.'),
('Guest', 'Temporary access with minimal permissions.');
GO



-- Users Table
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
    RoleID INT NOT NULL FOREIGN KEY REFERENCES Roles(RoleID),
    IsEmailVerified BIT DEFAULT 0,
    IsSocialLogin BIT DEFAULT 0,
    SocialProvider NVARCHAR(50),
    SocialProviderID NVARCHAR(255),
    LastLoginDate DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);
GO

-- Create index on Email for faster login
CREATE INDEX IX_Users_Email ON Users(Email);
GO

-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    ParentCategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    ImageURL NVARCHAR(255),
    IsActive BIT DEFAULT 1,
    DisplayOrder INT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(18, 2) NOT NULL,
    DiscountPrice DECIMAL(18, 2),
    CategoryID INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID),
    ModelURL NVARCHAR(255) NOT NULL, -- URL to 3D model file
    ThumbnailURL NVARCHAR(255),
    Quantity INT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    IsCustomizable BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Create indexes for product search and filtering
CREATE INDEX IX_Products_Name ON Products(Name);
CREATE INDEX IX_Products_CategoryID ON Products(CategoryID);
CREATE INDEX IX_Products_Price ON Products(Price);
GO

-- Product Images Table (for additional product images)
CREATE TABLE ProductImages (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    ImageURL NVARCHAR(255) NOT NULL,
    DisplayOrder INT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Product Specifications Table
CREATE TABLE ProductSpecifications (
    SpecificationID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    SpecName NVARCHAR(100) NOT NULL,
    SpecValue NVARCHAR(255) NOT NULL,
    DisplayOrder INT DEFAULT 0
);
GO

-- Saved Products (Favorites) Table
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

-- Create index for faster retrieval of user's saved products
CREATE INDEX IX_SavedProducts_UserID ON SavedProducts(UserID);
GO

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


-- Create index for user's order history
CREATE INDEX IX_Orders_UserID ON Orders(UserID);
GO

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

-- Create index for faster order item retrieval
CREATE INDEX IX_OrderItems_OrderID ON OrderItems(OrderID);
GO

-- Reviews Table
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID) ON DELETE CASCADE,
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR(MAX),
    IsVerifiedPurchase BIT DEFAULT 0,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE(),
    IsApproved BIT DEFAULT 1
);
GO

-- Create indexes for reviews
CREATE INDEX IX_Reviews_ProductID ON Reviews(ProductID);
CREATE INDEX IX_Reviews_UserID ON Reviews(UserID);
GO

-- FAQ Categories Table
CREATE TABLE FAQCategories (
    FAQCategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    DisplayOrder INT DEFAULT 0
);
GO

-- FAQs Table
CREATE TABLE FAQs (
    FAQID INT PRIMARY KEY IDENTITY(1,1),
    FAQCategoryID INT FOREIGN KEY REFERENCES FAQCategories(FAQCategoryID),
    Question NVARCHAR(500) NOT NULL,
    Answer NVARCHAR(MAX) NOT NULL,
    DisplayOrder INT DEFAULT 0,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Support Tickets Table
CREATE TABLE SupportTickets (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Email NVARCHAR(255) NOT NULL,
    Subject NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Open',
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Support Ticket Responses Table
CREATE TABLE TicketResponses (
    ResponseID INT PRIMARY KEY IDENTITY(1,1),
    TicketID INT NOT NULL FOREIGN KEY REFERENCES SupportTickets(TicketID) ON DELETE CASCADE,
    UserID INT FOREIGN KEY REFERENCES Users(UserID), -- Admin who responded
    Message NVARCHAR(MAX) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Customization Requests Table
CREATE TABLE CustomizationRequests (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID),
    RequestDetails NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) DEFAULT 'Pending',
    AdminNotes NVARCHAR(MAX),
    CreatedAt DATETIME DEFAULT GETDATE(),
    UpdatedAt DATETIME DEFAULT GETDATE()
);
GO

-- User Sessions Table (for tracking login sessions)
CREATE TABLE UserSessions (
    SessionID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL FOREIGN KEY REFERENCES Users(UserID) ON DELETE CASCADE,
    Token NVARCHAR(255) NOT NULL,
    IPAddress NVARCHAR(50),
    UserAgent NVARCHAR(500),
    ExpiryDate DATETIME NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE(),
    LastActivityAt DATETIME DEFAULT GETDATE()
);
GO

-- Create index for session token lookup
CREATE INDEX IX_UserSessions_Token ON UserSessions(Token);
GO

-- Audit Log Table (for tracking important system events)
CREATE TABLE AuditLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Action NVARCHAR(100) NOT NULL,
    EntityType NVARCHAR(50), -- e.g., 'Product', 'User', 'Order'
    EntityID INT,
    Details NVARCHAR(MAX),
    IPAddress NVARCHAR(50),
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Create stored procedure for adding a product
CREATE PROCEDURE sp_AddProduct
    @Name NVARCHAR(255),
    @Description NVARCHAR(MAX),
    @Price DECIMAL(18, 2),
    @DiscountPrice DECIMAL(18, 2) = NULL,
    @CategoryID INT,
    @ModelURL NVARCHAR(255),
    @ThumbnailURL NVARCHAR(255) = NULL,
    @Quantity INT,
    @IsCustomizable BIT = 0
AS
BEGIN
    INSERT INTO Products (
        Name, Description, Price, DiscountPrice, CategoryID, 
        ModelURL, ThumbnailURL, Quantity, IsCustomizable
    )
    VALUES (
        @Name, @Description, @Price, @DiscountPrice, @CategoryID,
        @ModelURL, @ThumbnailURL, @Quantity, @IsCustomizable
    );
    
    RETURN SCOPE_IDENTITY();
END;
GO

-- Create stored procedure for user registration
CREATE PROCEDURE sp_RegisterUser
    @Email NVARCHAR(255),
    @PasswordHash NVARCHAR(255),
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @PhoneNumber NVARCHAR(20) = NULL,
    @IsSocialLogin BIT = 0,
    @SocialProvider NVARCHAR(50) = NULL,
    @SocialProviderID NVARCHAR(255) = NULL
AS
BEGIN
    -- Check if email already exists
    IF EXISTS (SELECT 1 FROM Users WHERE Email = @Email)
    BEGIN
        RETURN -1; -- Email already exists
    END
    
    -- Insert new user
    INSERT INTO Users (
        Email, PasswordHash, FirstName, LastName, PhoneNumber,
        RoleID, IsSocialLogin, SocialProvider, SocialProviderID
    )
    VALUES (
        @Email, @PasswordHash, @FirstName, @LastName, @PhoneNumber,
        2, -- Default role ID for Customer
        @IsSocialLogin, @SocialProvider, @SocialProviderID
    );
    
    RETURN SCOPE_IDENTITY();
END;
GO

-- Create stored procedure for saving a product to favorites
CREATE PROCEDURE sp_SaveProduct
    @UserID INT,
    @ProductID INT
AS
BEGIN
    -- Check if already saved
    IF NOT EXISTS (SELECT 1 FROM SavedProducts WHERE UserID = @UserID AND ProductID = @ProductID)
    BEGIN
        INSERT INTO SavedProducts (UserID, ProductID)
        VALUES (@UserID, @ProductID);
        RETURN 1; -- Success
    END
    ELSE
    BEGIN
        RETURN 0; -- Already saved
    END
END;
GO

-- Create stored procedure for removing a product from favorites
CREATE PROCEDURE sp_RemoveSavedProduct
    @UserID INT,
    @ProductID INT
AS
BEGIN
    DELETE FROM SavedProducts 
    WHERE UserID = @UserID AND ProductID = @ProductID;
    
    RETURN @@ROWCOUNT; -- Returns number of rows affected
END;
GO

-- Create stored procedure for adding a product review
CREATE PROCEDURE sp_AddReview
    @ProductID INT,
    @UserID INT,
    @Rating INT,
    @ReviewText NVARCHAR(MAX)
AS
BEGIN
    -- Check if user has already reviewed this product
    IF EXISTS (SELECT 1 FROM Reviews WHERE ProductID = @ProductID AND UserID = @UserID)
    BEGIN
        -- Update existing review
        UPDATE Reviews
        SET Rating = @Rating,
            ReviewText = @ReviewText,
            UpdatedAt = GETDATE()
        WHERE ProductID = @ProductID AND UserID = @UserID;
        
        RETURN 0; -- Updated existing review
    END
    ELSE
    BEGIN
        -- Check if user has purchased the product
        DECLARE @IsVerifiedPurchase BIT = 0;
        
        IF EXISTS (
            SELECT 1 FROM Orders o
            JOIN OrderItems oi ON o.OrderID = oi.OrderID
            WHERE o.UserID = @UserID AND oi.ProductID = @ProductID
        )
        BEGIN
            SET @IsVerifiedPurchase = 1;
        END
        
        -- Insert new review
        INSERT INTO Reviews (ProductID, UserID, Rating, ReviewText, IsVerifiedPurchase)
        VALUES (@ProductID, @UserID, @Rating, @ReviewText, @IsVerifiedPurchase);
        
        RETURN 1; -- Added new review
    END
END;
GO

-- Create stored procedure for searching products
CREATE PROCEDURE sp_SearchProducts
    @SearchTerm NVARCHAR(255) = NULL,
    @CategoryID INT = NULL,
    @MinPrice DECIMAL(18, 2) = NULL,
    @MaxPrice DECIMAL(18, 2) = NULL,
    @SortBy NVARCHAR(50) = 'Name', -- Name, PriceLowToHigh, PriceHighToLow, Newest
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        p.ProductID, p.Name, p.Description, p.Price, p.DiscountPrice,
        p.ThumbnailURL, p.ModelURL, c.Name AS CategoryName,
        (SELECT COUNT(*) FROM Reviews r WHERE r.ProductID = p.ProductID) AS ReviewCount,
        (SELECT AVG(CAST(r.Rating AS FLOAT)) FROM Reviews r WHERE r.ProductID = p.ProductID) AS AverageRating
    FROM 
        Products p
    INNER JOIN 
        Categories c ON p.CategoryID = c.CategoryID
    WHERE 
        p.IsActive = 1
        AND (@SearchTerm IS NULL OR p.Name LIKE '%' + @SearchTerm + '%' OR p.Description LIKE '%' + @SearchTerm + '%')
        AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID OR c.ParentCategoryID = @CategoryID)
        AND (@MinPrice IS NULL OR p.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR p.Price <= @MaxPrice)
    ORDER BY
        CASE 
            WHEN @SortBy = 'Name' THEN p.Name
        END ASC,
        CASE 
            WHEN @SortBy = 'PriceLowToHigh' THEN p.Price
        END ASC,
        CASE 
            WHEN @SortBy = 'PriceHighToLow' THEN p.Price
        END DESC,
        CASE 
            WHEN @SortBy = 'Newest' THEN p.CreatedAt
        END DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
    
    -- Return total count for pagination
    SELECT COUNT(*) AS TotalCount
    FROM Products p
    INNER JOIN Categories c ON p.CategoryID = c.CategoryID
    WHERE 
        p.IsActive = 1
        AND (@SearchTerm IS NULL OR p.Name LIKE '%' + @SearchTerm + '%' OR p.Description LIKE '%' + @SearchTerm + '%')
        AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID OR c.ParentCategoryID = @CategoryID)
        AND (@MinPrice IS NULL OR p.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR p.Price <= @MaxPrice);
END;
GO

-- Create stored procedure for creating an order
CREATE PROCEDURE sp_CreateOrder
    @UserID INT,
    @TotalAmount DECIMAL(18, 2),
    @ShippingAddress NVARCHAR(255),
    @ShippingCity NVARCHAR(100),
    @ShippingState NVARCHAR(100),
    @ShippingPostalCode NVARCHAR(20),
    @ShippingCountry NVARCHAR(100),
    @PaymentMethod NVARCHAR(50),
    @Notes NVARCHAR(MAX) = NULL
AS
BEGIN
    -- Insert order
    INSERT INTO Orders (
        UserID, TotalAmount, ShippingAddress, ShippingCity, 
        ShippingState, ShippingPostalCode, ShippingCountry, 
        PaymentMethod, Notes
    )
    VALUES (
        @UserID, @TotalAmount, @ShippingAddress, @ShippingCity,
        @ShippingState, @ShippingPostalCode, @ShippingCountry,
        @PaymentMethod, @Notes
    );
    
    DECLARE @OrderID INT = SCOPE_IDENTITY();
    RETURN @OrderID;
END;
GO

-- Create stored procedure for adding order items
CREATE PROCEDURE sp_AddOrderItem
    @OrderID INT,
    @ProductID INT,
    @Quantity INT,
    @UnitPrice DECIMAL(18, 2),
    @CustomizationDetails NVARCHAR(MAX) = NULL
AS
BEGIN
    -- Insert order item
    INSERT INTO OrderItems (
        OrderID, ProductID, Quantity, UnitPrice, CustomizationDetails
    )
    VALUES (
        @OrderID, @ProductID, @Quantity, @UnitPrice, @CustomizationDetails
    );
    
    -- Update product quantity
    UPDATE Products
    SET Quantity = Quantity - @Quantity
    WHERE ProductID = @ProductID;
    
    RETURN SCOPE_IDENTITY();
END;
GO

-- Create stored procedure for getting user's order history
CREATE PROCEDURE sp_GetUserOrderHistory
    @UserID INT
AS
BEGIN
    SELECT 
        o.OrderID, o.OrderDate, o.TotalAmount, o.OrderStatus, o.PaymentStatus,
        COUNT(oi.OrderItemID) AS TotalItems
    FROM 
        Orders o
    LEFT JOIN 
        OrderItems oi ON o.OrderID = oi.OrderID
    WHERE 
        o.UserID = @UserID
    GROUP BY 
        o.OrderID, o.OrderDate, o.TotalAmount, o.OrderStatus, o.PaymentStatus
    ORDER BY 
        o.OrderDate DESC;
END;
GO

-- Create stored procedure for getting order details
CREATE PROCEDURE sp_GetOrderDetails
    @OrderID INT
AS
BEGIN
    -- Get order information
    SELECT 
        o.OrderID, o.OrderDate, o.TotalAmount, o.OrderStatus, o.PaymentStatus,
        o.ShippingAddress, o.ShippingCity, o.ShippingState, 
        o.ShippingPostalCode, o.ShippingCountry, o.PaymentMethod,
        o.TrackingNumber, o.Notes,
        u.UserID, u.FirstName, u.LastName, u.Email, u.PhoneNumber
    FROM 
        Orders o
    INNER JOIN 
        Users u ON o.UserID = u.UserID
    WHERE 
        o.OrderID = @OrderID;
    
    -- Get order items
    SELECT 
        oi.OrderItemID, oi.ProductID, p.Name AS ProductName, 
        oi.Quantity, oi.UnitPrice, oi.CustomizationDetails,
        p.ThumbnailURL, p.ModelURL
    FROM 
        OrderItems oi
    INNER JOIN 
        Products p ON oi.ProductID = p.ProductID
    WHERE 
        oi.OrderID = @OrderID;
END;
GO

-- Create stored procedure for submitting a support ticket
CREATE PROCEDURE sp_SubmitSupportTicket
    @UserID INT = NULL,
    @Email NVARCHAR(255),
    @Subject NVARCHAR(255),
    @Message NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO SupportTickets (UserID, Email, Subject, Message)
    VALUES (@UserID, @Email, @Subject, @Message);
    
    RETURN SCOPE_IDENTITY();
END;
GO

-- Create stored procedure for submitting a customization request
CREATE PROCEDURE sp_SubmitCustomizationRequest
    @ProductID INT,
    @UserID INT,
    @RequestDetails NVARCHAR(MAX),
    @OrderID INT = NULL
AS
BEGIN
    INSERT INTO CustomizationRequests (
        OrderID, ProductID, UserID, RequestDetails
    )
    VALUES (
        @OrderID, @ProductID, @UserID, @RequestDetails
    );
    
    RETURN SCOPE_IDENTITY();
END;
GO

-- Create view for product details with category and review info
CREATE VIEW vw_ProductDetails AS
SELECT 
    p.ProductID, p.Name, p.Description, p.Price, p.DiscountPrice,
    p.ModelURL, p.ThumbnailURL, p.Quantity, p.IsCustomizable,
    c.CategoryID, c.Name AS CategoryName, 
    pc.CategoryID AS ParentCategoryID, pc.Name AS ParentCategoryName,
    COUNT(DISTINCT r.ReviewID) AS ReviewCount,
    AVG(CAST(r.Rating AS FLOAT)) AS AverageRating
FROM 
    Products p
INNER JOIN 
    Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN 
    Categories pc ON c.ParentCategoryID = pc.CategoryID
LEFT JOIN 
    Reviews r ON p.ProductID = r.ProductID
WHERE 
    p.IsActive = 1
GROUP BY 
    p.ProductID, p.Name, p.Description, p.Price, p.DiscountPrice,
    p.ModelURL, p.ThumbnailURL, p.Quantity, p.IsCustomizable,
    c.CategoryID, c.Name, pc.CategoryID, pc.Name;
GO

-- Create view for user profile with saved products count
CREATE VIEW vw_UserProfile AS
SELECT 
    u.UserID, u.Email, u.FirstName, u.LastName, u.PhoneNumber,
    u.Address, u.City, u.State, u.PostalCode, u.Country,
    r.RoleName,
    COUNT(DISTINCT sp.SavedProductID) AS SavedProductsCount,
    COUNT(DISTINCT o.OrderID) AS OrderCount,
    MAX(o.OrderDate) AS LastOrderDate
FROM 
    Users u
INNER JOIN 
    Roles r ON u.RoleID = r.RoleID
LEFT JOIN 
    SavedProducts sp ON u.UserID = sp.UserID
LEFT JOIN 
    Orders o ON u.UserID = o.UserID
WHERE 
    u.IsActive = 1
GROUP BY 
    u.UserID, u.Email, u.FirstName, u.LastName, u.PhoneNumber,
    u.Address, u.City, u.State, u.PostalCode, u.Country,
    r.RoleName;
GO

-- Create trigger to update product UpdatedAt timestamp
CREATE TRIGGER trg_UpdateProductTimestamp
ON Products
AFTER UPDATE
AS
BEGIN
    UPDATE Products
    SET UpdatedAt = GETDATE()
    FROM Products p
    INNER JOIN inserted i ON p.ProductID = i.ProductID;
END;
GO

-- Create trigger to update user UpdatedAt timestamp
CREATE TRIGGER trg_UpdateUserTimestamp
ON Users
AFTER UPDATE
AS
BEGIN
    UPDATE Users
    SET UpdatedAt = GETDATE()
    FROM Users u
    INNER JOIN inserted i ON u.UserID = i.UserID;
END;
GO

-- Create trigger to log product changes
CREATE TRIGGER trg_LogProductChanges
ON Products
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @Action NVARCHAR(10);
    
    -- Determine the action
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
        SET @Action = 'UPDATE';
    ELSE IF EXISTS (SELECT * FROM inserted)
        SET @Action = 'INSERT';
    ELSE
        SET @Action = 'DELETE';
    
    -- Log the action
    IF @Action = 'INSERT'
    BEGIN
        INSERT INTO AuditLogs (Action, EntityType, EntityID, Details)
        SELECT 'INSERT', 'Product', ProductID, 'Product added: ' + Name
        FROM inserted;
    END
    ELSE IF @Action = 'UPDATE'
    BEGIN
        INSERT INTO AuditLogs (Action, EntityType, EntityID, Details)
        SELECT 'UPDATE', 'Product', i.ProductID, 
               'Product updated: ' + i.Name + 
               CASE WHEN i.Price <> d.Price 
                    THEN ', Price changed from ' + CAST(d.Price AS NVARCHAR) + ' to ' + CAST(i.Price AS NVARCHAR)
                    ELSE ''
               END +
               CASE WHEN i.Quantity <> d.Quantity 
                    THEN ', Quantity changed from ' + CAST(d.Quantity AS NVARCHAR) + ' to ' + CAST(i.Quantity AS NVARCHAR)
                    ELSE ''
               END
        FROM inserted i
        JOIN deleted d ON i.ProductID = d.ProductID;
    END
    ELSE -- DELETE
    BEGIN
        INSERT INTO AuditLogs (Action, EntityType, EntityID, Details)
        SELECT 'DELETE', 'Product', ProductID, 'Product deleted: ' + Name
        FROM deleted;
    END
END;
GO

-- Create trigger to log order status changes
CREATE TRIGGER trg_LogOrderStatusChanges
ON Orders
AFTER UPDATE
AS
BEGIN
    IF UPDATE(OrderStatus) OR UPDATE(PaymentStatus)
    BEGIN
        INSERT INTO AuditLogs (Action, EntityType, EntityID, Details, UserID)
        SELECT 
            'UPDATE', 'Order', i.OrderID, 
            'Order status changed: ' + 
            CASE 
                WHEN d.OrderStatus <> i.OrderStatus 
                THEN 'Order status from ' + d.OrderStatus + ' to ' + i.OrderStatus
                ELSE ''
            END +
            CASE 
                WHEN d.PaymentStatus <> i.PaymentStatus 
                THEN CASE WHEN d.OrderStatus <> i.OrderStatus THEN ', ' ELSE '' END +
                     'Payment status from ' + d.PaymentStatus + ' to ' + i.PaymentStatus
                ELSE ''
            END,
            i.UserID
        FROM inserted i
        JOIN deleted d ON i.OrderID = d.OrderID
        WHERE d.OrderStatus <> i.OrderStatus OR d.PaymentStatus <> i.PaymentStatus;
    END
END;
GO
