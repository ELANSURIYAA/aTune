=============================================
Author: Ascendion AAVA
Created on:
Description: Orchestrates full refresh ETL pipeline for bronze layer by sequentially loading 12 tables and logging execution metrics

=============================================

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Procedure
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle CREATE OR REPLACE PROCEDURE into Snowflake CREATE OR REPLACE PROCEDURE with JavaScript or SQL scripting
-- - Replaced Oracle variable declarations (VARCHAR2, NUMBER, TIMESTAMP) with Snowflake equivalents (VARCHAR, NUMBER, TIMESTAMP_NTZ)
-- - Converted Oracle SYSTIMESTAMP to Snowflake CURRENT_TIMESTAMP()
-- - Replaced Oracle USER function with Snowflake CURRENT_USER()
-- - Converted Oracle TO_CHAR date formatting to Snowflake TO_CHAR with equivalent format strings
-- - Replaced Oracle DBMS_OUTPUT.PUT_LINE with Snowflake SYSTEM$LOG or return statements
-- - Converted Oracle procedure calls into Snowflake CALL statements
-- - Translated Oracle SELECT INTO statements into Snowflake LET with SELECT syntax
-- - Replaced Oracle NVL function with Snowflake COALESCE or IFNULL
-- - Converted Oracle EXTRACT function for timestamp arithmetic into Snowflake DATEDIFF and TIMESTAMPDIFF
-- - Translated Oracle INSERT INTO statements into Snowflake INSERT INTO with matching column mappings
-- - Converted Oracle COMMIT statements into Snowflake transaction control (COMMIT)
-- - Replaced Oracle EXCEPTION WHEN OTHERS with Snowflake EXCEPTION block
-- - Converted Oracle SQLERRM and SQLCODE into Snowflake SQLERRM and SQLCODE equivalents
-- - Replaced Oracle RAISE_APPLICATION_ERROR with Snowflake RAISE or RETURN error handling
-- Major Risks / Checks :
-- - Validate DBMS_OUTPUT.PUT_LINE replacement strategy (Snowflake does not have direct equivalent)
-- - Validate timestamp arithmetic conversion accuracy
-- - Validate exception handling behavior differences
-- - Validate transaction control and COMMIT behavior
-- - Validate nested procedure call execution order
-- =========================================================

CREATE OR REPLACE PROCEDURE bronze.usp_Load_bronze_Layer_Full()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    v_ProcedureName VARCHAR := 'bronze.usp_Load_bronze_Layer_Full';
    v_StartTime TIMESTAMP_NTZ := CURRENT_TIMESTAMP();
    v_EndTime TIMESTAMP_NTZ;
    v_ExecutionTime NUMBER;
    v_OverallStatus VARCHAR := 'SUCCESS';
    v_ErrorMessage VARCHAR;
    v_ErrorNumber NUMBER;
    v_ErrorSeverity NUMBER := 0;
    v_ErrorState NUMBER := 0;
    v_ErrorLine NUMBER := 0;
    v_TotalRowsProcessed NUMBER := 0;
    v_TotalRowsInserted NUMBER := 0;
    v_TotalRowsFailed NUMBER := 0;
    v_TablesProcessed NUMBER := 0;
    v_TablesSucceeded NUMBER := 0;
    v_TablesFailed NUMBER := 0;
    v_CurrentUser VARCHAR := CURRENT_USER();
    v_BatchID VARCHAR;
