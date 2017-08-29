param(
    [int]$WaitingTimeInMinute = 40,
    [int]$ExtraWaitingTimeInSeconds = 0,
    [int]$CheckInterval = 5,
    [string]$Service,
    [string]$DockerFolder
)

. .\settings.ps1

if(-not $DockerFolder) {
    $DockerFolder = $masterdockerfolder
}

Push-Location $DockerFolder

$isServiceRunning = $false
$cnt = 0

while(-not $isServiceRunning) {
    $cmd = 'docker-compose.exe -f .\docker-compose-dbs.yml -f .\docker-compose-full.yml ps | Select-String {0}' -f $Service    
    $_service = iex $cmd
    if ($_service) {
        $isServiceRunning = $_service.ToString().Contains('Up')
    }

    if (-not $isServiceRunning) {

        Write-Host $Service is not running
    }

    Start-Sleep -Seconds $CheckInterval
    $cnt++
    if ($cnt -ge $WaitingTimeInMinute * 60 / $CheckInterval) {
        Write-Host -ForegroundColor Red ( 'The {0} docker envirnment is not available after {1} minutes. Stop waiting.' -f $Service, $WaitingTimeInMinute )
        Write-Host -ForegroundColor Red ( 'Execute {0} ; Result {1}' -f $cmd,  $_service )
        break
    }
}

if ($ExtraWaitingTimeInSeconds -gt 0) {
    Start-Sleep -Seconds $ExtraWaitingTimeInSeconds
}

Pop-Location