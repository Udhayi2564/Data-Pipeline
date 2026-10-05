# Submit Batch Job to SeaTunnel
# Usage: .\submit-batch.ps1 [-ConfigPath] [-JobName]

param(
    [string]$ConfigPath = "configs/batch/orders.conf",
    [string]$JobName = "orders-migration-batch"
)

# Project root
$SeaTunnelRestUrl = "http://localhost:8080"

# Full path to config
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$FullConfigPath = Join-Path $ProjectRoot $ConfigPath

# Check if config file exists
if (-not (Test-Path $FullConfigPath)) {
    Write-Error "Config file not found: $FullConfigPath"
    Write-Host "Expected path: $FullConfigPath"
    Get-ChildItem -Path $ProjectRoot -Recurse -ErrorAction SilentlyContinue
    exit 1
}

Write-Host "Submitting batch job: $JobName"
Write-Host "Config: $FullConfigPath"

# Base64 encode config for REST API
$ConfigBytes = [System.Text.Encoding]::UTF8.GetBytes([System.IO.File]::ReadAllText($FullConfigPath))
$ConfigBase64 = [System.Convert]::ToBase64String($ConfigBytes)

# Submit job via REST API
$Body = @{
    config = $ConfigBase64
    jobName = $JobName
} | ConvertTo-Json

try {
    $Response = Invoke-RestMethod -Uri "$SeaTunnelRestUrl/api/v1/plugin/job/submit" `
        -Method POST `
        -ContentType "application/json" `
        -Body $Body -TimeoutSec 60

    Write-Host "Job submitted successfully"
    if ($Response -is [hashtable]) {
        $Response | ConvertTo-Json -Depth 10
    } else {
        Write-Host "Response: $Response"
    }
}
catch {
    Write-Error "Failed to submit job: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $Response = $_.Exception.Response.GetResponseStream()
        $Reader = New-Object System.IO.StreamReader($Response)
        $Reader.ReadToEnd()
    }
    exit 1
}