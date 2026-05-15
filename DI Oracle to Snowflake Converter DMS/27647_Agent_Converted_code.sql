=============================================
Author: Ascendion AAVA
Created on:
Description: Stored procedure to orchestrate full refresh load of all bronze layer tables with audit logging and error handling
=============================================

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Procedure
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle CREATE OR REPLACE PROCEDURE into Snowflake CREATE OR REPLACE PROCEDURE with JavaScript
-- - Replaced Oracle variable declarations (VARCHAR2, NUMBER, TIMESTAMP) with Snowflake JavaScript equivalents
-- - Converted Oracle SYSTIMESTAMP to Snowflake CURRENT_TIMESTAMP()
-- - Replaced Oracle USER function with CURRENT_USER()
-- - Converted Oracle TO_CHAR date formatting to Snowflake TO_VARCHAR with equivalent format strings
-- - Replaced Oracle DBMS_OUTPUT.PUT_LINE with Snowflake return messages and logging approach
-- - Converted Oracle procedure calls into Snowflake CALL statements within JavaScript
-- - Replaced Oracle NVL function with Snowflake COALESCE
-- - Converted Oracle EXTRACT function for timestamp arithmetic to Snowflake DATEDIFF
-- - Replaced Oracle INSERT INTO statements with Snowflake INSERT INTO using JavaScript SQL execution
-- - Converted Oracle COMMIT to Snowflake auto-commit behavior
-- - Replaced Oracle exception handling (EXCEPTION WHEN OTHERS) with JavaScript try-catch blocks
-- - Converted Oracle SQLERRM and SQLCODE to Snowflake JavaScript error object properties
-- - Replaced Oracle RAISE_APPLICATION_ERROR with JavaScript throw statement
-- Major Risks / Checks :
-- - Validate that called procedures exist in Snowflake bronze schema
-- - Validate audit log table structure matches INSERT statements
-- - Validate timestamp arithmetic conversion accuracy
-- - Validate error handling behavior differences between Oracle and Snowflake
-- =========================================================

