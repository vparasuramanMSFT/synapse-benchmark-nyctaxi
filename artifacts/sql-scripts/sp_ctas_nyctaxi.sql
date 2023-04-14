CREATE PROC [dbo].[sp_ctas_nyctaxi]
@user_name nvarchar(100),
@target_table_name nvarchar(200),
@source_table_name nvarchar(200),
@distribution nvarchar(100),
@index nvarchar(100)
AS
BEGIN

    EXECUTE AS USER = @user_name

    IF OBJECT_ID(@target_table_name) IS NOT NULL
    BEGIN
        declare @drop_table nvarchar(4000)
        SET @drop_table = 'DROP TABLE ' + @target_table_name
        EXECUTE sp_executesql @drop_table
    END

    declare @create_table nvarchar(4000)

    SET @create_table = 'CREATE TABLE ' + @target_table_name +
    'WITH
    (
    DISTRIBUTION = ' + @distribution +
    ',' + @index +
    ')
    AS
    SELECT  *
    FROM    ' + @source_table_name +
    ' OPTION 
    (LABEL=''COPY : ' + @target_table_name + ''' )'

    REVERT

END
