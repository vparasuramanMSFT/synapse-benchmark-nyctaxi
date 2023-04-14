CREATE PROC [dbo].[sp_create_table_nyctaxi]
@table_name nvarchar(100),
@distribution nvarchar(100),
@index nvarchar(100)
AS
BEGIN
    declare @schema nvarchar(4000)

    SET @schema = N'[vendorID] char(3) NULL,
        [tpepPickupDateTime] DATETIME NULL,
        [tpepDropoffDateTime] DATETIME NULL,
        [passengerCount] int NULL,
        [tripDistance] float NULL,
        [puLocationId] char(3) NULL,
        [doLocationId] char(3) NULL,
        [startLon] float NULL,
        [startLat] float NULL,
        [endLon] float NULL,
        [endLat] float NULL,
        [rateCodeId] int NULL,
        [storeAndFwdFlag] char(1) NULL,
        [paymentType] varchar(50) NULL,
        [fareAmount] float NULL,
        [extra] float NULL,
        [mtaTax] float NULL,
        [improvementSurcharge] varchar(50) NULL,
        [tipAmount] float NULL,
        [tollsAmount] float NULL,
        [totalAmount] float NULL,
        [puYear] int NULL,
        [puMonth] int NULL,
        [hashCol] varchar(50) NULL'

   -- Drop table if exists (easier for re-loading)
    IF OBJECT_ID(@table_name) IS NOT NULL
    BEGIN
        declare @drop_table nvarchar(4000)
        set @drop_table = N'DROP TABLE ' + @table_name
        EXECUTE sp_executesql @drop_table
    END

    -- Create table with proper schema
    declare @create_table nvarchar(4000)

    set @create_table = N'CREATE TABLE ' + @table_name +
    '( '+ @schema + '
    )
    WITH
    (
        DISTRIBUTION = ' + @distribution + ',' +
        @index +
    ')'

    EXECUTE sp_executesql @create_table
END
