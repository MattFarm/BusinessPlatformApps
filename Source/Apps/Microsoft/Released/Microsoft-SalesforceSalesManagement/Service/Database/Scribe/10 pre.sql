SET ANSI_NULLS              ON;
SET ANSI_PADDING            ON;
SET ANSI_WARNINGS           ON;
SET ANSI_NULL_DFLT_ON       ON;
SET CONCAT_NULL_YIELDS_NULL ON;
SET QUOTED_IDENTIFIER       ON;
go

-- Must be executed inside the target database
DECLARE @stmt AS VARCHAR(500), @p1 AS VARCHAR(100), @p2 AS VARCHAR(100);
DECLARE @cr CURSOR;

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='configuration' AND TABLE_TYPE='BASE TABLE')
BEGIN
	DECLARE @additionalTables NVARCHAR(MAX);
	SELECT @additionalTables = [value]
	FROM smgt.[configuration] WHERE configuration_group = 'SolutionTemplate' AND configuration_subgroup = 'SalesManagement' AND [name] = 'AdditionalTables';
SET @cr = CURSOR FAST_FORWARD FOR
              SELECT [value] FROM STRING_SPLIT(@additionalTables,',')
			  
OPEN @cr;
FETCH NEXT FROM @cr INTO @p1;
WHILE @@FETCH_STATUS = 0  
BEGIN 
    SET @stmt = 'IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA=''dbo'' AND TABLE_NAME='''+REPLACE(REPLACE(QuoteName(@p1),'[',''),']','')+''' AND TABLE_TYPE=''BASE TABLE'') DROP TABLE dbo.' + QuoteName(@p1);
	EXEC (@stmt);
	SET @stmt = 'IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA=''dbo'' AND ROUTINE_NAME=''spMerge'+REPLACE(REPLACE(QuoteName(@p1),'[',''),']','')+''' AND ROUTINE_TYPE=''PROCEDURE'')   DROP PROCEDURE dbo.spMerge'+ REPLACE(REPLACE(QuoteName(@p1),'[',''),']','');
	EXEC (@stmt);
	SET @stmt = 'IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_SCHEMA=''dbo'' AND DOMAIN_NAME='''+REPLACE(REPLACE(QuoteName(@p1),'[',''),']','')+'type'' ) DROP TYPE dbo.'+ REPLACE(REPLACE(QuoteName(@p1),'[',''),']','')+'type';
	EXEC (@stmt);
	FETCH NEXT FROM @cr INTO @p1;
END;
CLOSE @cr;
DEALLOCATE @cr;
END;

-- Regular views
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='accountview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.AccountView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='actualsalesview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.ActualSalesView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='businessunitview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.BusinessUnitView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='dateview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.DateView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='leadview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.LeadView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='measuresview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.MeasuresView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='opportunityproductview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.OpportunityProductView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='opportunityview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.OpportunityView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='productview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.ProductView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='quotaview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.QuotaView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='targetview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.TargetView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='tempuserview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.TempUserView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='territoryview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.TerritoryView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='usermappingview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.UserMappingView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='userview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.UserView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='userascendantsview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.UserAscendantsView;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='configurationview' AND TABLE_TYPE='VIEW')
    DROP VIEW smgt.ConfigurationView;

-- Tables
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='actualsales' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.ActualSales;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='configuration' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.configuration;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='date' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.[date];
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='quotas' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.Quotas;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='targets' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.Targets;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='usermapping' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE smgt.userMapping;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='smgt' AND TABLE_NAME='entityinitialcount' AND TABLE_TYPE='BASE TABLE')
	DROP TABLE smgt.entityinitialcount;



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='Account' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.Account;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='Lead' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.Lead;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='Opportunity' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.Opportunity;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='OpportunityLineItem' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.OpportunityLineItem;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='OpportunityStage' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.OpportunityStage;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='product2' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.product2;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='Scribe_ReplicationStatus' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.Scribe_ReplicationStatus;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='user' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.[user];
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME='UserRole' AND TABLE_TYPE='BASE TABLE')
    DROP TABLE dbo.UserRole;


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='sp_get_replication_counts' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.sp_get_replication_counts;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='sp_get_prior_content' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.sp_get_prior_content;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_SCHEMA='dbo' AND ROUTINE_NAME='sp_get_pull_status' AND ROUTINE_TYPE='PROCEDURE')
    DROP PROCEDURE dbo.sp_get_pull_status;

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name='smgt')
BEGIN
    EXEC ('CREATE SCHEMA smgt AUTHORIZATION dbo'); -- Avoid batch error
END;