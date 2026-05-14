=============================================
Author: Ascendion AAVA
Created on:
Description: Stored procedure to orchestrate full refresh load of all bronze layer tables with audit logging and error handling

-- =========================================================
-- CONVERSION LOG
-- =========================================================
-- Input Type : Oracle Stored Procedure
-- Target Platform : Snowflake
-- Conversion Approach :
-- - Converted Oracle CREATE OR REPLACE PROCEDURE into Snowflake CREATE OR REPLACE PROCEDURE with JavaScript or SQL scripting
-- - Translated Oracle variable declarations (VARCHAR2, NUMBER, TIMESTAMP) into Snowflake equivalents (VARCHAR, NUMBER, TIMESTAMP_NTZ)
-- - Replaced Oracle SYSTIMESTAMP with Snowflake CURRENT_TIMESTAMP()
-- - Converted Oracle USER function into Snowflake CURRENT_USER()
-- - Replaced Oracle TO_CHAR date formatting with Snowflake TO_CHAR or TO_VARCHAR
-- - Converted Oracle DBMS_OUTPUT.PUT_LINE into Snowflake RETURN or result set logging
-- - Translated Oracle procedure calls into Snowflake CALL statements
-- - Converted Oracle EXTRACT function for date/time calculations into Snowflake DATEDIFF or TIMESTAMPDIFF
-- - Replaced Oracle NVL with Snowflake COALESCE or IFNULL
-- - Converted Oracle INSERT INTO statements into Snowflake INSERT INTO with matching syntax
-- - Translated Oracle COMMIT into Snowflake transaction control (auto-commit or explicit COMMIT)
-- - Replaced Oracle SQLERRM and SQLCODE with Snowflake SQLERRM and SQLCODE equivalents
-- - Converted Oracle RAISE_APPLICATION_ERROR into Snowflake RAISE exception handling
-- - Mapped Oracle exception handling (EXCEPTION WHEN OTHERS) into Snowflake exception blocks
-- Major Risks / Checks :
-- - Validate transaction control behavior differences between Oracle and Snowflake
-- - Validate exception handling and error propagation mechanisms
-- - Validate timestamp precision and timezone handling
-- - Validate procedure call syntax and parameter passing
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
    v_ErrorSeverity NUMBER;
    v_ErrorState NUMBER;
    v_ErrorLine NUMBER;
    v_TotalRowsProcessed NUMBER := 0;
    v_TotalRowsInserted NUMBER := 0;
    v_TotalRowsFailed NUMBER := 0;
    v_TablesProcessed NUMBER := 0;
    v_TablesSucceeded NUMBER := 0;
    v_TablesFailed NUMBER := 0;
    v_CurrentUser VARCHAR := CURRENT_USER();
    v_BatchID VARCHAR;
BEGIN
    v_BatchID := TO_VARCHAR(v_StartTime, 'YYYY-MM-DD HH24:MI:SS.FF3');
    
    -- CHECK REQUIRED:
    -- Oracle DBMS_OUTPUT.PUT_LINE converted to result logging or system$log in Snowflake.
    -- Validate logging mechanism for production use.
    
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
    
    -- CHECK REQUIRED:
    -- Oracle explicit COMMIT converted to Snowflake transaction control.
    -- Snowflake uses auto-commit by default; validate transaction requirements.
    
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
        v_ErrorSeverity := 0;
        v_ErrorState := 0;
        v_ErrorLine := 0;
        
        v_EndTime := CURRENT_TIMESTAMP();
        v_ExecutionTime := DATEDIFF(SECOND, v_StartTime, v_EndTime);
        v_OverallStatus := 'FAILED';
        
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
            'Error ' || TO_VARCHAR(v_ErrorNumber) || ': ' || v_ErrorMessage,
            :v_BatchID,
            'FULL_REFRESH_ALL_TABLES',
            CURRENT_TIMESTAMP()
        );
        
        -- CHECK REQUIRED:
        -- Oracle RAISE_APPLICATION_ERROR converted to Snowflake RAISE.
        -- Validate error propagation and exception handling behavior.
        
        RAISE;
        
END;
$$;