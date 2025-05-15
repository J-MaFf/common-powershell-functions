# Clear-PrintSpooler.ps1
# Purpose: Clears all print jobs from the Windows print spooler

# Check for admin privileges and auto-elevate if needed
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host 'This script requires administrator privileges. Attempting to restart with elevation...' -ForegroundColor Yellow
    
    # Get the current script path
    $scriptPath = $MyInvocation.MyCommand.Definition
    
    # Start a new PowerShell process with elevation
    try {
        Start-Process PowerShell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`"" -Verb RunAs
        # Exit the current non-elevated script
        exit
    }
    catch {
        Write-Warning 'Failed to restart with administrator privileges.'
        Write-Warning 'Please restart PowerShell as an administrator and try again.'
        PAUSE
        exit
    }
}

do {
    Clear-Host
    Write-Host "`n========= Print Spooler Cleanup Utility =========" -ForegroundColor Cyan
    Write-Host "This script will delete all pending print jobs on $env:COMPUTERNAME" -ForegroundColor Yellow
    Write-Host '=========================================' -ForegroundColor Cyan
    
    $sure = Read-Host "`nAre you sure you want to delete all Print Jobs? (Y/N)"
    
    if ($sure -eq 'Y' -or $sure -eq 'y') {
        Write-Host "`nStarting print spooler cleanup process..." -ForegroundColor Cyan
        Write-Host '=========================================' -ForegroundColor Cyan
        
        try {
            # Step 1: Stop the spooler service
            Write-Host '1. Stopping Spooler Service...' -ForegroundColor Green
            Stop-Service -Name Spooler -Force -ErrorAction Stop
            
            # Step 2: Clear the print queue folder
            $spoolPath = "$env:windir\system32\spool\PRINTERS"
            Write-Host "2. Clearing content in $spoolPath" -ForegroundColor Green
            Remove-Item -Path "$spoolPath\*.*" -Force -ErrorAction SilentlyContinue
            
            # Step 3: Restart the spooler service
            Write-Host '3. Starting Spooler Service...' -ForegroundColor Green
            Start-Service -Name Spooler -ErrorAction Stop
            
            Write-Host "`nPrint spooler cleanup completed successfully!" -ForegroundColor Green
        }
        catch {
            Write-Host "`nError occurred during the process:" -ForegroundColor Red
            Write-Host $_.Exception.Message -ForegroundColor Red
            
            # Check spooler status
            $spoolerStatus = (Get-Service -Name Spooler).Status
            Write-Host "Current spooler service status: $spoolerStatus" -ForegroundColor Yellow
            
            # Try to restart if stopped
            if ($spoolerStatus -eq 'Stopped') {
                Write-Host 'Attempting to restart the spooler service...' -ForegroundColor Yellow
                try {
                    Start-Service -Name Spooler -ErrorAction Stop
                    Write-Host 'Spooler service restarted successfully.' -ForegroundColor Green
                }
                catch {
                    Write-Host 'Failed to restart the spooler service. You may need to restart it manually.' -ForegroundColor Red
                }
            }
        }
        
        Write-Host "`n=========================================" -ForegroundColor Cyan
        PAUSE
    }
    elseif ($sure -ne 'N' -and $sure -ne 'n') {
        Write-Host "`nInvalid input. Please enter 'Y' or 'N'." -ForegroundColor Red
    }
}
while ($sure -ne 'N' -and $sure -ne 'n')

Write-Host "`nExiting script. No changes were made." -ForegroundColor Cyan