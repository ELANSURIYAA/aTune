CREATE OR REPLACE PROCEDURE bronze.usp_Load_bronze_Layer_Full
AS
    -- Variable declarations
    v_ProcedureName VARCHAR2(200) := 'bronze.usp_Load_bronze_Layer_Full';
    v_StartTime TIMESTAMP := SYSTIMESTAMP;
    v_EndTime TIMESTAMP;
    v_ExecutionTime NUMBER;
    v_OverallStatus VARCHAR2(50) := 'SUCCESS';
    v_ErrorMessage VARCHAR2(4000);
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
    v_CurrentUser VARCHAR2(100) := USER;
    v_BatchID VARCHAR2(100);
BEGIN
    v_BatchID := TO_CHAR(v_StartTime, 'YYYY-MM-DD HH24:MI:SS.FF3');
    
    -- Log start of overall process
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('bronze Layer ETL Pipeline - Started at: ' || TO_CHAR(v_StartTime, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    DBMS_OUTPUT.PUT_LINE('Executed by: ' || v_CurrentUser);
    DBMS_OUTPUT.PUT_LINE('Batch ID: ' || v_BatchID);
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Load Table 1: bz_New_Monthly_HC_Report
    bronze.usp_Load_bz_New_Monthly_HC_Report(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 2: bz_SchTask (excludes TIMESTAMP column)
    bronze.usp_Load_bz_SchTask(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 3: bz_Hiring_Initiator_Project_Info
    bronze.usp_Load_bz_Hiring_Initiator_Project_Info(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 4: bz_Timesheet_New
    bronze.usp_Load_bz_Timesheet_New(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 5: bz_report_392_all
    bronze.usp_Load_bz_report_392_all(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 6: bz_vw_billing_timesheet_daywise_ne
    bronze.usp_Load_bz_vw_billing_timesheet_daywise_ne(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 7: bz_vw_consultant_timesheet_daywise
    bronze.usp_Load_bz_vw_consultant_timesheet_daywise(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 8: bz_DimDate
    bronze.usp_Load_bz_DimDate(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 9: bz_holidays_Mexico
    bronze.usp_Load_bz_holidays_Mexico(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 10: bz_holidays_Canada
    bronze.usp_Load_bz_holidays_Canada(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 11: bz_holidays
    bronze.usp_Load_bz_holidays(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Load Table 12: bz_holidays_India
    bronze.usp_Load_bz_holidays_India(v_BatchID);
    v_TablesProcessed := v_TablesProcessed + 1;
    
    -- Calculate summary statistics from audit log
    SELECT 
        COUNT(*),
        NVL(SUM(records_inserted), 0)
    INTO
        v_TablesSucceeded,
        v_TotalRowsInserted
    FROM bronze.bz_Audit_Log
    WHERE batch_id = v_BatchID
        AND status = 'SUCCESS';
    
    SELECT 
        COUNT(*),
        NVL(SUM(records_failed), 0)
    INTO
        v_TablesFailed,
        v_TotalRowsFailed
    FROM bronze.bz_Audit_Log
    WHERE batch_id = v_BatchID
        AND status = 'FAILED';
    
    v_TotalRowsProcessed := v_TotalRowsInserted + NVL(v_TotalRowsFailed, 0);
    
    -- Calculate execution time
    v_EndTime := SYSTIMESTAMP;
    v_ExecutionTime := EXTRACT(DAY FROM (v_EndTime - v_StartTime)) * 86400 + 
                       EXTRACT(HOUR FROM (v_EndTime - v_StartTime)) * 3600 + 
                       EXTRACT(MINUTE FROM (v_EndTime - v_StartTime)) * 60 + 
                       EXTRACT(SECOND FROM (v_EndTime - v_StartTime));
    
    -- Log completion
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('bronze Layer ETL Pipeline - Completed Successfully');
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    DBMS_OUTPUT.PUT_LINE('End Time: ' || TO_CHAR(v_EndTime, 'YYYY-MM-DD HH24:MI:SS.FF3'));
    DBMS_OUTPUT.PUT_LINE('Execution Time: ' || TO_CHAR(v_ExecutionTime) || ' seconds');
    DBMS_OUTPUT.PUT_LINE('Tables Processed: ' || TO_CHAR(v_TablesProcessed));
    DBMS_OUTPUT.PUT_LINE('Tables Succeeded: ' || TO_CHAR(v_TablesSucceeded));
    DBMS_OUTPUT.PUT_LINE('Tables Failed: ' || TO_CHAR(v_TablesFailed));
    DBMS_OUTPUT.PUT_LINE('Total Rows Inserted: ' || TO_CHAR(v_TotalRowsInserted));
    DBMS_OUTPUT.PUT_LINE('Total Rows Failed: ' || TO_CHAR(NVL(v_TotalRowsFailed, 0)));
    DBMS_OUTPUT.PUT_LINE('================================================================================');
    
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
        SYSTIMESTAMP
    );
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Capture error details
        v_ErrorMessage := SQLERRM;
        v_ErrorNumber := SQLCODE;
        v_ErrorSeverity := 0;
        v_ErrorState := 0;
        v_ErrorLine := 0;
        
        v_EndTime := SYSTIMESTAMP;
        v_ExecutionTime := EXTRACT(DAY FROM (v_EndTime - v_StartTime)) * 86400 + 
                           EXTRACT(HOUR FROM (v_EndTime - v_StartTime)) * 3600 + 
                           EXTRACT(MINUTE FROM (v_EndTime - v_StartTime)) * 60 + 
                           EXTRACT(SECOND FROM (v_EndTime - v_StartTime));
        v_OverallStatus := 'FAILED';
        
        -- Log error
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('================================================================================');
        DBMS_OUTPUT.PUT_LINE('ERROR in bronze Layer ETL Pipeline');
        DBMS_OUTPUT.PUT_LINE('================================================================================');
        DBMS_OUTPUT.PUT_LINE('Error Number: ' || TO_CHAR(v_ErrorNumber));
        DBMS_OUTPUT.PUT_LINE('Error Severity: ' || TO_CHAR(v_ErrorSeverity));
        DBMS_OUTPUT.PUT_LINE('Error State: ' || TO_CHAR(v_ErrorState));
        DBMS_OUTPUT.PUT_LINE('Error Line: ' || TO_CHAR(v_ErrorLine));
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || v_ErrorMessage);
        DBMS_OUTPUT.PUT_LINE('================================================================================');
        
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
            'Error ' || TO_CHAR(v_ErrorNumber) || ': ' || v_ErrorMessage,
            v_BatchID,
            'FULL_REFRESH_ALL_TABLES',
            SYSTIMESTAMP
        );
        
        COMMIT;
        
        -- Re-throw error
        RAISE_APPLICATION_ERROR(-20001, v_ErrorMessage);
        
END bronze.usp_Load_bronze_Layer_Full;
