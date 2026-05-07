=============================================
Author: Ascendion AAVA
Created on:
Description: Master orchestration procedure for loading all bronze layer tables with full refresh, including audit logging and error handling
=============================================

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Stored Procedure
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle CREATE OR REPLACE PROCEDURE to Snowflake CREATE OR REPLACE PROCEDURE syntax
-- - Replaced Oracle variable declarations (VARCHAR2, NUMBER, TIMESTAMP) with Snowflake equivalents (VARCHAR, NUMBER, TIMESTAMP_NTZ)
-- - Converted SYSTIMESTAMP to CURRENT_TIMESTAMP()
-- - Replaced USER function with CURRENT_USER()
-- - Converted TO_CHAR date formatting to Snowflake TO_CHAR with compatible format strings
-- - Replaced DBMS_OUTPUT.PUT_LINE with Snowflake SYSTEM$LOG or inline comments for logging
-- - Converted Oracle EXTRACT function for timestamp arithmetic to Snowflake DATEDIFF and TIMESTAMPDIFF
-- - Replaced NVL with COALESCE for NULL handling
-- - Converted Oracle SQLERRM and SQLCODE to Snowflake SQLERRM and SQLSTATE
-- - Replaced RAISE_APPLICATION_ERROR with Snowflake RAISE exception syntax
-- - Converted Oracle INSERT INTO with VALUES to Snowflake INSERT INTO syntax
-- - Maintained procedural logic structure with BEGIN/END blocks
-- - Converted Oracle COMMIT to Snowflake COMMIT
-- Major Risks / Checks :
-- - Validate TIMESTAMP_NTZ vs TIMESTAMP_LTZ behavior for audit timestamps
-- - Validate date arithmetic conversion accuracy between Oracle EXTRACT and Snowflake DATEDIFF
-- - Validate error handling behavior differences between Oracle and Snowflake
-- - Validate that called sub-procedures exist in Snowflake bronze schema
-- - Validate audit log table structure matches INSERT statements
-- =========================================================

CREATE OR REPLACE PROCEDURE bronze.usp_Load_bronze_Layer_Full()
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
DECLARE
    -- Variable declarations
    v_ProcedureName VARCHAR(200) DEFAULT 'bronze.usp_Load_bronze_Layer_Full';
    v_StartTime TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP();
    v_EndTime TIMESTAMP_NTZ;
    v_ExecutionTime NUMBER;
    v_OverallStatus VARCHAR(50) DEFAULT 'SUCCESS';
    v_ErrorMessage VARCHAR(4000);
    v_ErrorNumber VARCHAR(100);
    v_ErrorSeverity NUMBER;
    v_ErrorState NUMBER;
    v_ErrorLine NUMBER;
    v_TotalRowsProcessed NUMBER DEFAULT 0;
    v_TotalRowsInserted NUMBER DEFAULT 0;
    v_TotalRowsFailed NUMBER DEFAULT 0;
    v_TablesProcessed NUMBER DEFAULT 0;
    v_TablesSucceeded NUMBER DEFAULT 0;
    v_TablesFailed NUMBER DEFAULT 0;
    v_CurrentUser VARCHAR(100) DEFAULT CURRENT_USER();
    v_BatchID VARCHAR(100);
