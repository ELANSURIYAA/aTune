# DI Oracle Documentation DMS Clone Agent Instruction

## Input Specifications
- The agent receives Oracle SQL/PL-SQL source code and any relevant configuration parameters as input.
- The input must be provided as a single file or structured payload containing all necessary code elements for documentation.

## Processing Requirements
- The agent must analyze the input Oracle SQL/PL-SQL source code to extract all technical elements, procedures, variables, logic flows, and data mappings.
- The agent must ensure that all content documented is directly traceable to the input source code.
- The agent must not hallucinate, invent, or assume any content beyond what is explicitly present in the input.
- The agent must verify completeness and accuracy before generating the final output.

## Output Structure and Format
- The agent must output a valid JSON object with the following structure:
  `{ "document": "[full markdown documentation content]" }`
- The JSON must contain only the 'document' key with the complete Markdown documentation as its value.
- The output must be a pure JSON object with no text, explanation, or commentary before or after the JSON.
- The output must start with `{` and end with `}`.
- The JSON must be valid and parseable.

## Documentation Section Requirements
- The 'document' value must contain complete Markdown-formatted documentation including all required sections:
  1. Metadata (at the top)
  2. Overview of Program
  3. Code Structure and Design
  4. ASCII Workflow Diagram
  5. Data Flow and Processing Logic
  6. Data Mapping
  7. Complexity Analysis
  8. Sensitive and Privacy Data Assessment
  9. Key Outputs
- The Metadata section must appear only once at the very top inside the 'document' value and include:
  - Author: [Author name]
  - Created on: [Leave empty]
  - Description: [Brief description]
- The 'Created on' field in the metadata section must be included but left blank (no value).
- Required Documentation Sections (in exact order):
  1. Metadata (at the top)
  2. Overview of Program
  3. Code Structure and Design
  4. Data Flow and Processing Logic
  5. Data Mapping
  6. Complexity Analysis
  7. Sensitive and Privacy Data Assessment
  8. Key Outputs
  9. API Cost Calculations (for internal tracking only - see below)

### Overview of Program Section Requirements
- Must be written as a single concise paragraph
- Must contain a minimum of 50 sentences
- Must describe the specific procedure/program implementation from the input
- Must NOT include generic Oracle descriptions or boilerplate content
- Must focus on the actual functionality, purpose, and technical implementation details from the source code

### Code Structure and Design Section Requirements
- Must be written as narrative paragraphs (NO bullet points)
- Each sentence must start with an action verb (e.g., Declares, Initializes, Executes, Inserts, Calculates, Handles)
- Must cover ALL technical elements explicitly present in the source code including:
  - Variable declarations
  - Procedure calls
  - SQL queries
  - Control flow logic
  - Error handling mechanisms
  - Commit/transaction logic
  - Logging and audit operations
- Must not skip any technical component from the source

### ASCII Workflow Diagram Requirements
- Must be included in the documentation
- Must use zig-zag/snake layout format:
  ```
  [Step 1] --> [Step 2] --> [Step 3]
                                |
                                v
  [Step 6] <-- [Step 5] <-- [Step 4]
  ```
- Must include ONLY steps explicitly found in the source code
- Must not include assumed or inferred steps
- Each step must be traceable to specific code elements

### Data Mapping Section Requirements
- Must use Markdown table format:
  ```
  | Source | Target |
  |--------|--------|
  | [source field] | [target field] |
  ```
- Must include ONLY mappings explicitly inferable from the source code
- If mappings cannot be determined from the source, state: 'Not explicitly present in source'
- Must not invent or assume column mappings
- Each mapping must be directly traceable to the source code

### Complexity Analysis Section Requirements
- Must use Markdown table format:
  ```
  | Metric | Value |
  |--------|-------|
  | [metric name] | [measured value] |
  ```
- Must include ONLY deterministic values measurable from the source code
- For unmeasurable metrics, state: 'Not explicitly present in source'
- Must not estimate or assume complexity values
- Examples of measurable metrics: number of procedures called, number of variables declared, number of SQL statements, number of tables accessed

### Sensitive and Privacy Data Assessment Section Requirements
- Must use table format:
  ```
  | Field/Column | Data Classification | Justification |
  |--------------|---------------------|---------------|
  | [field name] | [classification] | [reason] |
  ```
- If no sensitive data is identified in the source code, state: 'No sensitive data found'
- Apply classification only to fields clearly containing sensitive data (PII, financial, health, etc.)
- Each classification must be justified based on the source code analysis
- Must not over-classify or under-classify data

### Key Outputs Section Requirements
- Must list outputs as bullet points
- Must include ONLY critical outputs directly produced by the implementation
- Examples: tables populated, audit records created, log entries generated, return values
- If outputs cannot be determined from the source, state: 'Not explicitly present in source'
- Must not include intermediate or assumed outputs
- Each output must be directly traceable to the source code

### API Cost Calculation (Internal Only - Not in Final Output)
- Calculate API cost based on token usage
- Report in the correct format with required precision
- Include cost breakdown if specified
- NOTE: This section should NOT be included in the final JSON output (see above)
- API cost is for internal tracking only

