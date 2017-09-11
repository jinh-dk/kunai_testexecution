<#
    Run integration test for a branch. 
#>

param(
    [string]$branchname,
    [string]$gitrepo = 'https://github.com/Unity-Technologies/Kunai.git',
    [bool]$RemoveBranchAfterTest = $true
)

. ./settings.ps1
$dockerfolder = "/docker"

## Stop current docker
.\ManageKunaiBackendService.ps1 -action down

## Delete the docker setups
.\deleteDockerSetup.ps1

## checkout master
# Many branch contains back slash, which is bad to folder structure, use dash instead.
Push-Location $devmainfolder
$foldername = "devtest-$branchname".Replace("/", "-")

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
$cmd = "docker-compose -f docker-compose-buildserver.yml -f docker-compose-dbs.yml -f docker-compose-full.yml up"
. ./Start-InNewWindowMacOS
Start-InNewWindowMacOS -NoExit { }

#$args = "-f docker-compose-buildserver.yml -f docker-compose-dbs.yml -f docker-compose-full.yml up"
    
#Start-Process docker-compose -ArgumentList $args
#open -a Terminal.app `/usr/local/bin/powershell ./UpDocker.ps1`

#$cmd = "docker-compose -f docker-compose-buildserver.yml -f docker-compose-dbs.yml -f docker-compose-full.yml up"
#Invoke-Expression $cmd

#Invoke-Expression ('cmd /c start powershell -Command {{ {0}; }}' -f $cmd)
#Invoke-Expression ('open -a Terminal /usr/local/bin/powershell -Command {{ {0}; }}' -f $cmd)


Start-Sleep -Seconds 10
.\CheckDockerComposeServiceRunning.ps1 -Service docker_server_1 -WaitingTimeInMinute 10 -DockerFolder $devmainfolder$foldername$dockerfolder
.\CheckDockerComposeServiceRunning.ps1 -Service docker_api_1 -WaitingTimeInMinute 10 -ExtraWaitingTimeInSeconds 300 -DockerFolder $devmainfolder$foldername$dockerfolder

## Execute test
.\ExecuteTest.ps1 -testcasepath $testcasefolder_api

## Stop all the containers  
Push-Location $devmainfolder$foldername$dockerfolder
Write-Host $pwd
$cmd = "docker-compose -f docker-compose-dbs.yml -f docker-compose-full.yml down"
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
