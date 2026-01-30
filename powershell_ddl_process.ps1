[CmdletBinding()]
Param (
    $BaseDir = "C:\Manikanta",
    $ExportPath = "C:\Manikanta\ddl_exports"
)

Set-Location -Path $BaseDir

try {
    Write-Host "--- STEP 1: Cleaning Directory ---"
    if (Test-Path $ExportPath) {
        Get-ChildItem -Path $ExportPath | Remove-Item -Recurse -Force
    }
    else {
        New-Item -Path $ExportPath -ItemType Directory
    }

    Write-Host "--- STEP 2: Extracting DDL via Python ---"
    & ".\Python_extract_DDL_per_SQL_format_DBservers.py"

    if ($LASTEXITCODE -ne 0) {
        throw "Python script failed with exit code $LASTEXITCODE"
    }

    Write-Host "--- STEP 3: Pushing to GitHub ---"
    & ".\git_push.bat"

    if ($LASTEXITCODE -ne 0) {
        throw "Git push failed with exit code $LASTEXITCODE"
    }

    Write-Host "SUCCESS: DDL Process Finished."
}
catch {
    Write-Error "PROCESS FAILED: $($_.Exception.Message)"
    exit 1
}
