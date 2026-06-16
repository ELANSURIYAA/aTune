Iteration 1:

Step 1:
- Extracted the agent's role, goal, backstory, description, and expected output using the metadata extractor.
- Created the Goal file and Instruction file and wrote both to GitHub at jahnavi.lingutla@ascendion.com/DI Workflow Orchestration new_Output/DI Workflow Orchestration new_Instruction/.
- Validation: I checked that 44049_Goal.md and 44049_Instruction.md exist in the correct location with content present. Both files verified.
- Decision: All outputs verified so I am proceeding to Step 2.

Step 2:
- Triggered the Executer agent with the initial instruction file.
- The executed output file was written to GitHub at jahnavi.lingutla@ascendion.com/DI Workflow Orchestration new_Output/.
- Validation: I checked that 44049_Agent_Executed_Output.txt exists in the correct location with content present. File verified.
- Decision: All outputs verified so I am proceeding to Step 3.

Step 3:
- Created an empty Gap Report file in GitHub to initialise the review cycle.
- Triggered the Reviewer agent to compare the executed output against the goal and instruction.
- The Gap Report and Gap Score files were written to GitHub at jahnavi.lingutla@ascendion.com/DI Workflow Orchestration new_Output/DI Workflow Orchestration new_Working/.
- Validation: I checked that 44049_Gap_Report.md and 44049_Gap_Score.md exist in the correct location with content present. Both files verified.
- Decision: All outputs verified so I am proceeding to Step 4.
