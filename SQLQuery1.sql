USE master;
GO

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'TouristAgency1')
BEGIN
    CREATE DATABASE TouristAgency1;
END
GO

USE TouristAgency1;
GO

-- ������� ��� �������������� �����
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'AdditionalServices')
BEGIN
    CREATE TABLE [dbo].[AdditionalServices](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Name] [nvarchar](50) NOT NULL,
        [Description] [nvarchar](200) NOT NULL,
        [Price] [money] NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END

-- ������� ��� �����������
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Employees')
BEGIN
    CREATE TABLE [dbo].[Employees](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [FIO] [nvarchar](150) NOT NULL,
        [JobTitle] [nvarchar](50) NOT NULL,
        [Age] [int] NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END

-- ������� ��� ����� ������
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'TypesOfRecreation')
BEGIN
    CREATE TABLE [dbo].[TypesOfRecreation](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Name] [nvarchar](50) NOT NULL,
        [Description] [nvarchar](100) NOT NULL,
        [Restrictions] [nvarchar](50) NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END

-- ������� ��� ��������
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Clients')
BEGIN
    CREATE TABLE [dbo].[Clients](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [FIO] [nvarchar](150) NOT NULL,
        [DateOfBirth] [date] NOT NULL,
        [Sex] [nvarchar](50) NOT NULL,
        [Address] [nvarchar](100) NOT NULL,
        [Series] [nvarchar](50) NOT NULL,
        [Number] [bigint] NOT NULL,
        [Discount] [bigint] NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END

-- ������� ��� ������
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Hotels')
BEGIN
    CREATE TABLE [dbo].[Hotels](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [Name] [nvarchar](50) NOT NULL,
        [Country] [nvarchar](50) NOT NULL,
        [City] [nvarchar](50) NOT NULL,
        [Address] [nvarchar](100) NOT NULL,
        [Phone] [nvarchar](20) NOT NULL,
        [Stars] [int] NOT NULL,
        [TheContactPerson] [nvarchar](100) NOT NULL,
        [Photo] [image] NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    );
END


-- ������� ��� ��������
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'Vouchers')
BEGIN
    CREATE TABLE [dbo].[Vouchers](
        [Id] [int] IDENTITY(1,1) NOT NULL,
        [StartDate] [date] NOT NULL,
        [ExpirationDate] [date] NOT NULL,
        [HotelId] [int] NOT NULL,
        [TypeOfRecreationId] [int] NOT NULL,
        [AdditionalServiceId] [int] NOT NULL,
        [ClientId] [int] NOT NULL,
        [EmployessId] [int] NOT NULL,
        [Reservation] [bit] NOT NULL,
        [Payment] [bit] NOT NULL,
        PRIMARY KEY CLUSTERED ([Id] ASC)
    );

    ALTER TABLE [dbo].[Vouchers]  WITH CHECK ADD  CONSTRAINT [FK_Vouchers_AdditionalServices] FOREIGN KEY([AdditionalServiceId])
    REFERENCES [dbo].[AdditionalServices] ([Id]);

    ALTER TABLE [dbo].[Vouchers]  WITH CHECK ADD  CONSTRAINT [FK_Vouchers_Clients] FOREIGN KEY([ClientId])
    REFERENCES [dbo].[Clients] ([Id]);

    ALTER TABLE [dbo].[Vouchers]  WITH CHECK ADD  CONSTRAINT [FK_Vouchers_Employees] FOREIGN KEY([EmployessId])
    REFERENCES [dbo].[Employees] ([Id]);

    ALTER TABLE [dbo].[Vouchers]  WITH CHECK ADD  CONSTRAINT [FK_Vouchers_Hotels] FOREIGN KEY([HotelId])
    REFERENCES [dbo].[Hotels] ([Id]);

    ALTER TABLE [dbo].[Vouchers]  WITH CHECK ADD  CONSTRAINT [FK_Vouchers_TypesOfRecreation] FOREIGN KEY([TypeOfRecreationId])
    REFERENCES [dbo].[TypesOfRecreation] ([Id]);
END

