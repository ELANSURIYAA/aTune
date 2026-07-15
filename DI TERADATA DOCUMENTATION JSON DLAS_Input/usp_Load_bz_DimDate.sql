REPLACE PROCEDURE bronze.usp_Load_bz_DimDate (IN BatchID VARCHAR(100))
BEGIN
    DECLARE StartTime TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP(6);
    DECLARE EndTime TIMESTAMP(6);
    DECLARE ExecutionTime FLOAT;
    DECLARE RowsInserted BIGINT DEFAULT 0;
    DECLARE RowsSource BIGINT DEFAULT 0;
    DECLARE StatusVar VARCHAR(50) DEFAULT 'SUCCESS';
    DECLARE ErrorMessage VARCHAR(4000);
    DECLARE CurrentUser VARCHAR(100) DEFAULT USER;
    DECLARE SourceSystem VARCHAR(100) DEFAULT 'Teradata_Source';

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET EndTime = CURRENT_TIMESTAMP(6);
        GET DIAGNOSTICS EXCEPTION 1 ErrorMessage = MESSAGE_TEXT;
        SET StatusVar = 'FAILED';
        INSERT INTO bronze.bz_Audit_Log (
            source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
            processed_by, processing_time, status, records_processed, records_inserted,
            row_count_source, row_count_target, error_message, batch_id, load_type, created_date
        ) VALUES (
            'source_layer.DimDate', 'bronze.bz_DimDate', :StartTime, :StartTime, :EndTime,
            :CurrentUser, NULL, :StatusVar, :RowsSource, 0,
            :RowsSource, 0, :ErrorMessage, :BatchID, 'FULL_REFRESH', CURRENT_TIMESTAMP(6)
        );
        RESIGNAL;
    END;

    SELECT COUNT(*) INTO :RowsSource FROM source_layer.DimDate;
    DELETE FROM bronze.bz_DimDate ALL;

    INSERT INTO bronze.bz_DimDate (
        "Date", "DayOfMonth", "DayName", "WeekOfYear", "Month", "MonthName",
        "MonthOfQuarter", "Quarter", "QuarterName", "Year", "YearName", "MonthYear",
        "MMYYYY", "DaysInMonth", "MM-YYYY", "YYYYMM",
        "load_timestamp", "update_timestamp", "source_system"
    )
    SELECT 
        "Date", "DayOfMonth", "DayName", "WeekOfYear", "Month", "MonthName",
        "MonthOfQuarter", "Quarter", "QuarterName", "Year", "YearName", "MonthYear",
        "MMYYYY", "DaysInMonth", "MM-YYYY", "YYYYMM",
        CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6), :SourceSystem
    FROM source_layer.DimDate;

    SET RowsInserted = ACTIVITY_COUNT;
    SET EndTime = CURRENT_TIMESTAMP(6);
    SET ExecutionTime = (CAST(EndTime AS DATE) - CAST(StartTime AS DATE)) * 86400 
                      + (EXTRACT(HOUR FROM EndTime) - EXTRACT(HOUR FROM StartTime)) * 3600 
                      + (EXTRACT(MINUTE FROM EndTime) - EXTRACT(MINUTE FROM StartTime)) * 60 
                      + (EXTRACT(SECOND FROM EndTime) - EXTRACT(SECOND FROM StartTime));

    INSERT INTO bronze.bz_Audit_Log (
        source_table, target_table, load_timestamp, start_timestamp, end_timestamp,
        processed_by, processing_time, status, records_processed, records_inserted,
        row_count_source, row_count_target, error_message, batch_id, load_type, created_date
    ) VALUES (
        'source_layer.DimDate', 'bronze.bz_DimDate', :StartTime, :StartTime, :EndTime,
        :CurrentUser, :ExecutionTime, :StatusVar, :RowsSource, :RowsInserted,
        :RowsSource, :RowsInserted, NULL, :BatchID, 'FULL_REFRESH', CURRENT_TIMESTAMP(6)
    );
END;