CREATE OR REPLACE PROCEDURE bronze.usp_Load_bronze_Layer_Full()
RETURNS VARCHAR
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
    // Variable declarations
    var v_ProcedureName = 'bronze.usp_Load_bronze_Layer_Full';
    var v_StartTime = new Date();
    var v_EndTime;
    var v_ExecutionTime;
    var v_OverallStatus = 'SUCCESS';
    var v_ErrorMessage = '';
    var v_ErrorNumber = 0;
    var v_TotalRowsProcessed = 0;
    var v_TotalRowsInserted = 0;
    var v_TotalRowsFailed = 0;
    var v_TablesProcessed = 0;
    var v_TablesSucceeded = 0;
    var v_TablesFailed = 0;
    var v_CurrentUser = '';
    var v_BatchID = '';
    
    try {
        // Get current user
        var userStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_USER()"});
        var userResult = userStmt.execute();
        userResult.next();
        v_CurrentUser = userResult.getColumnValue(1);
        
        // Get current timestamp and format batch ID
        var timestampStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var timestampResult = timestampStmt.execute();
        timestampResult.next();
        v_StartTime = timestampResult.getColumnValue(1);
        
        var batchStmt = snowflake.createStatement({sqlText: "SELECT TO_VARCHAR(CURRENT_TIMESTAMP(), 'YYYY-MM-DD HH24:MI:SS.FF3')"});
        var batchResult = batchStmt.execute();
        batchResult.next();
        v_BatchID = batchResult.getColumnValue(1);
        
        // Log start of overall process
        var logMessage = '';
        logMessage += '================================================================================\n';
        logMessage += 'bronze Layer ETL Pipeline - Started at: ' + v_BatchID + '\n';
        logMessage += 'Executed by: ' + v_CurrentUser + '\n';
        logMessage += 'Batch ID: ' + v_BatchID + '\n';
        logMessage += '================================================================================\n';
        
        // Load Table 1: bz_New_Monthly_HC_Report
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_New_Monthly_HC_Report(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 2: bz_SchTask
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_SchTask(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 3: bz_Hiring_Initiator_Project_Info
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_Hiring_Initiator_Project_Info(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 4: bz_Timesheet_New
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_Timesheet_New(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 5: bz_report_392_all
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_report_392_all(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 6: bz_vw_billing_timesheet_daywise_ne
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 7: bz_vw_consultant_timesheet_daywise
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_vw_consultant_timesheet_daywise(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 8: bz_DimDate
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_DimDate(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 9: bz_holidays_Mexico
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_Mexico(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 10: bz_holidays_Canada
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_Canada(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 11: bz_holidays
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 12: bz_holidays_India
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_India(?)", binds: [v_BatchID]});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Calculate summary statistics from audit log
        var successStmt = snowflake.createStatement({
            sqlText: `SELECT 
                        COUNT(*),
                        COALESCE(SUM(records_inserted), 0)
                      FROM bronze.bz_Audit_Log
                      WHERE batch_id = ?
                        AND status = 'SUCCESS'`,
            binds: [v_BatchID]
        });
        var successResult = successStmt.execute();
        if (successResult.next()) {
            v_TablesSucceeded = successResult.getColumnValue(1);
            v_TotalRowsInserted = successResult.getColumnValue(2);
        }
        
        var failedStmt = snowflake.createStatement({
            sqlText: `SELECT 
                        COUNT(*),
                        COALESCE(SUM(records_failed), 0)
                      FROM bronze.bz_Audit_Log
                      WHERE batch_id = ?
                        AND status = 'FAILED'`,
            binds: [v_BatchID]
        });
        var failedResult = failedStmt.execute();
        if (failedResult.next()) {
            v_TablesFailed = failedResult.getColumnValue(1);
            v_TotalRowsFailed = failedResult.getColumnValue(2);
        }
        
        v_TotalRowsProcessed = v_TotalRowsInserted + (v_TotalRowsFailed || 0);
        
        // Calculate execution time
        var endTimeStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var endTimeResult = endTimeStmt.execute();
        endTimeResult.next();
        v_EndTime = endTimeResult.getColumnValue(1);
        
        var execTimeStmt = snowflake.createStatement({
            sqlText: "SELECT DATEDIFF(SECOND, ?, ?)",
            binds: [v_StartTime, v_EndTime]
        });
        var execTimeResult = execTimeStmt.execute();
        execTimeResult.next();
        v_ExecutionTime = execTimeResult.getColumnValue(1);
        
        // Log completion
        logMessage += '\n';
        logMessage += '================================================================================\n';
        logMessage += 'bronze Layer ETL Pipeline - Completed Successfully\n';
        logMessage += '================================================================================\n';
        logMessage += 'End Time: ' + v_EndTime + '\n';
        logMessage += 'Execution Time: ' + v_ExecutionTime + ' seconds\n';
        logMessage += 'Tables Processed: ' + v_TablesProcessed + '\n';
        logMessage += 'Tables Succeeded: ' + v_TablesSucceeded + '\n';
        logMessage += 'Tables Failed: ' + v_TablesFailed + '\n';
        logMessage += 'Total Rows Inserted: ' + v_TotalRowsInserted + '\n';
        logMessage += 'Total Rows Failed: ' + (v_TotalRowsFailed || 0) + '\n';
        logMessage += '================================================================================\n';
        
        // Insert master audit record
        var auditStmt = snowflake.createStatement({
            sqlText: `INSERT INTO bronze.bz_Audit_Log (
                        source_table,
                        target_table,
                        load_timestamp,
                        start_timestamp,
                        end_timestamp,
                        processed_by,
                        processing_time,
                        status,
                        records_processed,
                        records_inserted,
                        records_failed,
                        batch_id,
                        load_type,
                        created_date
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP())`,
            binds: [
                'source_layer.*',
                'bronze.*',
                v_StartTime,
                v_StartTime,
                v_EndTime,
                v_CurrentUser,
                v_ExecutionTime,
                v_OverallStatus,
                v_TotalRowsProcessed,
                v_TotalRowsInserted,
                v_TotalRowsFailed,
                v_BatchID,
                'FULL_REFRESH_ALL_TABLES'
            ]
        });
        auditStmt.execute();
        
        return logMessage;
        
    } catch (err) {
        // Capture error details
        v_ErrorMessage = err.message;
        v_ErrorNumber = err.code || 0;
        
        var endTimeStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var endTimeResult = endTimeStmt.execute();
        endTimeResult.next();
        v_EndTime = endTimeResult.getColumnValue(1);
        
        var execTimeStmt = snowflake.createStatement({
            sqlText: "SELECT DATEDIFF(SECOND, ?, ?)",
            binds: [v_StartTime, v_EndTime]
        });
        var execTimeResult = execTimeStmt.execute();
        execTimeResult.next();
        v_ExecutionTime = execTimeResult.getColumnValue(1);
        
        v_OverallStatus = 'FAILED';
        
        // Log error
        var errorLog = '';
        errorLog += '\n';
        errorLog += '================================================================================\n';
        errorLog += 'ERROR in bronze Layer ETL Pipeline\n';
        errorLog += '================================================================================\n';
        errorLog += 'Error Number: ' + v_ErrorNumber + '\n';
        errorLog += 'Error Message: ' + v_ErrorMessage + '\n';
        errorLog += '================================================================================\n';
        
        // Insert error audit record
        var errorAuditStmt = snowflake.createStatement({
            sqlText: `INSERT INTO bronze.bz_Audit_Log (
                        source_table,
                        target_table,
                        load_timestamp,
                        start_timestamp,
                        end_timestamp,
                        processed_by,
                        processing_time,
                        status,
                        error_message,
                        batch_id,
                        load_type,
                        created_date
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP())`,
            binds: [
                'source_layer.*',
                'bronze.*',
                v_StartTime,
                v_StartTime,
                v_EndTime,
                v_CurrentUser,
                v_ExecutionTime,
                v_OverallStatus,
                'Error ' + v_ErrorNumber + ': ' + v_ErrorMessage,
                v_BatchID,
                'FULL_REFRESH_ALL_TABLES'
            ]
        });
        errorAuditStmt.execute();
        
        // Re-throw error
        throw errorLog + '\n' + v_ErrorMessage;
    }
$$;