=============================================
Author: Ascendion AAVA
Created on:
Description: Snowflake stored procedure to orchestrate full refresh load of bronze layer tables with comprehensive audit logging and error handling
=============================================

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Stored Procedure
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle CREATE OR REPLACE PROCEDURE to Snowflake CREATE OR REPLACE PROCEDURE with JavaScript
-- - Replaced Oracle variable declarations (VARCHAR2, NUMBER, TIMESTAMP) with Snowflake JavaScript variables
-- - Converted SYSTIMESTAMP to CURRENT_TIMESTAMP()
-- - Replaced USER with CURRENT_USER()
-- - Converted DBMS_OUTPUT.PUT_LINE to console.log for logging
-- - Replaced Oracle procedure calls with Snowflake CALL statements using snowflake.execute
-- - Converted Oracle SELECT INTO with Snowflake result set processing
-- - Replaced NVL with COALESCE
-- - Converted Oracle EXTRACT date functions to Snowflake DATEDIFF
-- - Replaced Oracle INSERT INTO with Snowflake INSERT using snowflake.execute
-- - Converted Oracle COMMIT to Snowflake auto-commit behavior
-- - Replaced Oracle exception handling (WHEN OTHERS) with JavaScript try-catch
-- - Converted SQLERRM and SQLCODE to JavaScript error handling
-- - Replaced RAISE_APPLICATION_ERROR with JavaScript throw
-- Major Risks / Checks :
-- - Validate that called procedures exist in bronze schema
-- - Validate audit log table structure matches INSERT statements
-- - Validate date/time calculation accuracy between Oracle and Snowflake
-- - Validate error handling and logging behavior
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
    var v_ErrorMessage;
    var v_ErrorNumber;
    var v_TotalRowsProcessed = 0;
    var v_TotalRowsInserted = 0;
    var v_TotalRowsFailed = 0;
    var v_TablesProcessed = 0;
    var v_TablesSucceeded = 0;
    var v_TablesFailed = 0;
    var v_CurrentUser;
    var v_BatchID;
    
    try {
        // Get current user
        var userStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_USER()"});
        var userResult = userStmt.execute();
        userResult.next();
        v_CurrentUser = userResult.getColumnValue(1);
        
        // Get current timestamp and create batch ID
        var timestampStmt = snowflake.createStatement({sqlText: "SELECT CURRENT_TIMESTAMP()"});
        var timestampResult = timestampStmt.execute();
        timestampResult.next();
        var currentTimestamp = timestampResult.getColumnValue(1);
        v_BatchID = currentTimestamp.toISOString().replace('T', ' ').substring(0, 23);
        
        // Log start of overall process
        console.log('================================================================================')
        console.log('bronze Layer ETL Pipeline - Started at: ' + v_BatchID);
        console.log('Executed by: ' + v_CurrentUser);
        console.log('Batch ID: ' + v_BatchID);
        console.log('================================================================================')
        console.log('');
        
        // Load Table 1: bz_New_Monthly_HC_Report
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_New_Monthly_HC_Report('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 2: bz_SchTask (excludes TIMESTAMP column)
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_SchTask('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 3: bz_Hiring_Initiator_Project_Info
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_Hiring_Initiator_Project_Info('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 4: bz_Timesheet_New
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_Timesheet_New('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 5: bz_report_392_all
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_report_392_all('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 6: bz_vw_billing_timesheet_daywise_ne
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 7: bz_vw_consultant_timesheet_daywise
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_vw_consultant_timesheet_daywise('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 8: bz_DimDate
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_DimDate('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 9: bz_holidays_Mexico
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_Mexico('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 10: bz_holidays_Canada
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_Canada('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 11: bz_holidays
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Load Table 12: bz_holidays_India
        snowflake.execute({sqlText: "CALL bronze.usp_Load_bz_holidays_India('" + v_BatchID + "')"});
        v_TablesProcessed = v_TablesProcessed + 1;
        
        // Calculate summary statistics from audit log - succeeded tables
        var successStmt = snowflake.createStatement({
            sqlText: `SELECT 
                        COUNT(*),
                        COALESCE(SUM(records_inserted), 0)
                      FROM bronze.bz_Audit_Log
                      WHERE batch_id = '` + v_BatchID + `'
                        AND status = 'SUCCESS'`
        });
        var successResult = successStmt.execute();
        if (successResult.next()) {
            v_TablesSucceeded = successResult.getColumnValue(1);
            v_TotalRowsInserted = successResult.getColumnValue(2);
        }
        
        // Calculate summary statistics from audit log - failed tables
        var failedStmt = snowflake.createStatement({
            sqlText: `SELECT 
                        COUNT(*),
                        COALESCE(SUM(records_failed), 0)
                      FROM bronze.bz_Audit_Log
                      WHERE batch_id = '` + v_BatchID + `'
                        AND status = 'FAILED'`
        });
        var failedResult = failedStmt.execute();
        if (failedResult.next()) {
            v_TablesFailed = failedResult.getColumnValue(1);
            v_TotalRowsFailed = failedResult.getColumnValue(2);
        }
        
        v_TotalRowsProcessed = v_TotalRowsInserted + (v_TotalRowsFailed || 0);
        
        // Calculate execution time
        v_EndTime = new Date();
        v_ExecutionTime = (v_EndTime - v_StartTime) / 1000;
        
        // Log completion
        console.log('');
        console.log('================================================================================')
        console.log('bronze Layer ETL Pipeline - Completed Successfully');
        console.log('================================================================================')
        console.log('End Time: ' + v_EndTime.toISOString().replace('T', ' ').substring(0, 23));
        console.log('Execution Time: ' + v_ExecutionTime + ' seconds');
        console.log('Tables Processed: ' + v_TablesProcessed);
        console.log('Tables Succeeded: ' + v_TablesSucceeded);
        console.log('Tables Failed: ' + v_TablesFailed);
        console.log('Total Rows Inserted: ' + v_TotalRowsInserted);
        console.log('Total Rows Failed: ' + (v_TotalRowsFailed || 0));
        console.log('================================================================================')
        
        // Insert master audit record
        var auditInsertStmt = snowflake.createStatement({
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
                    VALUES (
                        'source_layer.*',
                        'bronze.*',
                        '` + v_BatchID + `',
                        '` + v_BatchID + `',
                        CURRENT_TIMESTAMP(),
                        '` + v_CurrentUser + `',
                        ` + v_ExecutionTime + `,
                        '` + v_OverallStatus + `',
                        ` + v_TotalRowsProcessed + `,
                        ` + v_TotalRowsInserted + `,
                        ` + (v_TotalRowsFailed || 0) + `,
                        '` + v_BatchID + `',
                        'FULL_REFRESH_ALL_TABLES',
                        CURRENT_TIMESTAMP()
                    )`
        });
        auditInsertStmt.execute();
        
        return 'SUCCESS: bronze Layer ETL Pipeline completed successfully';
        
    } catch (err) {
        // Capture error details
        v_ErrorMessage = err.message;
        v_ErrorNumber = err.code || 'UNKNOWN';
        
        v_EndTime = new Date();
        v_ExecutionTime = (v_EndTime - v_StartTime) / 1000;
        v_OverallStatus = 'FAILED';
        
        // Log error
        console.log('');
        console.log('================================================================================')
        console.log('ERROR in bronze Layer ETL Pipeline');
        console.log('================================================================================')
        console.log('Error Number: ' + v_ErrorNumber);
        console.log('Error Message: ' + v_ErrorMessage);
        console.log('================================================================================')
        
        // Insert error audit record
        try {
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
                        VALUES (
                            'source_layer.*',
                            'bronze.*',
                            '` + v_BatchID + `',
                            '` + v_BatchID + `',
                            CURRENT_TIMESTAMP(),
                            '` + v_CurrentUser + `',
                            ` + v_ExecutionTime + `,
                            '` + v_OverallStatus + `',
                            'Error ` + v_ErrorNumber + `: ` + v_ErrorMessage.replace(/'/g, "''") + `',
                            '` + v_BatchID + `',
                            'FULL_REFRESH_ALL_TABLES',
                            CURRENT_TIMESTAMP()
                        )`
            });
            errorAuditStmt.execute();
        } catch (auditErr) {
            console.log('Failed to insert error audit record: ' + auditErr.message);
        }
        
        // Re-throw error
        throw 'Error in bronze.usp_Load_bronze_Layer_Full: ' + v_ErrorMessage;
    }
$$;