These are the remaining tasks for this project.

# v00.01.00

## Implementation
**COMPLETED**: 20241219-143000
**BRANCH COMPLETED**: 20241219-150000

1. [I] Generate a some Obsidian Templates in `library/99 - Meta/Templates`
  - Use Templater conventions for maintaining data dynamically.
  - Add `NoteType` to frontmatter
  - Add the following templates
    - Meeting
    - Project
    - People
    - Knowledge
    - Task
1. [I] Create a script `bin/update-obsdidian.ps1` that will copy the files from library into the specified Vault.
  - `-VaultPath` is a required parameter. Verify that it exists and that there's a `.obsidian` folder there.
  - Copy the files into the relevant locations in the target Vault.
  - If the files already exist, rename them by appending .YYYYMMDD--HHMMSS.bk
  - When complete, list the modifications made.
1. [I] Test in an isolated folder `tests/`
1. [I] Ensure that the files are copied to the following places in the destination
  - e.g. `library/99 - Meta` goes to the root of the vault
  - [I] `.obsidian/snippets` goes into the corresponding directory in the vault.
1. [I] Save all backups to `99 - Meta/.backups`
  - Only overwrite a file if the contents are different.
1. [I] Rename templates to be `XXX Template.md`
1. [I] Why are the folders hard-coded? just merge the library into the vault
1. [I] Add a note template
1. [I] Show detailed debugging when the -Debug flag is passed
1. [I] Create a template for Daily Notes **COMPLETED**: 20241219-150000
  - Created `Daily Notes Template.md` with comprehensive daily planning sections
  - Includes Templater integration for dynamic date handling
  - Features sections for goals, schedule, notes, daily review, health tracking, and gratitude
1. [I] When `-Debug` flag is passed - list every source file and it's destination.
1. [I] The font for dataview tables should be 8pt, width 200px **COMPLETED**: 20241219-170000
  - Updated dataview-table-fixes.css to use 8pt font size
  - Set table width to 200px instead of 100%
  - Applied changes to both light and dark mode styles
  - Updated responsive design to maintain consistency