BEGIN
    v_BatchID := TO_CHAR(v_StartTime, 'YYYY-MM-DD HH24:MI:SS.FF3');
    
    -- Log start of overall process
    -- CHECK REQUIRED:
    -- Oracle DBMS_OUTPUT.PUT_LINE converted to inline comments.
    -- For production logging, implement Snowflake SYSTEM$LOG or external logging mechanism.
    -- ================================================================================
    -- bronze Layer ETL Pipeline - Started at: v_StartTime
    -- Executed by: v_CurrentUser
    -- Batch ID: v_BatchID
    -- ================================================================================
    
    -- Load Table 1: bz_New_Monthly_HC_Report
    CALL bronze.usp_Load_bz_New_Monthly_HC_Report(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 2: bz_SchTask (excludes TIMESTAMP column)
    CALL bronze.usp_Load_bz_SchTask(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 3: bz_Hiring_Initiator_Project_Info
    CALL bronze.usp_Load_bz_Hiring_Initiator_Project_Info(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 4: bz_Timesheet_New
    CALL bronze.usp_Load_bz_Timesheet_New(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 5: bz_report_392_all
    CALL bronze.usp_Load_bz_report_392_all(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 6: bz_vw_billing_timesheet_daywise_ne
    CALL bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 7: bz_vw_consultant_timesheet_daywise
    CALL bronze.usp_Load_bz_vw_consultant_timesheet_daywise(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 8: bz_DimDate
    CALL bronze.usp_Load_bz_DimDate(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 9: bz_holidays_Mexico
    CALL bronze.usp_Load_bz_holidays_Mexico(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 10: bz_holidays_Canada
    CALL bronze.usp_Load_bz_holidays_Canada(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 11: bz_holidays
    CALL bronze.usp_Load_bz_holidays(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 12: bz_holidays_India
    CALL bronze.usp_Load_bz_holidays_India(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Calculate summary statistics from audit log
    SELECT 
        COUNT(*),
        COALESCE(SUM(records_inserted), 0)
    INTO
        v_TablesSucceeded,
        v_TotalRowsInserted
    FROM bronze.bz_Audit_Log
    WHERE batch_id = v_BatchID
        AND status = 'SUCCESS';
    
    SELECT 
        COUNT(*),
        COALESCE(SUM(records_failed), 0)
    INTO
        v_TablesFailed,
        v_TotalRowsFailed
    FROM bronze.bz_Audit_Log
    WHERE batch_id = v_BatchID
        AND status = 'FAILED';
    
    v_TotalRowsProcessed := v_TotalRowsInserted + COALESCE(v_TotalRowsFailed, 0);
    
    -- Calculate execution time
    -- CHECK REQUIRED:
    -- Oracle EXTRACT-based timestamp arithmetic converted to Snowflake DATEDIFF.
    -- Validate that execution time calculation produces equivalent results.
    v_EndTime := CURRENT_TIMESTAMP();
    v_ExecutionTime := DATEDIFF(SECOND, v_StartTime, v_EndTime);
    
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
        'FULL_REFRESH_ALL_TABLES',
        CURRENT_TIMESTAMP()
    );
    
    COMMIT;
    
    RETURN 'SUCCESS';
    
EXCEPTION
    WHEN OTHER THEN
        -- Capture error details
        -- CHECK REQUIRED:
        -- Oracle SQLERRM and SQLCODE converted to Snowflake SQLERRM and SQLSTATE.
        -- Validate error message format and error code mapping.
        v_ErrorMessage := SQLERRM;
        v_ErrorNumber := SQLSTATE;
        v_ErrorSeverity := 0;
        v_ErrorState := 0;
        v_ErrorLine := 0;
        
        v_EndTime := CURRENT_TIMESTAMP();
        v_ExecutionTime := DATEDIFF(SECOND, v_StartTime, v_EndTime);
        v_OverallStatus := 'FAILED';
        
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
            v_StartTime,
            v_StartTime,
            v_EndTime,
            v_CurrentUser,
            v_ExecutionTime,
            v_OverallStatus,
            'Error ' || v_ErrorNumber || ': ' || v_ErrorMessage,
            v_BatchID,
            'FULL_REFRESH_ALL_TABLES',
            CURRENT_TIMESTAMP()
        );
        
        COMMIT;
        
        -- Re-throw error
        -- CHECK REQUIRED:
        -- Oracle RAISE_APPLICATION_ERROR converted to Snowflake RAISE.
        -- Validate exception handling behavior in calling context.
        RAISE;
        
END;
$$;