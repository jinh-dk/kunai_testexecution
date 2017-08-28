<#
    Run integration test for a branch. 
#>

param(
    [string]$branchname,
    [string]$gitrepo = 'https://github.com/Unity-Technologies/Kunai.git',
    [bool]$RemoveBranchAfterTest = $true
)

. .\settings.ps1

## Stop current docker
.\ManageKunaiBackendService.ps1 -action down

## Delete the docker setups
.\deleteDockerSetup.ps1

## checkout master
Push-Location $devmainfolder
$foldername = "devtest$branchname"
git clone $gitrepo $foldername
Pop-Location


## check out branch
Push-Location $devmainfolder$foldername
$cmd = "git checkout $branchname"
iex $cmd

## run docker compose
$cmd = "docker-compose.exe -f docker\docker-compose-dbs.yml -f docker\docker-compose-full.yml up"
iex $cmd
Pop-Location

## Execute test
.\ExecuteTest.ps1 -testcasepath $testfolder$testfolderapicase

## Stop all the containers  
Push-Location $devmainfolder$foldername
Write-Host $pwd
$cmd = "docker-compose.exe -f docker\docker-compose-dbs.yml -f docker\docker-compose-full.yml down"
iex $cmd
Pop-Location

## Delete the container and images
.\deleteDockerSetup.ps1

## Delete checkout branch
if ($RemoveBranchAfterTest){
    Push-Location $devmainfolder
    Remove-Item -Recurse -Force ".\$foldername"
}