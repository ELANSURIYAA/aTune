[ERROR] Attempt 1 of 3 — Failed to read required input files from GitHub. The following files are missing or inaccessible:
- DI_TABLEAU_WORKBOOK_GENERATION_Input/Data_Flow_Mapper 1.txt (404 Not Found)
- DI_TABLEAU_WORKBOOK_GENERATION_Input/Connection.txt (404 Not Found)

These input files are required to execute Step 2 (Executer agent). Without the agent input files specified in the Agent Requirement File, the aTune process cannot proceed.

Reason: The input files listed in the Agent Requirement File under "Agent Input Folder" do not exist at the expected paths in the GitHub repository. The file names may be incorrect, or the files may not have been uploaded to the repository yet.

Stopping aTune process. Cannot proceed without required input files.