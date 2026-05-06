# Gap Analysis – Instruction Enhancements

## 1. Gap: Missing explicit instruction for handling EXTRACT-based execution time calculations
- **Section:** Function and Syntax Conversion (Point 1)  
- **Change Type:** Add  

**Action:**

Add the following bullet point after:  
"Ensure correct handling of date functions like ADD_MONTHS, MONTHS_BETWEEN, and TRUNC for dates."

- Convert Oracle EXTRACT-based execution time calculations (e.g., EXTRACT(HOUR FROM timestamp) * 3600 + EXTRACT(MINUTE FROM timestamp) * 60 + EXTRACT(SECOND FROM timestamp)) to JavaScript date arithmetic using `getTime()` or equivalent methods in Snowflake stored procedures. Validate semantic equivalence for time difference calculations.

---

## 2. Gap: Missing explicit instruction for handling Oracle COMMIT statements
- **Section:** Output Optimization (Point 7)  
- **Change Type:** Add  

**Action:**

Add the following bullet point at the end of Point 7:

- Remove Oracle COMMIT statements as Snowflake uses auto-commit by default. Document this behavior in the conversion log if COMMIT was present in the source.

---

## 3. Gap: Missing explicit instruction for error code mapping in exception handling
- **Section:** Output Optimization (Point 7)  
- **Change Type:** Add  

**Action:**

Add the following bullet point after:  
"Convert PL/SQL blocks to Snowflake stored procedures using JavaScript where applicable."

- When converting Oracle exception handling (SQLERRM, SQLCODE, RAISE_APPLICATION_ERROR) to JavaScript try-catch blocks, map Oracle error codes to JavaScript error properties. Document any error code mappings that cannot be directly translated and require manual validation.

---

## 4. Gap: Missing explicit instruction for handling DBMS_OUTPUT and Oracle-specific logging
- **Section:** No Residual Syntax Rule (under ADDITIONAL MANDATORY RULES)  
- **Change Type:** Delete and Replace  

**Action:**

**Delete:**
No Residual Syntax Rule: Final output must contain zero oracle syntax and zero SQL Server–specific syntax. Use only snowflake SQL.

**Replace with:**
No Residual Syntax Rule: Final output must contain zero Oracle syntax and zero SQL Server–specific syntax. Use only Snowflake SQL. Specifically, remove all Oracle-specific constructs including but not limited to: DBMS_OUTPUT, EXTRACT (when used for time calculations), COMMIT, RAISE_APPLICATION_ERROR, SQLERRM, SQLCODE. Replace with Snowflake/JavaScript equivalents (e.g., JavaScript console.log or return statements for logging, JavaScript error handling for exceptions).

---

## 5. Gap: Missing explicit instruction for documenting unconvertible logic
- **Section:** Inline Comment Standards (MANDATORY STYLE) - Section B  
- **Change Type:** Delete and Replace  

**Action:**

**Delete:**
B. Cannot convert safely  
-- UNCONVERTED LOGIC:  
-- Oracle feature cannot be deterministically converted.  
-- Manual rewrite required using Snowflake aggregation or application-layer logic.

**Replace with:**
B. Cannot convert safely  
-- UNCONVERTED LOGIC:  
-- Oracle feature: [specify exact Oracle construct]  
-- Reason: Cannot be deterministically converted due to [specify reason: semantic difference, platform limitation, etc.]  
-- Original behavior: [describe what the Oracle code did]  
-- Recommended Snowflake approach: [suggest alternative implementation]  
-- Manual rewrite required using Snowflake aggregation or application-layer logic.  

Note: If no unconvertible logic is found in the source, this section should be omitted from the output.

---

## 6. Gap: Missing explicit instruction for handling child procedure calls
- **Section:** Output Optimization (Point 7)  
- **Change Type:** Add  

**Action:**

Add the following bullet point after:  
"Convert PL/SQL blocks to Snowflake stored procedures using JavaScript where applicable."