-- ���������, ����� �� ������� Hotels
IF NOT EXISTS (SELECT * FROM [dbo].[Hotels])
BEGIN
    -- ��������� ������� 50 ��������� ������
    DECLARE @HotelIndex INT;
    SET @HotelIndex = 1;

    WHILE @HotelIndex <= 50
    BEGIN
        INSERT INTO [dbo].[Hotels] ([Name], [Country], [City], [Address], [Phone], [Stars], [TheContactPerson], [Photo])
        VALUES (
            '����� ' + CAST(@HotelIndex AS NVARCHAR(10)), -- ���������� �������� �����
            '������ ' + CAST(@HotelIndex AS NVARCHAR(10)), -- ���������� ������
            '����� ' + CAST(@HotelIndex AS NVARCHAR(10)), -- ���������� �����
            '��. ����� ' + CAST(@HotelIndex AS NVARCHAR(10)) + ', �. ' + CAST(@HotelIndex AS NVARCHAR(10)), -- ���������� �����
            '1234567890' + CAST(@HotelIndex AS NVARCHAR(10)), -- ���������� �������
            @HotelIndex % 5 + 1, -- ������� ����� (������)
            '���������� ���� ' + CAST(@HotelIndex AS NVARCHAR(10)), -- ���������� ���������� ����
            0x -- ������ ����������� (��� ������� Photo)
        );

        SET @HotelIndex = @HotelIndex + 1;
    END
END

-- ���������, ����� �� ������� AdditionalServices
IF NOT EXISTS (SELECT * FROM [dbo].[AdditionalServices])
BEGIN
    
    -- ���������, ����� �� ������� AdditionalServices
    IF (SELECT COUNT(*) FROM [dbo].[AdditionalServices]) = 0
    BEGIN
        -- ��������� ������� 50 ��������� ������
        INSERT INTO [dbo].[AdditionalServices] ([Name], [Description], [Price])
        VALUES
            ('������ 1', '�������� ������ 1', 10.99),
        ('������ 2', '�������� ������ 2', 25.50),
        ('������ 3', '�������� ������ 3', 5.75),
        ('������ 4', '�������� ������ 4', 30.00),
        ('������ 5', '�������� ������ 5', 15.25),
        ('������ 6', '�������� ������ 6', 12.99),
        ('������ 7', '�������� ������ 7', 8.50),
        ('������ 8', '�������� ������ 8', 40.00),
        ('������ 9', '�������� ������ 9', 18.75),
        ('������ 10', '�������� ������ 10', 22.50),
        ('������ 11', '�������� ������ 11', 13.99),
        ('������ 12', '�������� ������ 12', 7.25),
        ('������ 13', '�������� ������ 13', 9.99),
        ('������ 14', '�������� ������ 14', 11.50),
        ('������ 15', '�������� ������ 15', 35.00),
        ('������ 16', '�������� ������ 16', 28.75),
        ('������ 17', '�������� ������ 17', 17.50),
        ('������ 18', '�������� ������ 18', 21.99),
        ('������ 19', '�������� ������ 19', 6.25),
        ('������ 20', '�������� ������ 20', 14.50),
        ('������ 21', '�������� ������ 21', 31.00),
        ('������ 22', '�������� ������ 22', 19.75),
        ('������ 23', '�������� ������ 23', 27.99),
        ('������ 24', '�������� ������ 24', 23.50),
        ('������ 25', '�������� ������ 25', 20.25),
        ('������ 26', '�������� ������ 26', 45.00),
        ('������ 27', '�������� ������ 27', 33.75),
        ('������ 28', '�������� ������ 28', 12.50),
        ('������ 29', '�������� ������ 29', 15.99),
        ('������ 30', '�������� ������ 30', 8.25),
        ('������ 31', '�������� ������ 31', 24.50),
        ('������ 32', '�������� ������ 32', 29.00),
        ('������ 33', '�������� ������ 33', 9.75),
        ('������ 34', '�������� ������ 34', 10.99),
        ('������ 35', '�������� ������ 35', 22.50),
        ('������ 36', '�������� ������ 36', 13.25),
        ('������ 37', '�������� ������ 37', 16.50),
        ('������ 38', '�������� ������ 38', 32.00),
        ('������ 39', '�������� ������ 39', 18.75),
        ('������ 40', '�������� ������ 40', 25.99),
        ('������ 41', '�������� ������ 41', 7.25),
        ('������ 42', '�������� ������ 42', 11.50),
        ('������ 43', '�������� ������ 43', 35.00),
        ('������ 44', '�������� ������ 44', 28.75),
        ('������ 45', '�������� ������ 45', 17.50),
        ('������ 46', '�������� ������ 46', 21.99),
        ('������ 47', '�������� ������ 47', 6.25),
        ('������ 48', '�������� ������ 48', 14.50),
        ('������ 49', '�������� ������ 49', 31.00),
        ('������ 50', '�������� ������ 50', 19.75);
    END
