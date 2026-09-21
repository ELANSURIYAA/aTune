QUALITY SCORE

| Dimension    | Weight | Reviewer Check Score | Raw Score | Weighted Score | Notes                                         |
|--------------|--------|----------------------|-----------|----------------|-----------------------------------------------|
| Completeness | 40%    | 7/15                 | 46.67/100 | 18.67/40       | 7 of 15 completeness reviewer checks satisfied |
| Accuracy     | 40%    | 9/14                 | 64.29/100 | 25.72/40       | 9 of 14 accuracy reviewer checks satisfied     |
| Efficiency   | 20%    | 6/7                  | 85.71/100 | 17.14/20       | 6 of 7 efficiency reviewer checks satisfied    |
| TOTAL        | 100%   |                      |           | 61.53/100      |                                               |

GAP COUNTS

Total Gaps Found: 14
Not Present (NP): 8
Not Done Correctly (NC): 5
Not Done Optimally (NO): 1

REVIEWER CHECK BREAKDOWN

Completeness Checks (15 total):
- Total reviewer checks: 15
- Passed: 7
- Failed: 8

Failed completeness checks:
1. Missing client_dimension and location_dimension tables (GAP-001)
2. Missing both TABLE 3 relationships (GAP-002)
3. Missing 52 dimension fields from client and location tables (GAP-003)
4. Missing 8 measures from client and location tables (GAP-004)
5. Missing 4 dashboard-level filters (GAP-005)
6. Missing manual review notes (GAP-006)
7. Missing date/weekday granularity on Data Flow State Table (GAP-007)
8. Missing CLIENT_NAME on Rows for two worksheets (GAP-008)

Accuracy Checks (14 total):
- Total reviewer checks: 14
- Passed: 9
- Failed: 5

Failed accuracy checks:
1. Missing CREATE_HOUR filter on Data Flow State Table (GAP-009)
2. Measures use column metadata instead of explicit formulas (GAP-010)
3. Incomplete datasource-dependencies declarations (GAP-011)
4. Missing CLIENT_NAME and sort on Pending JMS by Client (GAP-012)
5. Missing CLIENT_NAME and sort on Pending Parking by Client (GAP-013)

Efficiency Checks (7 total):
- Total reviewer checks: 7
- Passed: 6
- Failed: 1

Failed efficiency checks:
1. Single-table structure prevents relationship model optimization (GAP-014)