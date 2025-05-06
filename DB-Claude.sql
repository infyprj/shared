-- Database Creation
CREATE DATABASE ThreeDProductVisualization;
GO

USE ThreeDProductVisualization;
GO

-- Users Table - Stores user account information
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
    RegistrationDate DATETIME NOT NULL DEFAULT GETDATE(),
    LastLoginDate DATETIME,
    IsAdmin BIT NOT NULL DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,
    SocialLoginProvider NVARCHAR(50) NULL,
    SocialLoginID NVARCHAR(255) NULL,
    CONSTRAINT UQ_Social_Login UNIQUE (SocialLoginProvider, SocialLoginID)
);
GO

-- Categories Table - Product category hierarchy
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(500),
    ParentCategoryID INT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Categories_ParentCategory FOREIGN KEY (ParentCategoryID) REFERENCES Categories(CategoryID)
);
GO

-- Products Table - Product information including 3D model references
CREATE TABLE Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(18, 2) NOT NULL,
    DiscountPrice DECIMAL(18, 2) NULL,
    ModelURL NVARCHAR(1000) NOT NULL, -- URL to 3D model in Azure Storage
    ThumbnailURL NVARCHAR(1000) NULL, -- URL to thumbnail image
    CategoryID INT NOT NULL,
    StockQuantity INT NOT NULL DEFAULT 0,
    IsAvailable BIT NOT NULL DEFAULT 1,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE(),
    SKU NVARCHAR(50) UNIQUE,
    Weight DECIMAL(10, 2) NULL,
    Dimensions NVARCHAR(100) NULL, -- Format: LxWxH
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
GO

-- Product Images - Additional product images (apart from 3D model)
CREATE TABLE ProductImages (
    ImageID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    ImageURL NVARCHAR(1000) NOT NULL,
    IsPrimary BIT NOT NULL DEFAULT 0,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_ProductImages_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);
GO

-- User Favorites - Products saved by users
CREATE TABLE UserFavorites (
    FavoriteID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    DateAdded DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_UserFavorites_Users FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    CONSTRAINT FK_UserFavorites_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE,
    CONSTRAINT UQ_UserFavorites UNIQUE (UserID, ProductID)
);
GO

-- Product Reviews - User reviews and ratings
CREATE TABLE ProductReviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    ProductID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewText NVARCHAR(MAX),
    ReviewDate DATETIME NOT NULL DEFAULT GETDATE(),
    IsApproved BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_ProductReviews_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT FK_ProductReviews_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);
GO

-- Orders - Order header information
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NOT NULL,
    OrderDate DATETIME NOT NULL DEFAULT GETDATE(),
    TotalAmount DECIMAL(18, 2) NOT NULL,
    ShippingAddress NVARCHAR(255),
    ShippingCity NVARCHAR(100),
    ShippingState NVARCHAR(100),
    ShippingPostalCode NVARCHAR(20),
    ShippingCountry NVARCHAR(100),
    OrderStatus NVARCHAR(50) NOT NULL DEFAULT 'Pending', -- Pending, Processing, Shipped, Delivered, Cancelled
    PaymentStatus NVARCHAR(50) NOT NULL DEFAULT 'Unpaid', -- Unpaid, Paid, Refunded
    PaymentMethod NVARCHAR(50),
    TrackingNumber NVARCHAR(100),
    Notes NVARCHAR(MAX),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- Order Items - Individual items within an order
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18, 2) NOT NULL,
    Subtotal DECIMAL(18, 2) NOT NULL,
    CustomizationDetails NVARCHAR(MAX) NULL,
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
GO

-- Product Specifications - Technical details for products
CREATE TABLE ProductSpecifications (
    SpecificationID INT PRIMARY KEY IDENTITY(1,1),
    ProductID INT NOT NULL,
    SpecName NVARCHAR(100) NOT NULL,
    SpecValue NVARCHAR(255) NOT NULL,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CONSTRAINT FK_ProductSpecifications_Products FOREIGN KEY (ProductID) REFERENCES Products(ProductID) ON DELETE CASCADE
);
GO

-- FAQ Table - Frequently asked questions
CREATE TABLE FAQs (
    FAQID INT PRIMARY KEY IDENTITY(1,1),
    Question NVARCHAR(500) NOT NULL,
    Answer NVARCHAR(MAX) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    DisplayOrder INT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    ModifiedDate DATETIME NOT NULL DEFAULT GETDATE()
);
GO

