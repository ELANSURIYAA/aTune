QUALITY SCORE REPORT
====================

Dimension-wise Scoring:
-----------------------
Completeness: 0/17
Accuracy: 0/16
Efficiency: 0/14

Raw Scores:
-----------
Completeness Raw Score: 0/100
Accuracy Raw Score: 0/100
Efficiency Raw Score: 0/100

Weighted Scores:
----------------
Completeness Weighted Score: 0.0/40 (Weight: 40%)
Accuracy Weighted Score: 0.0/40 (Weight: 40%)
Efficiency Weighted Score: 0.0/20 (Weight: 20%)

TOTAL QUALITY SCORE: 0.0/100

Gap Counts:
-----------
Total Gaps Found: 33
Not Present (NP): 17
Not Done Correctly (NC): 16
Not Done Optimally (NO): 0

Score Justification:
--------------------
The EXECUTOR_OUTPUT receives a score of 0.0/100 because it is identical to the EXECUTOR_INPUT source code without any documentation transformation. All 17 completeness reviewer checks failed (GAP-001 through GAP-017) because the output contains no JSON structure, no Markdown documentation, no metadata section, no Overview of Program, no Code Structure and Design section, no ASCII workflow diagram, no Data Mapping table, no Complexity Analysis table, no Sensitive and Privacy Data Assessment, and no Key Outputs section. All 16 accuracy reviewer checks failed (GAP-018 through GAP-033) because the output does not follow the instruction to produce JSON-formatted documentation, contains no analytical content traceable to documentation requirements, and lacks all required formatting standards including Markdown tables, ASCII diagrams, and structured sections. All 14 efficiency reviewer checks are not satisfied because the output contains no documentation content that could be evaluated for efficiency, redundancy, or optimization. The output demonstrates zero execution of the documentation task specified in the GOAL and INSTRUCTION.

Reviewer Check Details:
------------------------
Completeness Checks: 0 of 17 satisfied
Accuracy Checks: 0 of 16 satisfied
Efficiency Checks: 0 of 14 satisfied

Failed Completeness Checks:
- Check 1: Valid JSON object with "document" key
- Check 2: Full Markdown documentation in "document" value
- Check 3: Metadata at top of document
- Check 4: "Created on" field left empty
- Check 5: Required sections in exact order
- Check 6: Overview of Program (minimum 50 sentences)
- Check 7: Code Structure and Design without bullet points
- Check 8: ASCII workflow diagram
- Check 9: Data Mapping table
- Check 10: Complexity Analysis table
- Check 11: Sensitive and Privacy Data Assessment
- Check 12: Key Outputs as bullet points
- Check 13: API Cost excluded from output
- Check 14: All 12 table loads documented
- Check 15: Audit logging, error handling, summary statistics documented
- Check 16: All variables, exception handling, commit logic documented
- Check 17: No required content skipped

Failed Accuracy Checks:
- Check 1: Output follows instructions without extra explanation
- Check 2: Content traceable to Oracle implementation
- Check 3: No hallucinated content
- Check 4: All technical elements accurately reflected
- Check 5: ASCII diagram with correct layout
- Check 6: Data Mapping without invented columns
- Check 7: Complexity Analysis with measurable values
- Check 8: Sensitive data classification applied correctly
- Check 9: Consistent terminology and section order
- Check 10: Error handling and audit logic accurately described
- Check 11: Batch processing references supported by input
- Check 12: No unsupported assumptions or commentary
- Check 13: Formatting standards followed exactly
- Check 14: No false-positive or false-negative omissions
- Check 15: API cost in correct format
- Check 16: All findings traceable to instructions or input

Failed Efficiency Checks:
- All 14 efficiency checks not satisfied due to absence of documentation content