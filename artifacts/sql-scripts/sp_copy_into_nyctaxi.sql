CREATE PROC [dbo].[sp_copy_into_nyctaxi]
@user_name nvarchar(100),
@table_name nvarchar(100),
@location nvarchar(1000),
@format nvarchar(100),
@compression nvarchar(100)
AS
BEGIN
    EXECUTE AS USER = @user_name

    declare @trunc nvarchar(4000)

    SET @trunc = 'truncate table ' + @table_name

    EXECUTE sp_executesql @trunc 

    declare @copy_table nvarchar(4000)

    SET @copy_table = 'COPY INTO ' + @table_name +
    '(
        [vendorID] 1,
        [tpepPickupDateTime] 2,
        [tpepDropoffDateTime] 3,
        [passengerCount] 4,
        [tripDistance] 5,
        [puLocationId] 6,
        [doLocationId] 7,
        [startLon] 8,
        [startLat] 9,
        [endLon] 10,
        [endLat] 11,
        [rateCodeId] 12,
        [storeAndFwdFlag] 13,
        [paymentType] 14,
        [fareAmount] 15,
        [extra] 16,
        [mtaTax] 17,
        [improvementSurcharge] 18,
        [tipAmount] 19,
        [tollsAmount] 20,
        [totalAmount] 21,
        [puYear] 22,
        [puMonth] 23,
        [hashCol] 24
    )
    FROM ''' +
    @location +
    ''' WITH (IDENTITY_INSERT=''OFF'',
    CREDENTIAL=(IDENTITY=''Managed Identity''),
    FILE_TYPE = ''' + @format + ''',COMPRESSION=''' + @compression + ''') 
    OPTION 
    (LABEL=''COPY : ' + @table_name + ''' )'

    EXECUTE sp_executesql @copy_table
    
    REVERT

END
