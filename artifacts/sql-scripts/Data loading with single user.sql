-- Create a load user with small resource class for load testing
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'smallrc_user')
BEGIN
CREATE USER [smallrc_user] WITHOUT LOGIN
EXEC sp_addrolemember 'db_owner', 'smallrc_user'; 
--need not (cannot) assign smallrc to user, by default the user is created with smallrc membership only
--EXEC sp_addrolemember 'smallrc', 'smallrc_user'; 
END

-- Create a load user with large resource class for load testing
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'largerc_user')
BEGIN
CREATE USER [largerc_user] WITHOUT LOGIN
EXEC sp_addrolemember 'db_owner', 'largerc_user'; 
EXEC sp_addrolemember 'largerc', 'largerc_user'; 
END

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

-- Drop nyctaxi_src_rr_heap table if exists (easier for re-loading)
IF OBJECT_ID('dbo.nyctaxi_src_rr_heap') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[nyctaxi_src_rr_heap]
END

-- Create nyctaxi_src_rr_heap table with proper schema
declare @table1 nvarchar(4000)

set @table1 = N'CREATE TABLE [dbo].[nyctaxi_src_rr_heap]
( '+ @schema + '
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)'

EXECUTE sp_executesql @table1

-- Drop nyctaxi_src_hash_heap table if exists (easier for re-loading)
IF OBJECT_ID('dbo.nyctaxi_src_hash_heap') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[nyctaxi_src_hash_heap]
END

-- Create nyctaxi_src_hash_heap table with proper schema
declare @table2 nvarchar(4000)

set @table2 = N'CREATE TABLE [dbo].[nyctaxi_src_hash_heap]
( '+ @schema + '
)
WITH
(
	DISTRIBUTION = HASH(hashCol),
	HEAP
)'

EXECUTE sp_executesql @table2


EXECUTE AS USER = 'smallrc_user'
GO

truncate table [dbo].[nyctaxi_src_rr_heap]

COPY INTO [dbo].[nyctaxi_src_rr_heap]
(
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
FROM 
'https://youradlsaccountname.dfs.core.windows.net/your-conatiner/your-folder/'
WITH (IDENTITY_INSERT='OFF',
CREDENTIAL=(IDENTITY='Managed Identity'),
FILE_TYPE = 'Parquet',COMPRESSION='Snappy') 
OPTION 
(LABEL='COPY : nyctaxi_src_rr_heap')

truncate table [dbo].[nyctaxi_src_hash_heap]

COPY INTO [dbo].[nyctaxi_src_hash_heap]
(
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
FROM 
'https://youradlsaccountname.dfs.core.windows.net/your-conatiner/your-folder/' 
WITH (IDENTITY_INSERT='OFF',
CREDENTIAL=(IDENTITY='Managed Identity'),
FILE_TYPE = 'Parquet',COMPRESSION='Snappy') 
OPTION 
(LABEL='COPY : nyctaxi_src_hash_heap')

REVERT
GO;


EXECUTE AS USER = 'largerc_user'
GO

IF OBJECT_ID('dbo.nyctaxi_lrc_hash_cci_1') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[nyctaxi_lrc_hash_cci_1]
END

CREATE TABLE [dbo].[nyctaxi_lrc_hash_cci_1]
WITH
(
 DISTRIBUTION = HASH(hashCol)
 ,CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT  *
FROM    [dbo].[nyctaxi_src_rr_heap]
OPTION 
(LABEL='CTAS : nyctaxi_lrc_hash_cci_1')

IF OBJECT_ID('dbo.nyctaxi_lrc_hash_cci_2') IS NOT NULL
BEGIN
    DROP TABLE [dbo].[nyctaxi_lrc_hash_cci_2]
END

CREATE TABLE [dbo].[nyctaxi_lrc_hash_cci_2]
WITH
(
 DISTRIBUTION = HASH(hashCol)
 ,CLUSTERED COLUMNSTORE INDEX
)
AS
SELECT  *
FROM    [dbo].[nyctaxi_src_hash_heap]
OPTION 
(LABEL='CTAS : nyctaxi_lrc_hash_cci_2')

REVERT
GO;

/* Monitor the load status - print results */
SELECT   r.[start_time]
,       r.[request_id]
,       r.[status]
,       r.resource_class
,       r.command
,       r.total_elapsed_time as total_elapsed_time_millisec
,       r.total_elapsed_time/1000 as total_elapsed_time_sec
,       r.total_elapsed_time/60000 as total_elapsed_time_min
,       sum(bytes_processed) AS bytes_processed
,       sum(bytes_processed)/(1024*1024) AS bytes_processed_mb
,       sum(bytes_processed)/(1024*1024*1024) AS bytes_processed_gb
,       sum(rows_processed) AS rows_processed
FROM    sys.dm_pdw_exec_requests r
              LEFT OUTER JOIN sys.dm_pdw_dms_workers w
                     ON r.[request_id] = w.request_id
WHERE [label] = 'COPY : nyctaxi_src_rr_heap' OR
    [label] = 'COPY : nyctaxi_src_hash_heap' OR
    [label] = 'CTAS : nyctaxi_lrc_hash_cci_1' OR
    [label] = 'CTAS : nyctaxi_lrc_hash_cci_2'
and session_id <> session_id() and (type = 'WRITER' or type is null)
GROUP BY r.[start_time], r.[request_id],
        r.[status],
        r.resource_class,
        r.command,
        r.total_elapsed_time
ORDER BY r.[request_id] desc