-- Help Requests - Customer support tickets
CREATE TABLE HelpRequests (
    RequestID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT NULL, -- NULL for guest users
    Name NVARCHAR(100) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    Subject NVARCHAR(255) NOT NULL,
    Message NVARCHAR(MAX) NOT NULL,
    Status NVARCHAR(50) NOT NULL DEFAULT 'Open', -- Open, InProgress, Resolved, Closed
    RequestDate DATETIME NOT NULL DEFAULT GETDATE(),
    ResolvedDate DATETIME NULL,
    Response NVARCHAR(MAX) NULL,
    CONSTRAINT FK_HelpRequests_Users FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
GO

-- Create a search index for product search functionality
CREATE FULLTEXT CATALOG ProductSearchCatalog;
GO

CREATE FULLTEXT INDEX ON Products(Name, Description) 
KEY INDEX PK_Products_ProductID
ON ProductSearchCatalog 
WITH CHANGE_TRACKING AUTO;
GO

-- Create indexes for performance optimization
CREATE INDEX IX_Products_CategoryID ON Products(CategoryID);
CREATE INDEX IX_Products_IsAvailable ON Products(IsAvailable);
CREATE INDEX IX_OrderItems_ProductID ON OrderItems(ProductID);
CREATE INDEX IX_ProductReviews_ProductID ON ProductReviews(ProductID);
CREATE INDEX IX_UserFavorites_UserID ON UserFavorites(UserID);
CREATE INDEX IX_Orders_UserID ON Orders(UserID);
CREATE INDEX IX_Orders_OrderStatus ON Orders(OrderStatus);
GO

-- Create a view for product listings with category information
CREATE VIEW vw_ProductListings AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.Description AS ProductDescription,
    p.Price,
    p.DiscountPrice,
    p.ModelURL,
    p.ThumbnailURL,
    p.StockQuantity,
    p.IsAvailable,
    c.CategoryID,
    c.Name AS CategoryName,
    pc.CategoryID AS ParentCategoryID,
    pc.Name AS ParentCategoryName,
    (SELECT AVG(CAST(Rating AS FLOAT)) FROM ProductReviews WHERE ProductID = p.ProductID) AS AverageRating,
    (SELECT COUNT(*) FROM ProductReviews WHERE ProductID = p.ProductID) AS ReviewCount
FROM 
    Products p
INNER JOIN 
    Categories c ON p.CategoryID = c.CategoryID
LEFT JOIN 
    Categories pc ON c.ParentCategoryID = pc.CategoryID
WHERE 
    p.IsAvailable = 1;
GO

-- Create a view for user order history
CREATE VIEW vw_UserOrderHistory AS
SELECT 
    o.OrderID,
    o.UserID,
    o.OrderDate,
    o.TotalAmount,
    o.OrderStatus,
    o.PaymentStatus,
    COUNT(oi.OrderItemID) AS ItemCount,
    STRING_AGG(p.Name, ', ') AS ProductsList
FROM 
    Orders o
INNER JOIN 
    OrderItems oi ON o.OrderID = oi.OrderID
INNER JOIN 
    Products p ON oi.ProductID = p.ProductID
GROUP BY 
    o.OrderID, o.UserID, o.OrderDate, o.TotalAmount, o.OrderStatus, o.PaymentStatus;
GO

-- Create stored procedure to search products with filtering
CREATE PROCEDURE sp_SearchProducts
    @SearchQuery NVARCHAR(255) = NULL,
    @CategoryID INT = NULL,
    @MinPrice DECIMAL(18, 2) = NULL,
    @MaxPrice DECIMAL(18, 2) = NULL,
    @SortBy NVARCHAR(50) = 'Name', -- Name, PriceLowToHigh, PriceHighToLow, Newest, MostPopular
    @PageNumber INT = 1,
    @PageSize INT = 20
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    
    SELECT 
        p.ProductID,
        p.Name,
        p.Description,
        p.Price,
        p.DiscountPrice,
        p.ModelURL,
        p.ThumbnailURL,
        p.StockQuantity,
        c.Name AS CategoryName,
        (SELECT AVG(CAST(Rating AS FLOAT)) FROM ProductReviews WHERE ProductID = p.ProductID) AS AverageRating,
        (SELECT COUNT(*) FROM ProductReviews WHERE ProductID = p.ProductID) AS ReviewCount,
        COUNT(*) OVER() AS TotalCount
    FROM 
        Products p
    INNER JOIN 
        Categories c ON p.CategoryID = c.CategoryID
    WHERE 
        p.IsAvailable = 1
        AND (@SearchQuery IS NULL OR CONTAINS((p.Name, p.Description), @SearchQuery))
        AND (@CategoryID IS NULL OR p.CategoryID = @CategoryID OR c.ParentCategoryID = @CategoryID)
        AND (@MinPrice IS NULL OR p.Price >= @MinPrice)
        AND (@MaxPrice IS NULL OR p.Price <= @MaxPrice)
    ORDER BY
        CASE WHEN @SortBy = 'Name' THEN p.Name END ASC,
        CASE WHEN @SortBy = 'PriceLowToHigh' THEN p.Price END ASC,
        CASE WHEN @SortBy = 'PriceHighToLow' THEN p.Price END DESC,
        CASE WHEN @SortBy = 'Newest' THEN p.CreatedDate END DESC,
        CASE WHEN @SortBy = 'MostPopular' THEN 
            (SELECT COUNT(*) FROM OrderItems oi WHERE oi.ProductID = p.ProductID) 
        END DESC
    OFFSET @Offset ROWS
    FETCH NEXT @PageSize ROWS ONLY;
END;
GO

-- Create stored procedure to get user favorites with product details
CREATE PROCEDURE sp_GetUserFavorites
    @UserID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        f.FavoriteID,
        f.UserID,
        f.ProductID,
        f.DateAdded,
        p.Name AS ProductName,
        p.Description,
        p.Price,
        p.DiscountPrice,
        p.ModelURL,
        p.ThumbnailURL,
        c.Name AS CategoryName
    FROM 
        UserFavorites f
    INNER JOIN 
        Products p ON f.ProductID = p.ProductID
    INNER JOIN 
        Categories c ON p.CategoryID = c.CategoryID
    WHERE 
        f.UserID = @UserID
    ORDER BY 
        f.DateAdded DESC;
END;
GO
