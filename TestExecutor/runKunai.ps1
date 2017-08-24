param (
    [bool] $reloadkatana = $false,
    
    [string]$localbackendlogfile = $null,
    [string]$localfrontendlogfile = $null
)

&.\_runKunai.ps1 -localbackendlogfile $localbackendlogfile -localfrontendlogfile $localfrontendlogfile

if ($reloadkatana) 
{
    Start-Sleep -Seconds 1200
} else 
{
    Start-Sleep -Seconds 600
}
#.\moveVolumeIntoDocker.ps1

Start-Sleep -Seconds 120