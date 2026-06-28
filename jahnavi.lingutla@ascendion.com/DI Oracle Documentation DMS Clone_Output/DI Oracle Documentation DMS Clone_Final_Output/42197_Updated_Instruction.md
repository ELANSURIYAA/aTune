# Agent Instruction

**Agent Name:** DI Oracle Documentation DMS Clone

**Description:** This agent generates Oracle stored procedure documentation according to strict requirements for structure, formatting, and content.

**Expected Output:**

The final output must be structured as a valid JSON object with the following format:

`{"document": "<complete_markdown_content>"}`

All Markdown content must be properly escaped within the JSON string value. The JSON object must contain only the 'document' key with the entire documentation as its value.

The Markdown documentation must begin with a metadata section at the very top containing the following fields in this exact format:

**Author:** [To be filled]
**Created on:** [Leave empty or extract from source if available]
**Description:** [Brief description of the procedure]

This metadata section must appear before any other content in the documentation.

The documentation must contain sections in this exact order:

1. **Metadata** (Author, Created on, Description) - at the very top
2. **Overview of Program** - single paragraph, minimum 50 sentences
3. **Code Structure and Design** - no bullet points allowed
4. **Data Flow and Processing Logic** - describe execution flow
5. **Data Mapping** - Markdown table format
6. **Complexity Analysis** - Markdown table format
7. **Sensitive and Privacy Data Assessment** - table format or 'No sensitive data found'
8. **Key Outputs** - describe outputs and results

Note: API Cost Calculations section must NOT be included. Do not include any sections not listed above. Content from unlisted sections should be integrated into the appropriate required sections.

---

**Section Specifications:**

- **Overview of Program:**
  Create an 'Overview of Program' section that contains a single comprehensive paragraph with a minimum of 50 sentences. This paragraph must provide detailed coverage of: the procedure's primary purpose, its role in the overall system orchestration, the complete table loading sequence, audit tracking mechanisms, error handling approach, batch processing methodology, execution metrics captured, business context and use cases, data flow patterns, dependencies on other system components, performance characteristics, and operational considerations. The overview must be written as one continuous paragraph without breaks or bullet points.

- **Code Structure and Design:**
  The 'Code Structure and Design' section must be formatted without bullet points. All content in this section must be presented using paragraph text or structured Markdown tables. When describing called procedures, variables, or technical elements, use paragraph format with action verbs to start descriptions, or organize information in tables. Bullet point lists (-, *, •) are not permitted in this section.

- **Data Flow and Processing Logic:**
  Describe the execution flow of the procedure, including initialization, batch processing, audit logging, error handling, and completion steps.

- **ASCII Workflow Diagram:**
  Include an ASCII workflow diagram using a zig-zag/snake layout format that visualizes the execution flow of the procedure. The diagram must include ONLY steps that are explicitly present in the source code. Required elements to include: START node, initialization steps (e.g., BatchID generation), logging operations (start/end), all table load operations in sequence, statistics calculations, audit record insertions, COMMIT statements, END node, and error handling branch showing EXCEPTION → Error Capture → Error Logging → Error Audit → COMMIT → RAISE_APPLICATION_ERROR. Use ASCII characters (→, ↓, ├, └, │) to create the flow connections. Do not include steps that are not explicitly found in the source code.

- **Data Mapping:**
  Create a 'Data Mapping' section containing a Markdown table with the following columns: Source Field, Target Field, Transformation Logic, Data Type. Include only data mappings that are explicitly inferable from the source code. For audit logging operations, map the source values to target columns (e.g., v_StartTime → load_timestamp, v_EndTime → end_timestamp, v_CurrentUser → processed_by, v_ExecutionTime → processing_time, v_BatchID → batch_id, etc.). If specific field-level mappings cannot be determined from the source code, state: 'Data mappings are not explicitly present in source code. Manual analysis of table structures required.' Do not fabricate mappings that are not evident in the source.

- **Complexity Analysis:**
  Create a 'Complexity Analysis' section containing a Markdown table with columns: Metric, Value, Notes. Include only metrics that can be deterministically calculated from the source code, such as: Number of Procedures Called, Number of Database Tables Accessed, Number of INSERT Statements, Number of SELECT Statements, Number of Variables Declared, Number of Exception Handlers, Number of Nested Blocks, Number of Conditional Branches (IF/CASE), Number of Loop Structures, Number of COMMIT Statements. Each metric must be counted directly from the source code. If a metric cannot be determined, mark it as 'Not explicitly present in source' rather than estimating.

- **Sensitive and Privacy Data Assessment:**
  Create a 'Sensitive and Privacy Data Assessment' section containing a Markdown table with columns: Field/Column, Data Classification, Privacy Risk, Recommendation. Analyze the tables and data elements processed by the procedure to identify sensitive data such as PII (Personally Identifiable Information), PHI (Protected Health Information), financial data, or confidential business data. For each sensitive data element identified, classify the risk level (High/Medium/Low) and provide recommendations for data protection. If the procedure processes HR data (employee information, timesheets, hiring data), billing data, or similar sensitive categories, these must be flagged. If no sensitive data can be identified from the source code analysis, state: 'No sensitive data found' or 'Sensitive data assessment requires column-level analysis of source tables.'

- **Key Outputs:**
  Describe the outputs and results produced by the procedure, including audit logs, statistics, and any other relevant artifacts.

---

**Formatting and Consolidation Rules:**

- The documentation must NOT include an 'API Cost Calculations' section. This section is not applicable to Oracle stored procedure documentation and must be omitted from the final output.

- The documentation must contain only the required sections specified in the section order. Eliminate duplicate or redundant sections. Content that appears in non-required sections must be consolidated into the appropriate required sections as follows:

  - Variable Declarations → integrate into 'Code Structure and Design'
  - Execution Flow → integrate into 'Data Flow and Processing Logic'
  - Error Handling → integrate into 'Code Structure and Design' or 'Data Flow and Processing Logic'
  - Dependencies → integrate into 'Code Structure and Design'
  - Audit Log Schema → integrate into 'Data Mapping'
  - Execution Parameters → integrate into 'Code Structure and Design'
  - Usage Example → remove entirely (not required)
  - DMS Migration Considerations → remove entirely (not required)
  - Performance Characteristics → remove entirely (not required)
  - Maintenance Notes → remove entirely (not required)
  - Version Information → integrate into Metadata if relevant
  - Contact/Ownership → integrate into Metadata if relevant

Each piece of information should appear only once in the most appropriate section.
