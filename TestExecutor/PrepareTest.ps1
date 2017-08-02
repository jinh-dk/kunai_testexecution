param (
    [switch] $reloadkatana = $false,
    [switch] $reloadkatanabase = $false
)

. .\settings.ps1

.\deleteDockerSetup.ps1 -reloadkatana $reloadkatana -reloadkatanabase $reloadkatanabase
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
