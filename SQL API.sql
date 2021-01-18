
DECLARE @Object AS INT;
DECLARE @Response TABLE (txt NVARCHAR(MAX));

DECLARE @ExtractDateTime AS DATETIME
SET @ExtractDateTime = GETDATE()

-- Found that setting an IP address is required for those behind a proxy server
EXEC sp_OAMethod @Object, 'setProxy', NULL, '2', '127.0.0.1:8080'
EXEC sp_OACreate 'MSXML2.XMLHTTP', @Object OUT;
EXEC sp_OAMethod @Object, 'OPEN', NULL, 'GET',
             'https://api.coinbase.com/v2/prices/LINK-GBP/sell', 
             'false';
-- Additional headers (like auth headers can go here)
--EXEC sp_OAMethod @Object,'setRequestHeader', null, 'Authentication-Key', '0123456789'
EXEC sp_OAMethod @Object, 'send';
INSERT INTO @Response (txt)
EXEC sp_OAMethod @Object, 'responseText'

EXEC sp_OADestroy @Object   

DECLARE @temp VARCHAR(MAX)
SET @temp = (SELECT txt FROM @Response)

-- Raw select
SELECT * FROM @Response

-- Find unnecessary characters
--PRINT SUBSTRING(@replace,100564,30);

-- Remove unnecessary characters 
DECLARE @replace VARCHAR(MAX)
SET @replace = REPLACE(REPLACE(REPLACE(REPLACE(@temp,'new Date(',''),')',''),'\''S','S'),'\','')


-- Select query in to a temp table parsing JSON via OPENJSON command (post SQL 2012)
SELECT * 
INTO [#Temp]
FROM  
OPENJSON (@replace)  

SELECT * FROM [#Temp]

DROP TABLE [#Temp]
