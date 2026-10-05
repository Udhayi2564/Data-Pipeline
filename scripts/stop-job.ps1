# Stop SeaTunnel Job
# Usage: .\stop-job.ps1 [-JobId]

param(
    [string]$JobId
)

# Configuration
$SeaTunnelRestUrl = "http://localhost:8080"

if (-not $JobId) {
    Write-Error "JobId is required"
    exit 1
}

Write-Host "Stopping job: $JobId"

try {
    $Response = Invoke-RestMethod -Uri "$SeaTunnelRestUrl/api/v1/plugin/job/stop/$JobId" -Method POST
    Write-Host "Job stopped successfully"
}
catch {
    Write-Error "Failed to stop job: $($_.Exception.Message)"
    exit 1
}