- Convert Oracle child procedure calls to Snowflake `CALL` syntax. Ensure all procedure names, parameters, and return values are adapted to Snowflake stored procedure conventions. Validate that parameter passing (IN, OUT, INOUT) is correctly mapped to Snowflake JavaScript procedure parameters.

---

## 7. Gap: Missing explicit instruction for handling audit log inserts
- **Section:** Instructions (General section)  
- **Change Type:** Add  

**Action:**

Add a new point:

### 8. Audit and Logging:
- Convert Oracle audit log INSERT statements to Snowflake INSERT syntax.
- Ensure all timestamp functions (e.g., SYSTIMESTAMP) are replaced with Snowflake equivalents (e.g., CURRENT_TIMESTAMP()).
- Ensure all user functions (e.g., USER) are replaced with Snowflake equivalents (e.g., CURRENT_USER()).
- Preserve all audit columns and values from the source code.

---

## 8. Gap: Missing explicit instruction for handling summary statistics and aggregations
- **Section:** Instructions (General section)  
- **Change Type:** Add  

**Action:**

Add the following bullet point under Audit and Logging:

- When converting summary statistics queries (e.g., COUNT, SUM with GROUP BY), ensure Oracle aggregation logic is preserved in Snowflake. Validate NULL handling in COUNT operations, as Oracle and Snowflake may differ in behavior.

---

## 9. Gap: Missing explicit validation requirement for date/time function behavior
- **Section:** Validation Checklist (Internal Use Only — Do Not Print)  
- **Change Type:** Add  

**Action:**

Add:
- ☐ Date/time function conversions validated for semantic equivalence (EXTRACT, TO_CHAR, SYSTIMESTAMP, etc.)

---

## 10. Gap: Missing explicit validation requirement for error handling equivalence
- **Section:** Validation Checklist (Internal Use Only — Do Not Print)  
- **Change Type:** Add  

**Action:**

Add:
- ☐ Exception handling converted correctly (Oracle SQLERRM/SQLCODE → JavaScript error properties)

---

## 11. Gap: Missing explicit instruction for handling variable declarations in PL/SQL to JavaScript conversion
- **Section:** Output Optimization (Point 7)  
- **Change Type:** Delete and Replace  

**Action:**

**Delete:**
- Convert PL/SQL blocks to Snowflake stored procedures using JavaScript where applicable.

**Replace with:**
- Convert PL/SQL blocks to Snowflake stored procedures using JavaScript. Specifically:
  - Convert PL/SQL variable declarations (e.g., v_variable_name VARCHAR2(100)) to JavaScript variable declarations (e.g., var v_variable_name = '';).
  - Convert PL/SQL data types to JavaScript equivalents (VARCHAR2 → string, NUMBER → number, DATE → Date object).
  - Ensure all PL/SQL control flow (IF-THEN-ELSE, LOOP, WHILE) is converted to JavaScript equivalents (if-else, for, while).
  - Convert PL/SQL cursors to JavaScript result set processing using execute() and fetchAsObject() methods.

---

## 12. Gap: Missing explicit instruction for handling batch ID formatting
- **Section:** Instructions (General section)  
- **Change Type:** Add  

**Action:**

Add the following bullet point under Function and Syntax Conversion (Point 1):

- When converting Oracle TO_CHAR date formatting (e.g., TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS')), use Snowflake TO_CHAR with equivalent format strings or JavaScript date formatting methods in stored procedures. Validate that the output format matches the Oracle behavior exactly.

---

## Notes
- All gaps identified in the Gap Report have been addressed with specific, actionable modifications.
- The instruction improvements focus on making implicit requirements explicit to prevent semantic deviations during conversion.
- No new sections are required; all modifications are additions or replacements within existing sections.
- The validation checklist enhancements ensure that critical conversion aspects are verified before output delivery.