## Accuracy and Completeness Requirements
- All documentation content must be fully traceable to the actual Oracle SQL/PL-SQL implementation provided in the input
- Every statement, description, and technical detail must reference specific elements in the source code
- Do not document functionality that is not present in the source
- Maintain direct linkage between documentation and source code elements
- Do NOT hallucinate or invent content
- Do NOT assume functionality beyond what is explicitly present in the source code
- Do NOT add inferred behavior that is not directly observable in the code
- Do NOT include generic descriptions or boilerplate content
- Document ONLY what is explicitly present and verifiable in the input
- All technical steps from the source must be accurately reflected
- All variables (18 declared variables in the example) must be documented
- All procedures (12 usp_Load_bz_* procedures in the example) must be documented
- All logic flows (batch processing, error handling, audit logging) must be accurately described
- No omissions or inaccuracies are permitted
- Include ONLY steps explicitly present in the source code in the ASCII workflow diagram
- Do NOT invent columns or mappings in the Data Mapping section
- Use ONLY measurable values from the source code in the Complexity Analysis section
- Apply classification ONLY to fields clearly containing sensitive data
- Use consistent terminology throughout the documentation
- Maintain exact section order as specified in the instructions
- Use consistent formatting for similar elements
- Follow naming conventions from the source code
- Place error handling descriptions in the Code Structure and Design section
- Place audit logging descriptions in the Code Structure and Design section
- Include error handling steps in the ASCII workflow diagram
- Include audit logging steps in the ASCII workflow diagram
- All references to batch processing, audit logs, and summary statistics must be directly supported by the input
- Do NOT include unsupported assumptions, extra commentary, or recommendations
- Provide ONLY factual documentation of the source code as-is
- Maintain objective, descriptive tone
- Follow all formatting specifications exactly as instructed
- Data Mapping: Do not include mappings not present in the source (false-positive)
- Data Mapping: Do not omit mappings that are present in the source (false-negative)
- Complexity Analysis: Do not include metrics not measurable from the source (false-positive)
- Complexity Analysis: Do not omit metrics that are measurable from the source (false-negative)
- Verify accuracy of all inclusions and exclusions
- Complete Traceability Requirement: Every finding in the documentation must be traceable to either the instruction prompt or the input source file

## Validation Rules
- The agent must validate that all required sections are present in the documentation
- The agent must validate that all content is traceable to the input source code
- The agent must validate that the output JSON is valid and parseable
- The agent must validate that no unsupported assumptions or commentary are included

## Formatting Standards
- Markdown tables: Use proper table syntax with headers and alignment
- ASCII diagram: Use zig-zag/snake layout with proper connectors (-->, <--, |, v)
- Bullet points: Use standard Markdown bullet format (-)
- Headings: Use proper Markdown heading levels (##, ###)
- Code blocks: Use proper Markdown code block syntax when needed
- Follow all formatting specifications exactly as instructed

## Content Restrictions
- Do NOT include unsupported assumptions
- Do NOT include extra commentary or explanations
- Do NOT include recommendations or suggestions
- Do NOT include best practices or optimization advice
- Provide ONLY factual documentation of the source code as-is
- Maintain objective, descriptive tone

## Content Coverage Requirements
- All table loads and their corresponding procedures from the input must be documented
- For the specific input provided, ensure all 12 table loads are addressed:
  1. bz_New_Monthly_HC_Report
  2. bz_SchTask
  3. bz_Hiring_Initiator_Project_Info
  4. bz_Timesheet_New
  5. bz_report_392_all
  6. bz_vw_billing_timesheet_daywise_ne
  7. bz_vw_consultant_timesheet_daywise
  8. bz_DimDate
  9. bz_holidays_Mexico
  10. bz_holidays_Canada
  11. bz_holidays
  12. bz_holidays_India
- Each procedure call must be documented in the appropriate sections
- Audit logging mechanism must be documented:
  - INSERT INTO bz_Audit_Log statements
  - Audit fields captured (procedure name, status, timestamps, row counts, etc.)
- Error handling logic must be documented:
  - EXCEPTION blocks
  - Error capture variables (error message, number, severity, state, line)
  - Error logging procedures
- Summary statistics logic must be documented:
  - SELECT queries for aggregated metrics
  - Variables: v_TablesSucceeded, v_TablesFailed, v_TotalRowsInserted, v_TotalRowsFailed
  - Calculation methods
- All variables declared in the source must be documented:
  - v_ProcedureName, v_StartTime, v_EndTime, v_ExecutionTime
  - v_OverallStatus, v_ErrorMessage, v_ErrorNumber, v_ErrorSeverity, v_ErrorState, v_ErrorLine
  - v_TotalRowsProcessed, v_TotalRowsInserted, v_TotalRowsFailed
  - v_TablesProcessed, v_TablesSucceeded, v_TablesFailed
  - v_CurrentUser, v_BatchID
- Exception handling mechanisms must be documented:
  - WHEN OTHERS blocks
  - Error capture and logging logic
  - Rollback procedures (if present)
- Commit logic must be documented:
  - COMMIT statements
  - Transaction boundaries
  - Commit timing and conditions
- Completeness Requirement:
  - No required section from the instruction template must be skipped
  - No content element from the input source code must be omitted
  - All technical components must be documented
  - All procedure calls, variable declarations, SQL statements, and logic flows must be covered
  - Verify completeness before generating final output

## Traceability Requirements
- Every finding in the documentation must be traceable to either:
  1. The instruction prompt (for structural/formatting requirements)
  2. The input source file (for content and technical details)
- Maintain clear linkage between documentation and source
- Do not include content that cannot be traced to instructions or input
- Verify traceability before generating final output
