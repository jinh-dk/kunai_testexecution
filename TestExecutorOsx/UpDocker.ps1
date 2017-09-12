. ./settings.ps1

$dockerfolder = '/docker'

Push-Location $devmainfolder$foldername$dockerfolder
$cmd = "docker-compose -f docker-compose-buildserver.yml -f docker-compose-dbs.yml -f docker-compose-full.yml up"
Write-Host $devmainfolder$foldername$dockerfolder
Write-Host $cmd
Invoke-Expression $cmd
Pop-Location

