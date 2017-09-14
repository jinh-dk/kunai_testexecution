<#
    There is a defect in VS tool, which will automatically add a launchsetting.json file in api/properties folder. 
    In the json file, the tool auto assign a port to api, which differ than our setting 6002. 

    This script is a work around to detect and remove the folder. 
#>

param(
    [string]$folder = $null
)

. ./settings.ps1

if (-not $folder) {
    $folder = $masterfolder
}

if (Test-Path $folder"src\Publishing.Api\Properties")
{
    Write-Host -ForegroundColor Red "API\Properties folder found. Remove it"
    Remove-Item -Recurse -Force $folder"src\Publishing.Api\Properties"
}