<#
    Start, Stop, Up, Down the Kunai Backend services, which are defined in three docker-compose-xxx.yml file
#>
param(
    [bool]$buildserver = $true,
    [bool]$dbs = $true,
    [bool]$full = $true,
    [string]$action = 'stop',
    [string]$service = $null
)
. ./settings.ps1

Push-Location $masterdockerfolder
if ($buildserver)
{
    $buildserver_f = '-f docker-compose-buildserver.yml'
}

if ($dbs)
{
    $dbs_f = '-f docker-compose-dbs.yml'
}

if ($full)
{
    $full_f = '-f docker-compose-full.yml'
}

Write-Host "docker-compose $buildserver_f $dbs_f $full_f $action $service"
$cmd = "docker-compose $buildserver_f $dbs_f $full_f $action $service"
iex $cmd

Pop-Location