END

-- ���������, ����� �� ������� Clients
IF NOT EXISTS (SELECT * FROM [dbo].[Clients])
BEGIN
    -- ���������� ��� ��������� ������������ ������
    DECLARE @FirstNames TABLE (Name NVARCHAR(50));
    DECLARE @LastNames TABLE (Name NVARCHAR(50));
    INSERT INTO @FirstNames (Name) VALUES
        ('John'), ('Jane'), ('Robert'), ('Emily'), ('Michael'), ('Sarah');
    INSERT INTO @LastNames (Name) VALUES
        ('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Davis');

-- ���������, ����� �� ������� Clients
IF NOT EXISTS (SELECT * FROM [dbo].[Clients])
BEGIN
    -- ���������� ��� ��������� ������������ ������
    DECLARE @CustomFirstNames TABLE (Name NVARCHAR(50));
    DECLARE @CustomLastNames TABLE (Name NVARCHAR(50));
    INSERT INTO @CustomFirstNames (Name) VALUES
        ('����'), ('�����'), ('���������'), ('���������'), ('�������'), ('����');
    INSERT INTO @CustomLastNames (Name) VALUES
        ('������'), ('������'), ('�������'), ('������'), ('�������');

    -- ���������� ��������� ������ ��� ��������
    WHILE (SELECT COUNT(*) FROM [dbo].[Clients]) < 50
    BEGIN
        DECLARE @CustomFirstName NVARCHAR(50);
        DECLARE @CustomLastName NVARCHAR(50);
        DECLARE @DateOfBirth DATE;
        DECLARE @Sex NVARCHAR(50);
        DECLARE @Address NVARCHAR(100);
        DECLARE @Series NVARCHAR(50);
        DECLARE @Number BIGINT;
        DECLARE @Discount BIGINT;

        SELECT TOP 1 @CustomFirstName = Name FROM @CustomFirstNames ORDER BY NEWID();
        SELECT TOP 1 @CustomLastName = Name FROM @CustomLastNames ORDER BY NEWID();
        SET @DateOfBirth = DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 36525), GETDATE()); -- ���������� ���� �������� � �������� 100 ���
        SET @Sex = CASE WHEN (SELECT COUNT(*) FROM [dbo].[Clients]) % 2 = 0 THEN '�������' ELSE '�������' END;
        SET @Address = '����� ' + CAST((SELECT COUNT(*) FROM [dbo].[Clients]) AS NVARCHAR(10));
        SET @Series = LEFT(CAST(NEWID() AS NVARCHAR(36)), 2); -- ��������� ����� (������ ��� ������� GUID)
        SET @Number = ABS(CAST(CHECKSUM(NEWID()) AS BIGINT)) % 10000000000; -- ��������� ����� � �������� 10 ����������
        SET @Discount = ABS(CAST(CHECKSUM(NEWID()) AS INT)) % 20; -- ��������� ������ � �������� 20

        -- ��������� ������ � �������
        INSERT INTO [dbo].[Clients] ([FIO], [DateOfBirth], [Sex], [Address], [Series], [Number], [Discount])
        VALUES (CONCAT(@CustomFirstName, ' ', @CustomLastName), @DateOfBirth, @Sex, @Address, @Series, @Number, @Discount);
    END
END

