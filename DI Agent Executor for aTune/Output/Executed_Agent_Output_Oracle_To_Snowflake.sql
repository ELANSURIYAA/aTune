=============================================
Author: Ascendion AAVA
Created on:
Description: Orchestrates full refresh ETL pipeline for bronze layer by sequentially loading 12 tables and logging execution metrics

=============================================

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Stored Procedure
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle CREATE OR REPLACE PROCEDURE into Snowflake CREATE OR REPLACE PROCEDURE with JavaScript or SQL scripting
-- - Replaced Oracle variable declarations (VARCHAR2, NUMBER, TIMESTAMP) with Snowflake equivalents (VARCHAR, NUMBER, TIMESTAMP_NTZ)
-- - Converted SYSTIMESTAMP to CURRENT_TIMESTAMP()
-- - Replaced USER with CURRENT_USER()
-- - Converted Oracle TO_CHAR date formatting to Snowflake TO_CHAR with equivalent format strings
-- - Replaced DBMS_OUTPUT.PUT_LINE with Snowflake equivalent logging or RETURN statements
-- - Converted Oracle procedure calls to Snowflake CALL statements
-- - Replaced Oracle EXTRACT function for timestamp arithmetic with Snowflake DATEDIFF and TIMESTAMPDIFF
-- - Converted Oracle NVL to Snowflake COALESCE or IFNULL
-- - Translated Oracle INSERT INTO with SELECT aggregations to Snowflake INSERT INTO SELECT
-- - Replaced Oracle COMMIT with Snowflake COMMIT (transaction control)
-- - Converted Oracle exception handling (EXCEPTION WHEN OTHERS) to Snowflake exception handling using BEGIN...EXCEPTION blocks
-- - Replaced SQLERRM and SQLCODE with Snowflake SQLERRM and SQLCODE equivalents
-- - Converted RAISE_APPLICATION_ERROR to Snowflake RAISE or RETURN with error message
-- Major Risks / Checks :
-- - Validate transaction behavior differences between Oracle and Snowflake
-- - Validate timestamp arithmetic and date formatting functions
-- - Validate exception handling and error propagation
-- - Validate procedure call syntax and parameter passing
-- - Validate logging mechanism as DBMS_OUTPUT is not available in Snowflake
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
    -- Oracle DBMS_OUTPUT.PUT_LINE converted to comments or logging table inserts.
    -- Snowflake does not have direct console output; consider using a logging table or RETURN statements.
    
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
    v_EndTime := CURRENT_TIMESTAMP();
    v_ExecutionTime := DATEDIFF(SECOND, v_StartTime, v_EndTime);
    
    -- CHECK REQUIRED:
    -- Oracle EXTRACT function for timestamp arithmetic converted to Snowflake DATEDIFF.
    -- Validate that execution time calculation matches Oracle behavior.
    
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
    
    RETURN 'bronze Layer ETL Pipeline completed successfully. Batch ID: ' || v_BatchID || 
           ', Tables Processed: ' || v_TablesProcessed || 
           ', Tables Succeeded: ' || v_TablesSucceeded || 
           ', Tables Failed: ' || v_TablesFailed || 
           ', Total Rows Inserted: ' || v_TotalRowsInserted || 
           ', Total Rows Failed: ' || COALESCE(v_TotalRowsFailed, 0) || 
           ', Execution Time: ' || v_ExecutionTime || ' seconds';
    
EXCEPTION
    WHEN OTHER THEN
        -- Capture error details
        v_ErrorMessage := SQLERRM;
        v_ErrorNumber := SQLCODE;
        
        v_EndTime := CURRENT_TIMESTAMP();
        v_ExecutionTime := DATEDIFF(SECOND, v_StartTime, v_EndTime);
        v_OverallStatus := 'FAILED';
        
        -- CHECK REQUIRED:
        -- Oracle SQLERRM and SQLCODE converted to Snowflake equivalents.
        -- Validate error message format and error number handling.
        
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
        
        -- CHECK REQUIRED:
        -- Oracle RAISE_APPLICATION_ERROR converted to Snowflake RETURN with error message.
        -- Snowflake does not support RAISE_APPLICATION_ERROR; use RETURN or custom exception handling.
        
        RETURN 'ERROR in bronze Layer ETL Pipeline - Error Number: ' || v_ErrorNumber || 
               ', Error Message: ' || v_ErrorMessage;
        
END;
$$;