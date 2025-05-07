CREATE PROCEDURE sp_RegisterUser
    @Email NVARCHAR(255),
    @PasswordHash NVARCHAR(255),
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @PhoneNumber NVARCHAR(20) = NULL,
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
        RoleID
    )
    VALUES (
        @Email, @PasswordHash, @FirstName, @LastName, @PhoneNumber,
        2 -- Default role ID for Customer
    );
    
    RETURN 1;
END;
GO



CREATE PROCEDURE sp_RemoveSavedProduct
    @UserID INT,
    @ProductID INT
AS
BEGIN
    DELETE FROM SavedProducts 
    WHERE UserID = @UserID AND ProductID = @ProductID;
    
    RETURN 1; -- Returns number of rows affected
END;
GO


CREATE PROCEDURE sp_AddProduct
    @Name NVARCHAR(255),
    @Description NVARCHAR(MAX),
    @Price DECIMAL(18, 2),
    @CategoryID INT,
    @ModelURL NVARCHAR(255),
    @ThumbnailURL NVARCHAR(255) = NULL,
    @Quantity INT,
AS
BEGIN
    INSERT INTO Products (
        Name, Description, Price, CategoryID, 
        ModelURL, ThumbnailURL, Quantity
    )
    VALUES (
        @Name, @Description, @Price, @DiscountPrice, @CategoryID,
        @ModelURL, @ThumbnailURL, @Quantity
    );
    
    RETURN 1;
END;
GO


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
