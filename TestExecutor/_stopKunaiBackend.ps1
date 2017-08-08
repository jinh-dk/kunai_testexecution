
param(
    [switch] $buildserver = $true,
    [switch] $dbs = $true,
    [switch] $full = $true,
    [string] $service = $null
)
. .\settings.ps1

Push-Location $masterdockerfolder

if ($buildserver)
{
    $buildserver_f = '-f .\docker-compose-buildserver.yml'
}

if ($dbs)
{
    $dbs_f = '-f .\docker-compose-dbs.yml'
}

if ($full)
{
    $full_f = '-f .\docker-compose-full.yml'
}

docker-compose $buildserver_f $dbs_f $full_f down $service

Pop-Location