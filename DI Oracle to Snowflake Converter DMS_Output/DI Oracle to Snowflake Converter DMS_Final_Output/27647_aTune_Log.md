Iteration 1:

Step 1:
- Used the DI AAVA Agent Metadata Extractor tool to extract the agent's role, goal, backstory, description, and expected output. Created the Goal file and Instruction file and wrote both to GitHub. Proceeding to Step 2.

Step 2:
- Called the Executer agent using the DI Aava Workflow Executor tool. The agent was executed with the initial instruction file and the output was written to GitHub. Proceeding to Step 3.

Step 3:
- Created an empty Gap Report file in GitHub to initialise the review cycle.
- Called the Reviewer agent using the DI Aava Workflow Executor tool. The Reviewer compared the executed output against the goal and instruction and produced the Gap Report and Gap Score files written to GitHub. Proceeding to Step 4.

Step 4:
- Gap score is 20.0. Threshold is 90. 20.0 is less than 90, so I am continuing to Step 5.

Step 5:
- Called the Recommender agent using the DI Aava Workflow Executor tool. The Recommender analysed the Gap Report against the current instruction and produced a structured Recommendation file written to GitHub. Proceeding to Step 6.