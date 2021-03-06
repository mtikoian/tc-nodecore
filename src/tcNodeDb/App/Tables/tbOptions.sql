﻿CREATE TABLE [App].[tbOptions] (
    [Identifier]         NVARCHAR (4)  NOT NULL,
    [IsInitialised]      BIT           CONSTRAINT [DF_App_tbOptions_IsIntialised] DEFAULT ((0)) NOT NULL,
    [AccountCode]        NVARCHAR (10) NOT NULL,
    [RegisterName]       NVARCHAR (50) NOT NULL,
    [DefaultPrintMode]   SMALLINT      CONSTRAINT [DF_App_tbOptions_DefaultPrintMode] DEFAULT ((2)) NOT NULL,
    [BucketTypeCode]     SMALLINT      CONSTRAINT [DF_App_tbOptions_BucketTypeCode] DEFAULT ((1)) NOT NULL,
    [BucketIntervalCode] SMALLINT      CONSTRAINT [DF_App_tbOptions_BucketIntervalCode] DEFAULT ((1)) NOT NULL,
    [NetProfitCode]      NVARCHAR (10) NULL,
    [VatCategoryCode]    NVARCHAR (10) NULL,
    [TaxHorizon]         SMALLINT      CONSTRAINT [DF_App_tbOptions_TaxHorizon] DEFAULT ((90)) NOT NULL,
    [IsAutoOffsetDays]   BIT           CONSTRAINT [DF_App_tbOptions_IsAutoOffsetDays] DEFAULT ((0)) NOT NULL,
    [InsertedBy]         NVARCHAR (50) CONSTRAINT [DF_App_tbOptions_InsertedBy] DEFAULT (suser_sname()) NOT NULL,
    [InsertedOn]         DATETIME      CONSTRAINT [DF_App_tbOptions_InsertedOn] DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]          NVARCHAR (50) CONSTRAINT [DF_App_tbOptions_UpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [UpdatedOn]          DATETIME      CONSTRAINT [DF_App_tbOptions_UpdatedOn] DEFAULT (getdate()) NOT NULL,
    [RowVer]             ROWVERSION    NOT NULL,
    [UnitOfCharge]       NVARCHAR (5)  NULL,
    CONSTRAINT [PK_App_tbOptions] PRIMARY KEY CLUSTERED ([Identifier] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_App_tbOption_Cash_tbCategory] FOREIGN KEY ([NetProfitCode]) REFERENCES [Cash].[tbCategory] ([CategoryCode]),
    CONSTRAINT [FK_App_tbOptions_App_tbBucketInterval] FOREIGN KEY ([BucketIntervalCode]) REFERENCES [App].[tbBucketInterval] ([BucketIntervalCode]),
    CONSTRAINT [FK_App_tbOptions_App_tbBucketType] FOREIGN KEY ([BucketTypeCode]) REFERENCES [App].[tbBucketType] ([BucketTypeCode]),
    CONSTRAINT [FK_App_tbOptions_App_tbRegister] FOREIGN KEY ([RegisterName]) REFERENCES [App].[tbRegister] ([RegisterName]) ON UPDATE CASCADE,
    CONSTRAINT [FK_App_tbOptions_Org_tb] FOREIGN KEY ([AccountCode]) REFERENCES [Org].[tbOrg] ([AccountCode]) ON UPDATE CASCADE,
    CONSTRAINT [FK_App_tbUoc_UnitOfCharge] FOREIGN KEY ([UnitOfCharge]) REFERENCES [App].[tbUoc] ([UnitOfCharge])
);


GO
CREATE   TRIGGER App.App_tbOptions_TriggerUpdate 
   ON  App.tbOptions
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		UPDATE App.tbOptions
		SET UpdatedBy = SUSER_SNAME(), UpdatedOn = CURRENT_TIMESTAMP
		FROM App.tbOptions INNER JOIN inserted AS i ON tbOptions.Identifier = i.Identifier;
	END TRY
	BEGIN CATCH
		EXEC App.proc_ErrorLog;
	END CATCH
END
