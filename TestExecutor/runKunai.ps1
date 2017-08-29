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
.\CheckDockerComposeServiceRunning.ps1 -Service docker_server_1 -WaitingTimeInMinute 30 -ExtraWaitingTimeInSeconds 5
.\CheckDockerComposeServiceRunning.ps1 -Service docker_api_1 -WaitingTimeInMinute 30 -ExtraWaitingTimeInSeconds 5

Write-Host "Both Server and Api docker are starting... wait another 5 minutes for initialization"
Start-Sleep -Seconds 300

#.\moveVolumeIntoDocker.ps1

