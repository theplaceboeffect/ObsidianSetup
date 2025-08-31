#!/usr/bin/env pwsh

<#
.SYNOPSIS
    Updates an Obsidian vault with files from the library.

.DESCRIPTION
    Copies files from the library directory to the specified Obsidian vault.
    If files already exist, they are backed up with a timestamp before being overwritten.

.PARAMETER VaultPath
    The path to the target Obsidian vault. Must contain a .obsidian folder.

.EXAMPLE
    .\update-obsdidian.ps1 -VaultPath "C:\Users\username\Documents\ObsidianVault"

.NOTES
    This script requires PowerShell 5.1 or later.
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$VaultPath
)

# Function to write colored output
function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

# Function to compare file contents
function Compare-FileContents {
    param(
        [string]$File1,
        [string]$File2
    )
    
    if (!(Test-Path $File1) -or !(Test-Path $File2)) {
        return $false
    }
    
    $hash1 = Get-FileHash $File1 -Algorithm SHA256
    $hash2 = Get-FileHash $File2 -Algorithm SHA256
    
    return $hash1.Hash -eq $hash2.Hash
}

# Function to create backup of existing file
function Backup-File {
    param(
        [string]$FilePath,
        [string]$VaultPath,
        [string]$SourceFile
    )
    
    if (Test-Path $FilePath) {
        # Check if contents are different
        $contentsDifferent = $true
        if (Test-Path $SourceFile) {
            $contentsDifferent = !(Compare-FileContents -File1 $FilePath -File2 $SourceFile)
        }
        
        if ($contentsDifferent) {
            $timestamp = Get-Date -Format "yyyyMMdd--HHmmss"
            $fileName = Split-Path $FilePath -Leaf
            $backupDir = Join-Path $VaultPath "99 - Meta\.backups"
            
            # Create backup directory if it doesn't exist
            if (!(Test-Path $backupDir)) {
                New-Item -ItemType Directory -Path $backupDir -Force | Out-Null
                Write-ColorOutput "Created backup directory: $backupDir" "Green"
            }
            
            $backupPath = Join-Path $backupDir "$fileName.$timestamp.bk"
            Copy-Item $FilePath $backupPath
            Write-ColorOutput "Backed up: $FilePath -> $backupPath" "Yellow"
            return $backupPath
        } else {
            return $null
        }
    }
    return $null
}

# Function to copy directory recursively
function Copy-DirectoryRecursive {
    param(
        [string]$Source,
        [string]$Destination,
        [string]$VaultPath
    )
    
    $copiedFiles = @()
    
    if (Test-Path $Source) {
        # Create destination directory if it doesn't exist
        if (!(Test-Path $Destination)) {
            New-Item -ItemType Directory -Path $Destination -Force | Out-Null
            Write-ColorOutput "Created directory: $Destination" "Green"
        }
        
        # Copy all items from source to destination
        Get-ChildItem -Path $Source -Recurse | ForEach-Object {
            $relativePath = $_.FullName.Substring($Source.Length + 1)
            $destPath = Join-Path $Destination $relativePath
            
            if ($_.PSIsContainer) {
                # It's a directory
                if (!(Test-Path $destPath)) {
                    New-Item -ItemType Directory -Path $destPath -Force | Out-Null
                    Write-ColorOutput "Created directory: $destPath" "Green"
                }
            } else {
                # It's a file
                $backupPath = Backup-File -FilePath $destPath -VaultPath $VaultPath -SourceFile $_.FullName
                
                # Only copy if backup was created (meaning contents are different) or file doesn't exist
                if ($backupPath -or !(Test-Path $destPath)) {
                    Copy-Item $_.FullName $destPath -Force
                    $copiedFiles += @{
                        Source = $_.FullName
                        Destination = $destPath
                        Backup = $backupPath
                    }
                    Write-ColorOutput "Copied: $($_.Name) -> $destPath" "Green"
                }
            }
        }
    }
    
    return $copiedFiles
}

# Main script execution
try {
    Write-ColorOutput "=== Obsidian Vault Update Script ===" "Cyan"
    Write-ColorOutput "Target Vault: $VaultPath" "White"
    
    # Validate vault path
    if (!(Test-Path $VaultPath)) {
        throw "Vault path does not exist: $VaultPath"
    }
    
    # Check for .obsidian folder
    $obsidianFolder = Join-Path $VaultPath ".obsidian"
    if (!(Test-Path $obsidianFolder)) {
        throw "Vault does not contain a .obsidian folder. Please verify this is a valid Obsidian vault."
    }
    
    Write-ColorOutput "✓ Vault validation passed" "Green"
    
    # Get the script directory to find the library
    $scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    $projectRoot = Split-Path -Parent $scriptDir
    $libraryPath = Join-Path $projectRoot "library"
    
    if (!(Test-Path $libraryPath)) {
        throw "Library directory not found: $libraryPath"
    }
    
    Write-ColorOutput "Library source: $libraryPath" "White"
    
    # Copy files from library to vault
    $modifications = @()
    
    # Merge entire library into vault
    if (Test-Path $libraryPath) {
        $libraryMods = Copy-DirectoryRecursive -Source $libraryPath -Destination $VaultPath -VaultPath $VaultPath
        if ($libraryMods.Count -gt 0) {
            Write-ColorOutput "`nMerging library into vault..." "Cyan"
        }
        $modifications += $libraryMods
    }
    
    # Summary
    Write-ColorOutput "`n=== Update Summary ===" "Cyan"
    Write-ColorOutput "Total files processed: $($modifications.Count)" "White"
    
    if ($modifications.Count -gt 0) {
        Write-ColorOutput "`nModified files:" "Yellow"
        $modifications | ForEach-Object {
            Write-ColorOutput "  • $($_.Destination)" "White"
            if ($_.Backup) {
                Write-ColorOutput "    (Backup: $($_.Backup))" "Gray"
            }
        }
    } else {
        Write-ColorOutput "No files were modified." "Yellow"
    }
    
    Write-ColorOutput "`n✓ Update completed successfully!" "Green"
    
} catch {
    Write-ColorOutput "ERROR: $($_.Exception.Message)" "Red"
    exit 1
}
