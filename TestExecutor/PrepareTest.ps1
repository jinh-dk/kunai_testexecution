param (
    [switch] $reloadkatana = $false
)

. .\settings.ps1
. ..\settings.ps1

Push-Location $testfolder
.\deleteDockerSetup.ps1 -reloadkatana $reloadkatana
.\pullMaster.ps1
&.\runKunai.ps1
Pop-Location

if ($reloadkatana) 
{
    Start-Sleep -Seconds 1200
} else 
{
    Start-Sleep -Seconds 480
}
