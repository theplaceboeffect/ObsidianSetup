# Common functions for branch completion scripts

function Complete-Branch {
    param(
        [string]$BranchName,
        [string]$CommitMessage
    )
    
    Write-Host "Completing branch: $BranchName" -ForegroundColor Cyan
    
    # Check if we're on the correct branch
    $currentBranch = git branch --show-current
    if ($currentBranch -ne $BranchName) {
        Write-Host "Switching to branch: $BranchName" -ForegroundColor Yellow
        git checkout $BranchName
    }
    
    # Add all changes
    Write-Host "Adding all changes..." -ForegroundColor Green
    git add .
    
    # Commit with the provided message
    Write-Host "Committing changes..." -ForegroundColor Green
    git commit -m $CommitMessage
    
    # Push to remote
    Write-Host "Pushing to remote..." -ForegroundColor Green
    git push origin $BranchName
    
    Write-Host "Branch $BranchName completed successfully!" -ForegroundColor Green
}
