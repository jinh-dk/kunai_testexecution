<#
    Start Kunai Frontend and Backend services. and wait until they are up and running.
#>

param (    
    [string]$localbackendlogfile = $null,
    [string]$localfrontendlogfile = $null
)

&.\_runKunai.ps1 -localbackendlogfile $localbackendlogfile -localfrontendlogfile $localfrontendlogfile

## load setting after _runKunai.ps1, as the conflict of variable name.
. .\settings.ps1

## Improve the waiting time for building all the dockers. Now is more intelligent.   
## The server and api docker should be that last two docker on starting.  
## Stop check until this two dockers on starting process, 
$AreServerAndApiUp = $false
$isServerUp = $false
$isApiUp = $false
$cnt = 0
Push-Location $masterdockerfolder
while(-not $AreServerAndApiUp) {    
    $_server = (docker-compose.exe -f .\docker-compose-dbs.yml -f .\docker-compose-full.yml ps | Select-String docker_server_1)
    if ($_server) {
        $isServerUp = $_server.ToString().Contains('Up')
    }
    
    if(-not $isServerUp){
        Write-Host 'Server is not running'
    }
    
    $_api = (docker-compose.exe  -f .\docker-compose-dbs.yml -f .\docker-compose-full.yml ps | Select-String docker_api_1)
    if ($_api) {
        $isApiUp = $_api.ToString().Contains('Up')
    }    
    if(-not $isApiUp){
        Write-Host 'Api is not running'
    }
    $AreServerAndApiUp = $isServerUp -and $isApiUp
    
    
    $cnt++
    # Check every 5 seconds.
    Start-Sleep -Seconds 5
    if ($cnt > 480){
        Write-Host -ForegroundColor Red "The Envirnment is not available after 40 minutes. Quit loop"
        break;
    }    
}
Pop-Location

Write-Host "Both Server and Api docker are starting... wait another 5 minutes for initialization"
Start-Sleep -Seconds 300

#.\moveVolumeIntoDocker.ps1

