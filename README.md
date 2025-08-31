# Obsidian Setup

This project keeps my Obsidian vault configured and up to date with different artifacts that can be used to bootstrap a new vault or copied into an existing vault.

## Features

- **CSS Snippets**: Custom styling for Obsidian
- **Templates**: Pre-configured note templates with Templater integration
  - Meeting notes
  - Project management
  - People/contact management
  - Knowledge/learning notes
  - Task tracking
  - General notes

## Structure

```
├── library/
│   ├── 99 - Meta/
│   │   └── Templates/
│   │       ├── Meeting Template.md
│   │       ├── Project Template.md
│   │       ├── People Template.md
│   │       ├── Knowledge Template.md
│   │       ├── Task Template.md
│   │       └── Note Template.md
│   └── .obsidian/
│       └── snippets/
│           ├── dataview-table-fixes.css
│           └── widen-property-name.css
├── bin/
│   └── update-obsdidian.ps1
├── tests/
└── prompts/
    ├── TASKS.md
    ├── complete-branch-common.ps1
    └── complete-branch--v00.01.00.ps1
```

## Usage

### Updating an Obsidian Vault

Use the PowerShell script to copy files from the library to your Obsidian vault:

```powershell
.\bin\update-obsdidian.ps1 -VaultPath "C:\path\to\your\obsidian\vault"
```

The script will:
- Validate that the target path is a valid Obsidian vault (contains `.obsidian` folder)
- Merge the entire library into the vault (preserving directory structure)
- Create backups of existing files with timestamps (YYYYMMDD--HHMMSS.bk)
- Provide a summary of all modifications

### Templates

All templates use [Templater](https://silentvoid13.github.io/Templater/) conventions for dynamic data:
- Automatic date insertion
- File metadata tracking
- Frontmatter with note type classification

## Development

### Branch Management

Each version branch has its own completion script:
- `prompts/complete-branch-common.ps1` - Shared functions
- `prompts/complete-branch--<branchname>.ps1` - Branch-specific completion

### Testing

Use the `tests/` directory for isolated testing of the update script and templates.
