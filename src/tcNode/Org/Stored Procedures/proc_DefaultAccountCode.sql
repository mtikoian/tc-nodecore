﻿
CREATE   PROCEDURE Org.proc_DefaultAccountCode 
	(
	@AccountName nvarchar(100),
	@AccountCode nvarchar(10) OUTPUT 
	)
AS
   	SET NOCOUNT, XACT_ABORT ON;

	BEGIN TRY
		DECLARE 
			@ParsedName nvarchar(100)
			, @FirstWord nvarchar(100)
			, @SecondWord nvarchar(100)
			, @ValidatedCode nvarchar(10)
			, @c char(1)
			, @ASCII smallint
			, @pos int
			, @ok bit
			, @Suffix smallint
			, @Rows int
		
		SET @pos = 1
		SET @ParsedName = ''

		WHILE @pos <= datalength(@AccountName)
		BEGIN
			SET @ASCII = ASCII(SUBSTRING(@AccountName, @pos, 1))
			SET @ok = CASE 
				WHEN @ASCII = 32 THEN 1
				WHEN @ASCII = 45 THEN 1
				WHEN (@ASCII >= 48 and @ASCII <= 57) THEN 1
				WHEN (@ASCII >= 65 and @ASCII <= 90) THEN 1
				WHEN (@ASCII >= 97 and @ASCII <= 122) THEN 1
				ELSE 0
			END
			IF @ok = 1
				SELECT @ParsedName = @ParsedName + char(ASCII(SUBSTRING(@AccountName, @pos, 1)))
			SET @pos = @pos + 1
		END

		--print @ParsedName
		
		IF CHARINDEX(' ', @ParsedName) = 0
			BEGIN
			SET @FirstWord = @ParsedName
			SET @SecondWord = ''
			END
		ELSE
			BEGIN
			SET @FirstWord = left(@ParsedName, CHARINDEX(' ', @ParsedName) - 1)
			SET @SecondWord = right(@ParsedName, LEN(@ParsedName) - CHARINDEX(' ', @ParsedName))
			IF CHARINDEX(' ', @SecondWord) > 0
				SET @SecondWord = left(@SecondWord, CHARINDEX(' ', @SecondWord) - 1)
			END

		IF EXISTS(SELECT ExcludedTag FROM App.tbCodeExclusion WHERE ExcludedTag = @SecondWord)
			BEGIN
			SET @SecondWord = ''
			END

		--print @FirstWord
		--print @SecondWord

		IF LEN(@SecondWord) > 0
			SET @AccountCode = UPPER(left(@FirstWord, 3)) + UPPER(left(@SecondWord, 3))		
		ELSE
			SET @AccountCode = UPPER(left(@FirstWord, 6))

		SET @ValidatedCode = @AccountCode
		SELECT @rows = COUNT(AccountCode) FROM Org.tbOrg WHERE AccountCode = @ValidatedCode
		SET @Suffix = 0
	
		WHILE @rows > 0
		BEGIN
			SET @Suffix = @Suffix + 1
			SET @ValidatedCode = @AccountCode + LTRIM(STR(@Suffix))
			SELECT @rows = COUNT(AccountCode) FROM Org.tbOrg WHERE AccountCode = @ValidatedCode
		END
	
		SET @AccountCode = @ValidatedCode
	
  	END TRY
	BEGIN CATCH
		EXEC App.proc_ErrorLog;
	END CATCH
