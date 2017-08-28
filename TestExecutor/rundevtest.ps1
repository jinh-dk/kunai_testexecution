<#
    Run integration test for a branch. 
#>

param(
    [string]$branchname,
    [string]$gitrepo = 'https://github.com/Unity-Technologies/Kunai.git',
    [bool]$RemoveBranchAfterTest = $true
)

. .\settings.ps1

$dockerfolder = "\docker"

## Stop current docker
.\ManageKunaiBackendService.ps1 -action down

## Delete the docker setups
.\deleteDockerSetup.ps1

## checkout master
Push-Location $devmainfolder
$foldername = "devtest$branchname"
if (-not (Test-Path $foldername)) {
    git clone $gitrepo $foldername
}
Pop-Location


## check out branch
Push-Location $devmainfolder$foldername
$cmd = "git checkout $branchname"
iex $cmd
$cmd = "git submodule update --init"
iex $cmd
Pop-Location

## run docker compose, wait 10 minutes for initilization.
Push-Location $devmainfolder$foldername$dockerfolder
$cmd = "docker-compose.exe -f docker-compose-dbs.yml -f docker-compose-full.yml up"
Invoke-Expression ('cmd /c start powershell -Command {{ {0}; }}' -f $cmd)
Start-Sleep -Seconds 600
Pop-Location

## Execute test
.\ExecuteTest.ps1 -testcasepath $testcasefolder_api

## Stop all the containers  
Push-Location $devmainfolder$foldername$dockerfolder
Write-Host $pwd
$cmd = "docker-compose.exe -f docker-compose-dbs.yml -f docker-compose-full.yml down"
iex $cmd
Pop-Location

## Delete the container and images
.\deleteDockerSetup.ps1

## Delete checkout branch
if ($RemoveBranchAfterTest){
    Push-Location $devmainfolder
    Remove-Item -Recurse -Force ".\$foldername"
    Pop-Location
}