-- ���������, ����� �� ������� Employees
IF NOT EXISTS (SELECT * FROM [dbo].[Employees])
BEGIN
    -- ���������� ��� ��������� ������������ ������
    DECLARE @CusFirstNames TABLE (Name NVARCHAR(50));
    DECLARE @CusLastNames TABLE (Name NVARCHAR(50));
    INSERT INTO @CusFirstNames (Name) VALUES
        ('John'), ('Jane'), ('Robert'), ('Emily'), ('Michael'), ('Sarah');
    INSERT INTO @CusLastNames (Name) VALUES
        ('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Davis');

    -- ���������� ��������� ������ ��� ����������
    WHILE (SELECT COUNT(*) FROM [dbo].[Employees]) < 50
    BEGIN
        DECLARE @FirstName NVARCHAR(50);
        DECLARE @LastName NVARCHAR(50);
        DECLARE @JobTitle NVARCHAR(50);
        DECLARE @Age INT;

        SELECT TOP 1 @FirstName = Name FROM @CusFirstNames ORDER BY NEWID();
        SELECT TOP 1 @LastName = Name FROM @CusLastNames ORDER BY NEWID();
        SET @JobTitle = CASE WHEN (SELECT COUNT(*) FROM [dbo].[Employees]) % 5 = 0 THEN 'Manager' ELSE 'Employee' END;
        SET @Age = RAND() * 20 + 25; -- ���������� ������� �� 25 �� 45 ���

        -- ��������� ������ � �������
        INSERT INTO [dbo].[Employees] ([FIO], [JobTitle], [Age])
        VALUES (CONCAT(@FirstName, ' ', @LastName), @JobTitle, @Age);
    END
END

-- ���������, ����� �� ������� TypesOfRecreation
IF NOT EXISTS (SELECT * FROM [dbo].[TypesOfRecreation])
BEGIN
        -- ��������� ������� 50 ��������� ������
        INSERT INTO [dbo].[TypesOfRecreation] ([Name], [Description], [Restrictions])
        VALUES
            ('������� �����', '����� �� ������ ����', '��� ������ �����������'),
			('����������� �����', '������� �� ������ �����', '��������� ���� �������� ���'),
			('���������', '��������� ������������� ���� � ����������������������', '�������� ������ �������'),
			('�������� �����', '���������� ����������� � �����������', '���������� ���������� ����������'),
			('���������� �����', '��������� ������ � ������������ ����', '��� ����������� �����������'),
			('���������������� ������', '����������� ��� ��������', '�������� ����������� �� �����'),
			('���-�����', '��������� ���-������� � ��������', '����� ������������� ��������������� ������'),
			('������������� ������', '����������� �� ������������ ������ ������', '���������� ������ ������ �������'),
			('������', '����������� �� �������� �������', '����� ��������� ��������� ��������'),
			('���������', '��������� ������ � ����', '������� ���������� ����������'),
			('����������� � ������', '�������� ����� � ������', '�������� � ����������� ��� �����'),
			('��������� � �����������', '��������� ���������� � ���������� �������', '���������� �����������'),
			('����������� � ������������ �����', '��������� ������������ �������������', '���������� ������������ �������������'),
			('�������������', '����������� ����������� � ������ ������', '�������� ����������� � ��������'),
			('��������', '����� ������ �� ������ � ���������', '����������� ���������� � ���������� ����������'),
			('����������', '����������� �� ����������', '������������ �� ������'),
			('�������', '��������� �������� � ������������ ������� ������', '������������ � ������������'),
			('������', '����������� �� ����������� ������', '������������ ��� ������� � ����� ��������'),
			('��������� ��������', '������������ � �������� ������', '���������� �������� � ����'),
			('����������� � ��������� �������', '���������� � ������� ���������', '������� ������� � ������� � �������� ��������'),
			('������ ���� ������', '���������� �� ����: �������, ������� � ��.', '������� ���������� � ������������'),
			('�������� ������', '����������� �� ���������� ��� ���������', '��������� � ��������'),
			('������������� �����', '����������� ��� ���������-���������', '������������� ������� � ������������'),
			('����������� � ���', '������������ � ��������� � �������', '��������� � ������������'),
			('������� �����', '��������� ����� � ������ ������� �����������', '������ � ��������'),
			('��������������� ��������', '������������ ��������������� ����������', '���������� ������� � �����������'),
			('��������� � �������', '������-������ � ���������� �������', '���������� ��������� � ��������'),
			('��������������� ����������', '�������� ����� � ������', '�������� � �������������� �������'),
			('������ � ���������', '�������� � ������� � ��������', '���������� � ������������'),
			('���������� ���������', '��������� ������� ���������� � ��������', '������������� ���� � ����������'),
			('����������', '������ ����� ������� � ��������', '����������� � ������ �������'),
			('�������', '����� �� ���� � �����', '���������� ������ � ������'),
			('�������', '����������� �� ��������� � ������', '������������ �� ���� � ��������'),
			('�������', '������� �� ������ � ����������', '������������ � ������������'),
			('���� � ��������', '������� ����� � �������� ����� �����', '����������� � ��������'),
			('������ � �������� ����', '����������� �� ������� � ����������', '������ � �����'),
			('������ � ����', '��������� ������ � ���������', '������ � ������������� �������'),
			('����������� ������', '����������� ��� ��������� ����������� �����', '����������� ������������'),
			('����������� �� ��������� �����', '��������� �������� � ���������', '������������ � �������� �������'),
			('�������� �����', '����� � ������ � ������', '�������� ��� ����� � �����������'),
			('���������� �����������', '��������� ���������� ������� � ������������', '������ � ������ �����������'),
			('���������', '��������� ��������� � ������������', '������������� ���� � ������������'),
			('������������� ������', '������������ ������������� ���������� � ������', '������������� �����������'),
			('���������������� ����', '����������� ��� �������� � ����������', '������� ����� � ���������'),
			('���� � ��������', '��������� ���������� � ���������� �����������', '���������� � ������'),
			('������ �� ��������', '����������� � ��������� � ��������', '����� � �������� � ���������'),
			('��������� ���������� ����������', '������������ � ���������� ����������', '������������� ������ � �������� ��������'),
			('����������� �� ������� �������� ��������', '�������� �� �������� ��������', '�������� � ����� �� �������'),
			('��������������� ������', '������ �������� � �����������', '�������������� � ����������'),
			('������������', '������������ ��������� ����� � �������', '���������� � ��������� � �������'),
			('�������������� ����', '����������� �������������� ���������', '������������ ������������'),
			('������������ �����������', '��������� ������������ ���� � ����������', '��������� � ������������ �����'),
			('����������� � ������������ ����', '���� �� ������ � �������� ��������', '������������ �����������');
    END
