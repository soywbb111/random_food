-- 1. Location
CREATE TABLE dbo.locations (
    location_id      UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    location_name    NVARCHAR(200)    NOT NULL,
    created_at       DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at       DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_locations PRIMARY KEY (location_id)
);

-- 2. User (password uses bcrypt -> 60 ký tự)
CREATE TABLE dbo.users (
    user_id          UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    email            NVARCHAR(320)    NOT NULL,           -- lưu lowercase
    email_verified_at DATETIME2(3)    NULL,
    password_hash    CHAR(60)         NOT NULL,           -- bcrypt hash
    first_name       NVARCHAR(100)    NOT NULL,
    last_name        NVARCHAR(100)    NOT NULL,
    sex              VARCHAR(10)      NULL CHECK (sex IN ('male','female','other')),
    location_id      UNIQUEIDENTIFIER NULL,
    created_at       DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at       DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_users PRIMARY KEY (user_id),
    CONSTRAINT UQ_users_email UNIQUE (email),
    CONSTRAINT FK_users_location FOREIGN KEY (location_id) REFERENCES dbo.locations(location_id)
);

-- 3. Foods
CREATE TABLE dbo.foods (
    food_id          UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    food_name        NVARCHAR(200)    NOT NULL,
    food_description NVARCHAR(1000)   NULL,
    image_url        NVARCHAR(500)    NULL,
    created_at       DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at       DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_foods PRIMARY KEY (food_id)
);

-- 4. Flavor
CREATE TABLE dbo.flavors (
    flavor_id        UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
    flavor_name      NVARCHAR(100)    NOT NULL,           -- ví dụ: spicy, sweet, sour, salty, bitter, umami, hot, cold
    CONSTRAINT PK_flavors PRIMARY KEY (flavor_id),
    CONSTRAINT UQ_flavors_name UNIQUE (flavor_name)
);

-- 5. Relationship n-n flavors - foods
CREATE TABLE dbo.food_flavors (
    food_id          UNIQUEIDENTIFIER NOT NULL,
    flavor_id        UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT PK_food_flavors PRIMARY KEY (food_id, flavor_id),
    CONSTRAINT FK_ff_food   FOREIGN KEY (food_id)  REFERENCES dbo.foods(food_id),
    CONSTRAINT FK_ff_flavor FOREIGN KEY (flavor_id) REFERENCES dbo.flavors(flavor_id)
);

-- 6. rated_flavors
CREATE TABLE dbo.user_flavor_prefs (
    user_id          UNIQUEIDENTIFIER NOT NULL,
    flavor_id        UNIQUEIDENTIFIER NOT NULL,
    score            DECIMAL(4,2)     NOT NULL CHECK (score BETWEEN 0 AND 5),
    answered_at      DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_user_flavor_prefs PRIMARY KEY (user_id, flavor_id),
    CONSTRAINT FK_ufp_user   FOREIGN KEY (user_id)  REFERENCES dbo.users(user_id),
    CONSTRAINT FK_ufp_flavor FOREIGN KEY (flavor_id) REFERENCES dbo.flavors(flavor_id)
);

-- 7. Rated_foods
CREATE TABLE dbo.ratings (
    user_id          UNIQUEIDENTIFIER NOT NULL,
    food_id          UNIQUEIDENTIFIER NOT NULL,
    score            INT              NOT NULL CHECK (score BETWEEN 1 AND 5),
    rated_at         DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_ratings PRIMARY KEY (user_id, food_id),
    CONSTRAINT FK_r_user FOREIGN KEY (user_id) REFERENCES dbo.users(user_id),
    CONSTRAINT FK_r_food FOREIGN KEY (food_id)  REFERENCES dbo.foods(food_id)
);
-- 8. User likes foods
CREATE TABLE dbo.user_food_likes (
    user_id  UNIQUEIDENTIFIER NOT NULL,
    food_id  UNIQUEIDENTIFIER NOT NULL,
    liked_at DATETIME2(3)     NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT PK_user_food_likes PRIMARY KEY (user_id, food_id),
    CONSTRAINT FK_ufl_user FOREIGN KEY (user_id) REFERENCES dbo.users(user_id),
    CONSTRAINT FK_ufl_food FOREIGN KEY (food_id) REFERENCES dbo.foods(food_id)
);
--search on foods_name
CREATE INDEX IX_foods_name ON dbo.foods(food_name);
--search on flavors_name
CREATE INDEX IX_flavors_name ON dbo.flavors(flavor_name);
-- Tim user theo email (da unique), bo sung index cho location neu hay loc theo dia diem
CREATE INDEX IX_users_location ON dbo.users(location_id);

--Like--(just record one time)
GO
CREATE OR ALTER PROCEDURE dbo.sp_user_like_food
    @user_id UNIQUEIDENTIFIER,
    @food_id UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (
        SELECT 1 FROM dbo.user_food_likes
        WHERE user_id = @user_id AND food_id = @food_id
    )
    BEGIN
        INSERT INTO dbo.user_food_likes(user_id, food_id) VALUES (@user_id, @food_id);
    END
END
GO
-- foods are being like the most by users
CREATE INDEX IX_ufl_food ON dbo.user_food_likes(food_id);
-- foods that user like lately
CREATE INDEX IX_ufl_user_likedat ON dbo.user_food_likes(user_id, liked_at DESC);

