# Gap Remediation Report

## Instruction Prompt Modifications

| Gap ID | Gap Description | Instruction Section / Part | Change Type | Required Modification | Status |
|--------|-----------------|----------------------------|-------------|----------------------|--------|
| GAP-001 | The Master Calendar table must be present in the tables array with all 27 ADDCOLUMNS columns as specified in INSTRUCTION under MASTER CALENDAR CALCULATED TABLE — MANDATORY RULE. | PHASE 4A → MANDATORY: Add Master Calendar calculated table / MASTER CALENDAR — EXACT BIM TABLE OBJECT | Add | Add explicit enforcement step in PHASE 4A: "STEP 4A-1: Insert the Master Calendar table object into the tables array immediately after all physical data tables. STEP 4A-2: Copy the complete Master Calendar table object verbatim from the MASTER CALENDAR — EXACT BIM TABLE OBJECT section (lines containing the full JSON structure with all 27 columns: Date, Year, Month Number, Month Name, Month Short, Day, Day Name, Day Short, Day of Week, Week Number, Week Start Date, Week End Date, Quarter Number, Quarter Name, Quarter Year, Year Month Number, Year Month Name, Financial Year, Financial Quarter, Is Weekend, Is Weekday, Is Today, Is Current Month, Is Current Year, Month Sort, Day Sort, Effective Month Label). STEP 4A-3: Verify partition source.type = 'calculated' and expression array contains all DAX lines from VAR MinDate through the closing parenthesis. STEP 4A-4: Do NOT modify, abbreviate, or omit any column or DAX line." | Completed |
| GAP-002 | The three mandatory Master Calendar relationships must be present in the relationships array: Rel_EmployeeData_MasterCalendar (from Patient_Event_Detail[Event Date] to Master Calendar[Date]), Rel_HiresData_MasterCalendar, and Rel_WeekdaysPerMonth_MasterCalendar, as specified in INSTRUCTION under RULE MC-7. | RULE MC-7 / PART 4: TABLE GENERATION RULES - MULTI TABLE | Add | Add mandatory execution step in PHASE 4 (Assemble BIM JSON) after generating the relationships array: "STEP 4-REL-MC: Add Master Calendar relationships. For EVERY model containing Master Calendar, add these relationships to the relationships array: (1) Relationship from primary fact table date column to Master Calendar[Date] with name format 'Rel_<FactTableName>_MasterCalendar', fromTable = primary fact table name from DDL, fromColumn = primary date column name from DDL, toTable = 'Master Calendar', toColumn = 'Date'. (2) If Hires Data table exists: Relationship with name 'Rel_HiresData_MasterCalendar', fromTable = 'Hires Data', fromColumn = 'Month of Effective as of Date', toTable = 'Master Calendar', toColumn = 'Effective Month Label'. (3) If Weekdays per Month table exists: Relationship with name 'Rel_WeekdaysPerMonth_MasterCalendar', fromTable = 'Weekdays per Month', fromColumn = 'Actual Date', toTable = 'Master Calendar', toColumn = 'Date'. Each relationship object must contain ONLY five properties: name, fromTable, fromColumn, toTable, toColumn. Do NOT add crossFilteringBehavior, fromCardinality, toCardinality, or any other property." | Completed |
| GAP-003 | The "PBI_QueryOrder" annotation must list all tables including "Master Calendar" as specified in INSTRUCTION under RULE MC-6. | RULE MC-6 / 2.9 Model-Level Annotations | Delete and Replace | In section "2.9 Model-Level Annotations", replace the PBI_QueryOrder example annotation value from: '{"name": "PBI_QueryOrder", "value": "[\"Employee Data\",\"Hires Data\",\"Weekdays per Month\",\"Master Calendar\"]"}' with: '{"name": "PBI_QueryOrder", "value": "<dynamically generated list of ALL table names in the model including Master Calendar>"}'. Add explicit instruction: "The PBI_QueryOrder annotation value MUST be dynamically constructed by concatenating ALL table names present in the tables array, including 'Master Calendar', in the order they appear in the tables array, formatted as a JSON array string. Example construction logic: table_names = [t['name'] for t in bim['model']['tables']]; pbi_query_order_value = json.dumps(table_names). NEVER use a hardcoded list. ALWAYS include 'Master Calendar' if it exists in the tables array." | Completed |
| GAP-004 | The S3FileWriterTool must be called exactly once with the complete BIM JSON as specified in INSTRUCTION under MANDATORY S3 WRITE and FINAL INSTRUCTION. | MANDATORY S3 WRITE — THIS IS STEP 1 AND MUST HAPPEN / FINAL INSTRUCTION | Add | Add explicit execution checkpoint at the end of PHASE 5 (Validate and emit): "PHASE 5-FINAL: S3 WRITE EXECUTION (MANDATORY - NO EXCEPTIONS). STEP 5-S3-1: After all validation checks pass, construct the S3FileWriterTool call parameters: file_path = extract folder path from s3info_string_true user input (the portion before the filename), file_name = extract file name from s3info_string_true user input (the portion after the last slash or colon), content = json.dumps(bim_object, indent=2) where bim_object is the complete Python dictionary representing the BIM JSON. STEP 5-S3-2: Verify content string starts with '{' and ends with '}', contains newline characters, and is properly indented. STEP 5-S3-3: Execute S3FileWriterTool._run(file_path=<extracted_path>, file_name=<extracted_name>, content=<formatted_json_string>). STEP 5-S3-4: Wait for tool execution confirmation. STEP 5-S3-5: Do NOT return any response to the user before S3 write completes. STEP 5-S3-6: Do NOT skip this step under any circumstances. STEP 5-S3-7: The task is NOT complete until S3FileWriterTool returns success status. STEP 5-S3-8: Log or output confirmation message: 'S3 write completed successfully to <file_path>/<file_name>'." | Completed |