END

-- ���������, ����� �� ������� Vouchers
IF NOT EXISTS (SELECT * FROM [dbo].[Vouchers])
BEGIN
    DECLARE @VoucherIndex INT;
    SET @VoucherIndex = 1;

    WHILE @VoucherIndex <= 50
    BEGIN
        DECLARE @StartDate DATE;
        DECLARE @ExpirationDate DATE;
        DECLARE @HotelId INT;
        DECLARE @TypeOfRecreationId INT;
        DECLARE @AdditionalServiceId INT;
        DECLARE @ClientId INT;
        DECLARE @EmployessId INT;
        DECLARE @Reservation BIT;
        DECLARE @Payment BIT;

        -- ��������� ��������� �������� ��� ������ � ������� Vouchers
        SET @StartDate = DATEADD(DAY, -1 * (ABS(CHECKSUM(NEWID())) % 365), GETDATE());
        SET @ExpirationDate = DATEADD(DAY, (ABS(CHECKSUM(NEWID())) % 30) + 1, @StartDate);
        SET @HotelId = (ABS(CHECKSUM(NEWID())) % 50) + 1; -- ��������������, ��� � ��� ���� 50 ������
        SET @TypeOfRecreationId = (ABS(CHECKSUM(NEWID())) % 50) + 1; -- ��������������, ��� � ��� ���� 50 ����� ������
        SET @AdditionalServiceId = (ABS(CHECKSUM(NEWID())) % 10) + 1; -- ��������������, ��� � ��� ���� 10 �������������� �����
        SET @ClientId = (ABS(CHECKSUM(NEWID())) % 50) + 1; -- ��������������, ��� � ��� ���� 50 ��������
        SET @EmployessId = (ABS(CHECKSUM(NEWID())) % 50) + 1; -- ��������������, ��� � ��� ���� 50 �����������
        SET @Reservation = CASE WHEN @VoucherIndex % 2 = 0 THEN 1 ELSE 0 END; -- �������������, ������� �������� ���� ��� ����������
        SET @Payment = CASE WHEN @VoucherIndex % 3 = 0 THEN 1 ELSE 0 END; -- �������������, ������� �������� ���� ��� ������

        -- ��������� ������ � ������� Vouchers
        INSERT INTO [dbo].[Vouchers] ([StartDate], [ExpirationDate], [HotelId], [TypeOfRecreationId], [AdditionalServiceId], [ClientId], [EmployessId], [Reservation], [Payment])
        VALUES (@StartDate, @ExpirationDate, @HotelId, @TypeOfRecreationId, @AdditionalServiceId, @ClientId, @EmployessId, @Reservation, @Payment);

        SET @VoucherIndex = @VoucherIndex + 1;
    END
