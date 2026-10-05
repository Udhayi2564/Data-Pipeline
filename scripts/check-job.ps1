# Check SeaTunnel Job Status
# Usage: .\check-job.ps1 [-JobId]

param(
    [string]$JobId
)

# Configuration
$SeaTunnelRestUrl = "http://localhost:8080"

if (-not $JobId) {
    Write-Host "Fetching all jobs..."
    try {
        $Response = Invoke-RestMethod -Uri "$SeaTunnelRestUrl/api/v1/plugin/job/list" -Method GET
        Write-Host $Response | ConvertTo-Json -Depth 10
    }
    catch {
        Write-Error "Failed to fetch jobs: $($_.Exception.Message)"
        exit 1
    }
    return
}

Write-Host "Checking job: $JobId"

try {
    $Response = Invoke-RestMethod -Uri "$SeaTunnelRestUrl/api/v1/plugin/job/status/$JobId" -Method GET
    Write-Host "Job Status: $($Response.status)"
    Write-Host "Details: $($Response | ConvertTo-Json -Depth 10)"
}
catch {
    Write-Error "Failed to check job: $($_.Exception.Message)"
    exit 1
}