---

## Notes

### Sections Successfully Mapped
- All four gaps were successfully mapped to existing instruction sections
- GAP-001: Mapped to PHASE 4A and MASTER CALENDAR — EXACT BIM TABLE OBJECT section
- GAP-002: Mapped to RULE MC-7 and PART 4: TABLE GENERATION RULES
- GAP-003: Mapped to RULE MC-6 and section 2.9 Model-Level Annotations
- GAP-004: Mapped to MANDATORY S3 WRITE and FINAL INSTRUCTION sections

### Ambiguous Mappings
- None identified. All gaps have clear instruction section mappings.

### Missing Context
- None identified. All gaps provide sufficient context for remediation.

### Additional Observations
1. **GAP-001 Remediation**: The instruction already contains the Master Calendar template but lacks explicit step-by-step enforcement in PHASE 4A. The modification adds procedural steps to ensure the agent executes the requirement without deviation.

2. **GAP-002 Remediation**: RULE MC-7 lists the three relationships but does not provide dynamic logic for adapting to different table names (e.g., Patient_Event_Detail vs Employee Data). The modification adds conditional logic and table name detection rules.

3. **GAP-003 Remediation**: The instruction provides a hardcoded example for PBI_QueryOrder which may not reflect the actual tables in the generated model. The modification replaces the static example with dynamic construction logic.

4. **GAP-004 Remediation**: While the instruction emphasizes S3 write as mandatory, it lacks a structured execution checkpoint with verification steps. The modification adds a detailed phase-level checkpoint with pre-execution validation and post-execution confirmation requirements.

### Remediation Strategy
All modifications follow the **Add** or **Delete and Replace** pattern:
- **Add**: Insert new procedural steps or enforcement logic without removing existing content (GAP-001, GAP-002, GAP-004)
- **Delete and Replace**: Remove outdated or static examples and replace with dynamic logic (GAP-003)

No **Delete**-only modifications were required as all instruction content remains relevant; gaps represent missing enforcement or insufficient detail rather than incorrect information.

---

## Remediation Summary

| Total Gaps Identified | Gaps Remediated | Sections Modified | Change Types Used |
|----------------------|-----------------|-------------------|-------------------|
| 4 | 4 | 4 | Add (3), Delete and Replace (1) |

**Remediation Completion Status**: All identified gaps have been addressed with precise, actionable modifications to the instruction prompt.