END

-- �������� ������ ������
GO
CREATE VIEW VoucherView AS
SELECT
    v.[Id] AS [VoucherId],
    v.[StartDate],
    v.[ExpirationDate],
    h.[Name] AS [HotelName],
    c.[FIO] AS [ClientName],
    e.[FIO] AS [EmployeeName],
    tr.[Name] AS [RecreationType],
    s.[Name] AS [AdditionalService],
    v.[Reservation],
    v.[Payment]
FROM [dbo].[Vouchers] v
JOIN [dbo].[Hotels] h ON v.[HotelId] = h.[Id]
JOIN [dbo].[Clients] c ON v.[ClientId] = c.[Id]
JOIN [dbo].[Employees] e ON v.[EmployessId] = e.[Id]
JOIN [dbo].[TypesOfRecreation] tr ON v.[TypeOfRecreationId] = tr.[Id]
JOIN [dbo].[AdditionalServices] s ON v.[AdditionalServiceId] = s.[Id];

-- ������� ������������� ��� ������� Hotels
GO
CREATE VIEW HotelView AS
SELECT * FROM [dbo].[Hotels];

-- ������������� ��� ������� TypesOfRecreation
GO
CREATE VIEW RecreationView AS
SELECT * FROM [dbo].[TypesOfRecreation];

-- ������� ������������� � ������������� �������
GO
CREATE VIEW EmployeesOver30 AS
SELECT * FROM [dbo].[Employees]
WHERE [Age] > 30;

-- �������� �������� ��������
IF OBJECT_ID('dbo.InsertHotel', 'P') IS NOT NULL
    DROP PROCEDURE dbo.InsertHotel;
GO
	CREATE PROCEDURE InsertHotel
		@Name NVARCHAR(100),
		@Country NVARCHAR(100),
		@City NVARCHAR(100),
		@Address NVARCHAR(200),
		@Phone NVARCHAR(20),
		@Stars INT,
		@TheContactPerson NVARCHAR(100)
	AS
	BEGIN
		INSERT INTO [dbo].[Hotels] ([Name], [Country], [City], [Address], [Phone], [Stars], [TheContactPerson])
		VALUES (@Name, @Country, @City, @Address, @Phone, @Stars, @TheContactPerson);
	END
GO

IF OBJECT_ID('dbo.UpdateClient', 'P') IS NOT NULL
    DROP PROCEDURE dbo.UpdateClient;
GO
	CREATE PROCEDURE UpdateClient
		@ClientId INT,
		@FIO NVARCHAR(150),
		@DateOfBirth DATE,
		@Sex NVARCHAR(50),
		@Address NVARCHAR(100),
		@Series NVARCHAR(50),
		@Number BIGINT,
		@Discount BIGINT
	AS
	BEGIN
		UPDATE [dbo].[Clients]
		SET
			[FIO] = @FIO,
			[DateOfBirth] = @DateOfBirth,
			[Sex] = @Sex,
			[Address] = @Address,
			[Series] = @Series,
			[Number] = @Number,
			[Discount] = @Discount
		WHERE
			[Id] = @ClientId;
	END
GO

IF OBJECT_ID('dbo.DeleteAdditionalServiceById', 'P') IS NOT NULL
    DROP PROCEDURE dbo.DeleteAdditionalServiceById;
GO
	CREATE PROCEDURE DeleteAdditionalServiceById
		@ServiceId INT
	AS
	BEGIN
		DELETE FROM [dbo].[AdditionalServices]
		WHERE [Id] = @ServiceId;
	END
GO