BEGIN
    v_BatchID := TO_CHAR(v_StartTime, 'YYYY-MM-DD HH24:MI:SS.FF3');
    
    -- CHECK REQUIRED:
    -- Oracle DBMS_OUTPUT.PUT_LINE converted to comments or logging mechanism.
    -- Snowflake does not have direct equivalent; consider using SYSTEM$LOG or application-layer logging.
    
    -- Log start of overall process
    -- ================================================================================
    -- bronze Layer ETL Pipeline - Started at: v_StartTime
    -- Executed by: v_CurrentUser
    -- Batch ID: v_BatchID
    -- ================================================================================
    
    -- Load Table 1: bz_New_Monthly_HC_Report
    CALL bronze.usp_Load_bz_New_Monthly_HC_Report(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 2: bz_SchTask (excludes TIMESTAMP column)
    CALL bronze.usp_Load_bz_SchTask(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 3: bz_Hiring_Initiator_Project_Info
    CALL bronze.usp_Load_bz_Hiring_Initiator_Project_Info(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 4: bz_Timesheet_New
    CALL bronze.usp_Load_bz_Timesheet_New(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 5: bz_report_392_all
    CALL bronze.usp_Load_bz_report_392_all(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 6: bz_vw_billing_timesheet_daywise_ne
    CALL bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 7: bz_vw_consultant_timesheet_daywise
    CALL bronze.usp_Load_bz_vw_consultant_timesheet_daywise(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 8: bz_DimDate
    CALL bronze.usp_Load_bz_DimDate(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 9: bz_holidays_Mexico
    CALL bronze.usp_Load_bz_holidays_Mexico(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 10: bz_holidays_Canada
    CALL bronze.usp_Load_bz_holidays_Canada(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 11: bz_holidays
    CALL bronze.usp_Load_bz_holidays(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 12: bz_holidays_India
    CALL bronze.usp_Load_bz_holidays_India(:v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Calculate summary statistics from audit log
    SELECT 
        COUNT(*),
        COALESCE(SUM(records_inserted), 0)
    INTO
        v_TablesSucceeded,
        v_TotalRowsInserted
    FROM bronze.bz_Audit_Log
    WHERE batch_id = :v_BatchID
        AND status = 'SUCCESS';
    
    SELECT 
        COUNT(*),
        COALESCE(SUM(records_failed), 0)
    INTO
        v_TablesFailed,
        v_TotalRowsFailed
    FROM bronze.bz_Audit_Log
    WHERE batch_id = :v_BatchID
        AND status = 'FAILED';
    
    v_TotalRowsProcessed := v_TotalRowsInserted + COALESCE(v_TotalRowsFailed, 0);
    
    -- Calculate execution time
    v_EndTime := CURRENT_TIMESTAMP();
    v_ExecutionTime := DATEDIFF(SECOND, v_StartTime, v_EndTime);
    
    -- CHECK REQUIRED:
    -- Oracle timestamp arithmetic using EXTRACT converted to Snowflake DATEDIFF.
    -- Validate that execution time calculation preserves accuracy.
    
    -- Log completion
    -- ================================================================================
    -- bronze Layer ETL Pipeline - Completed Successfully
    -- ================================================================================
    -- End Time: v_EndTime
    -- Execution Time: v_ExecutionTime seconds
    -- Tables Processed: v_TablesProcessed
    -- Tables Succeeded: v_TablesSucceeded
    -- Tables Failed: v_TablesFailed
    -- Total Rows Inserted: v_TotalRowsInserted
    -- Total Rows Failed: v_TotalRowsFailed
    -- ================================================================================
    
    -- Insert master audit record
    INSERT INTO bronze.bz_Audit_Log (
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
        :v_StartTime,
        :v_StartTime,
        :v_EndTime,
        :v_CurrentUser,
        :v_ExecutionTime,
        :v_OverallStatus,
        :v_TotalRowsProcessed,
        :v_TotalRowsInserted,
        :v_TotalRowsFailed,
        :v_BatchID,
        'FULL_REFRESH_ALL_TABLES',
        CURRENT_TIMESTAMP()
    );
    
    COMMIT;
    
    RETURN 'SUCCESS: bronze Layer ETL Pipeline completed successfully';
    
EXCEPTION
    WHEN OTHER THEN
        -- Capture error details
        v_ErrorMessage := SQLERRM;
        v_ErrorNumber := SQLCODE;
        v_ErrorSeverity := 0;
        v_ErrorState := 0;
        v_ErrorLine := 0;
        
        v_EndTime := CURRENT_TIMESTAMP();
        v_ExecutionTime := DATEDIFF(SECOND, v_StartTime, v_EndTime);
        v_OverallStatus := 'FAILED';
        
        -- CHECK REQUIRED:
        -- Oracle SQLERRM and SQLCODE converted to Snowflake equivalents.
        -- Validate error message capture behavior.
        
        -- Log error
        -- ================================================================================
        -- ERROR in bronze Layer ETL Pipeline
        -- ================================================================================
        -- Error Number: v_ErrorNumber
        -- Error Severity: v_ErrorSeverity
        -- Error State: v_ErrorState
        -- Error Line: v_ErrorLine
        -- Error Message: v_ErrorMessage
        -- ================================================================================
        
        -- Insert error audit record
        INSERT INTO bronze.bz_Audit_Log (
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
            :v_StartTime,
            :v_StartTime,
            :v_EndTime,
            :v_CurrentUser,
            :v_ExecutionTime,
            :v_OverallStatus,
            'Error ' || TO_CHAR(v_ErrorNumber) || ': ' || v_ErrorMessage,
            :v_BatchID,
            'FULL_REFRESH_ALL_TABLES',
            CURRENT_TIMESTAMP()
        );
        
        COMMIT;
        
        -- CHECK REQUIRED:
        -- Oracle RAISE_APPLICATION_ERROR converted to Snowflake RETURN with error message.
        -- Validate error propagation behavior.
        
        RETURN 'FAILED: ' || v_ErrorMessage;
        
END;
$$;