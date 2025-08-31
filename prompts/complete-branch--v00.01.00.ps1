# Import common functions
. "$PSScriptRoot\complete-branch-common.ps1"

# Define branch-specific commit message
$commitMessage = "feat: Implement Obsidian setup v00.01.00

- Add 5 Obsidian templates (Meeting, Project, People, Knowledge, Task)
- Create PowerShell script for vault updates with backup functionality
- Add Templater conventions and proper frontmatter
- Create test directory structure
- Update documentation"

# Complete the branch
Complete-Branch -BranchName "v00.01.00" -CommitMessage $commitMessage

