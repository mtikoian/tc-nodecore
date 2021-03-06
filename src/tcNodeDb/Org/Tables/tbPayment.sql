﻿CREATE TABLE [Org].[tbPayment] (
    [PaymentCode]       NVARCHAR (20) NOT NULL,
    [UserId]            NVARCHAR (10) NOT NULL,
    [PaymentStatusCode] SMALLINT      CONSTRAINT [DF_Org_tbPayment_PaymentStatusCode] DEFAULT ((0)) NOT NULL,
    [AccountCode]       NVARCHAR (10) NOT NULL,
    [CashAccountCode]   NVARCHAR (10) NOT NULL,
    [CashCode]          NVARCHAR (50) NULL,
    [TaxCode]           NVARCHAR (10) NULL,
    [PaidOn]            DATETIME      CONSTRAINT [DF_Org_tbPayment_PaidOn] DEFAULT (CONVERT([date],getdate())) NOT NULL,
    [PaidInValue]       MONEY         CONSTRAINT [DF_Org_tbPayment_PaidInValue] DEFAULT ((0)) NOT NULL,
    [PaidOutValue]      MONEY         CONSTRAINT [DF_Org_tbPayment_PaidOutValue] DEFAULT ((0)) NOT NULL,
    [TaxInValue]        MONEY         CONSTRAINT [DF_Org_tbPayment_TaxInValue] DEFAULT ((0)) NOT NULL,
    [TaxOutValue]       MONEY         CONSTRAINT [DF_Org_tbPayment_TaxOutValue] DEFAULT ((0)) NOT NULL,
    [PaymentReference]  NVARCHAR (50) NULL,
    [InsertedBy]        NVARCHAR (50) CONSTRAINT [DF_Org_tbPayment_InsertedBy] DEFAULT (suser_sname()) NOT NULL,
    [InsertedOn]        DATETIME      CONSTRAINT [DF_Org_tbPayment_InsertedOn] DEFAULT (getdate()) NOT NULL,
    [UpdatedBy]         NVARCHAR (50) CONSTRAINT [DF_Org_tbPayment_UpdatedBy] DEFAULT (suser_sname()) NOT NULL,
    [UpdatedOn]         DATETIME      CONSTRAINT [DF_Org_tbPayment_UpdatedOn] DEFAULT (getdate()) NOT NULL,
    [RowVer]            ROWVERSION    NOT NULL,
    CONSTRAINT [PK_Org_tbPayment] PRIMARY KEY CLUSTERED ([PaymentCode] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Org_tbPayment_App_tbTaxCode] FOREIGN KEY ([TaxCode]) REFERENCES [App].[tbTaxCode] ([TaxCode]),
    CONSTRAINT [FK_Org_tbPayment_Cash_tbCode] FOREIGN KEY ([CashCode]) REFERENCES [Cash].[tbCode] ([CashCode]) ON UPDATE CASCADE,
    CONSTRAINT [FK_Org_tbPayment_Org_tbAccount] FOREIGN KEY ([CashAccountCode]) REFERENCES [Org].[tbAccount] ([CashAccountCode]) ON UPDATE CASCADE,
    CONSTRAINT [FK_Org_tbPayment_Org_tbPaymentStatus] FOREIGN KEY ([PaymentStatusCode]) REFERENCES [Org].[tbPaymentStatus] ([PaymentStatusCode]),
    CONSTRAINT [FK_Org_tbPayment_tbOrg] FOREIGN KEY ([AccountCode]) REFERENCES [Org].[tbOrg] ([AccountCode]),
    CONSTRAINT [FK_Org_tbPayment_Usr_tbUser] FOREIGN KEY ([UserId]) REFERENCES [Usr].[tbUser] ([UserId]) ON UPDATE CASCADE
);


GO
CREATE NONCLUSTERED INDEX [IX_tbPayment_TaxCode]
    ON [Org].[tbPayment]([TaxCode] ASC)
    INCLUDE([PaidInValue], [PaidOutValue]);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment]
    ON [Org].[tbPayment]([PaymentReference] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment_AccountCode]
    ON [Org].[tbPayment]([AccountCode] ASC, [PaidOn] DESC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment_CashAccountCode]
    ON [Org].[tbPayment]([CashAccountCode] ASC, [PaidOn] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment_CashCode]
    ON [Org].[tbPayment]([CashCode] ASC, [PaidOn] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment_PaymentCode_Status]
    ON [Org].[tbPayment]([AccountCode] ASC, [PaymentStatusCode] ASC, [PaymentCode] ASC)
    INCLUDE([PaidInValue], [PaidOutValue]);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment_PaymentCode_TaxCode]
    ON [Org].[tbPayment]([AccountCode] ASC, [PaymentCode] ASC, [TaxCode] ASC)
    INCLUDE([PaymentStatusCode], [PaidInValue], [PaidOutValue]);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment_Status]
    ON [Org].[tbPayment]([PaymentStatusCode] ASC)
    INCLUDE([CashAccountCode], [CashCode], [PaidOn], [PaidInValue], [PaidOutValue]);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment_Status_AccountCode]
    ON [Org].[tbPayment]([PaymentStatusCode] ASC, [AccountCode] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Org_tbPayment_Status_CashAccount_PaidOn]
    ON [Org].[tbPayment]([PaymentStatusCode] ASC, [CashAccountCode] ASC, [PaidOn] ASC)
    INCLUDE([PaymentCode], [PaidInValue], [PaidOutValue]);


GO
CREATE   TRIGGER Org.Org_tbPayment_TriggerInsert
ON Org.tbPayment
FOR INSERT
AS
	SET NOCOUNT ON;
	BEGIN TRY

		UPDATE payment
		SET PaymentStatusCode = 2
		FROM inserted
			JOIN Org.tbPayment payment ON inserted.PaymentCode = payment.PaymentCode
			JOIN Cash.tbCode ON inserted.CashCode = Cash.tbCode.CashCode 
			JOIN Cash.tbCategory category ON Cash.tbCode.CategoryCode = category.CategoryCode
		WHERE category.CashTypeCode = 2 AND inserted.PaymentStatusCode = 0

	END TRY
	BEGIN CATCH
		EXEC App.proc_ErrorLog;
	END CATCH


GO
CREATE   TRIGGER Org.Org_tbPayment_TriggerUpdate
ON Org.tbPayment
FOR UPDATE
AS
	SET NOCOUNT ON;
	BEGIN TRY
		UPDATE Org.tbPayment
		SET UpdatedBy = SUSER_SNAME(), UpdatedOn = CURRENT_TIMESTAMP
		FROM Org.tbPayment INNER JOIN inserted AS i ON tbPayment.PaymentCode = i.PaymentCode;

		IF UPDATE(PaidInValue) OR UPDATE(PaidOutValue)
			BEGIN
			DECLARE @AccountCode NVARCHAR(10)
			DECLARE org CURSOR LOCAL FOR 
				SELECT AccountCode 
				FROM inserted
				WHERE PaymentStatusCode = 1

			OPEN org
			FETCH NEXT FROM org INTO @AccountCode
			WHILE (@@FETCH_STATUS = 0)
				BEGIN		
				EXEC Org.proc_Rebuild @AccountCode
				FETCH NEXT FROM org INTO @AccountCode
			END

			CLOSE org
			DEALLOCATE org

			END
	END TRY
	BEGIN CATCH
		EXEC App.proc_ErrorLog;
	END CATCH
