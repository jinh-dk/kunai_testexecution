param(
    [int]$WaitingTimeInMinute = 40,
    [int]$ExtraWaitingTimeInSeconds = 0,
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
    Write-Host $cmd
    $_service = iex $cmd
    if ($_service) {
        $isServiceRunning = $_service.ToString().Contains('Up')
    }

    if (-not $isServiceRunning) {

        Write-Host $Service is not running
    }

    Start-Sleep -Seconds 5
    $cnt++
    if ($cnt -ge $WaitingTimeInMinute * 12) {
        Write-Host -ForegroundColor Red "The Envirnment is not available after 40 minutes. Quit loop"
        break;
    }
}

if ($ExtraWaitingTimeInSeconds -gt 0) {
    Start-Sleep -Seconds $ExtraWaitingTimeInSeconds
}

Pop-Location