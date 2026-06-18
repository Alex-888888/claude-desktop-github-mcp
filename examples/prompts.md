# Example prompts

Once GitHub is connected, try asking Claude things like these. Claude maps them to the GitHub MCP tools (`get_me`, `create_repository`, `get_file_contents`, `list_issues`, `create_pull_request`, `search_code`, ...).

## Check the connection

- “Test GitHub — who am I?”
- “List my repositories.”

## Create and manage repos

- “Create a public repo called `my-notes` with a README and an MIT license.”
- “Add a `.gitignore` for Python to `my-notes`.”
- “Create a `dev` branch in `my-notes`.”

## Analyze existing code

- “Summarize the structure of `owner/repo`.”
- “Read `src/main.py` in `owner/repo` and explain what it does.”
- “Search `owner/repo` for where the database connection is configured.”

## Issues and pull requests

- “List open issues in `owner/repo`.”
- “Open an issue titled ‘Flaky test in CI’ with a short description.”
- “Create a pull request from `dev` into `main` summarizing the changes.”

## Tips

- Be explicit about `owner/repo` so Claude doesn't have to guess.
- For risky actions (deleting, merging, force changes), Claude should confirm with you first — keep it that way.
