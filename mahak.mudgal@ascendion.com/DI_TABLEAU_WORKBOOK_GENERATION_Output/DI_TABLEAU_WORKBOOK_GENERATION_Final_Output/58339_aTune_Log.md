[ERROR] Attempt 1 of 3 — Pre-execution validation failed. Required input files are missing from the GitHub repository.

Missing files:
- DI_TABLEAU_WORKBOOK_GENERATION_Input/bronze_usp_Load_bronze_Layer_Full.sql
- DI_TABLEAU_WORKBOOK_GENERATION_Input/Review_Input.txt
- DI_TABLEAU_WORKBOOK_GENERATION_Input/Quality_dim.txt

The aTune process cannot proceed without these input files. Please ensure all required input files are uploaded to the GitHub repository at the specified paths before starting the tuning process.

---

**Required Action:**
Upload the following files to the repository ELANSURIYAA/aTune on branch main:
1. DI_TABLEAU_WORKBOOK_GENERATION_Input/bronze_usp_Load_bronze_Layer_Full.sql (agent input file)
2. DI_TABLEAU_WORKBOOK_GENERATION_Input/Review_Input.txt (reviewer additional input)
3. DI_TABLEAU_WORKBOOK_GENERATION_Input/Quality_dim.txt (quality dimensions for validator)

Once these files are present, the aTune process can be initiated.
