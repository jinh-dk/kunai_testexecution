param (
    [switch] $reloadkatana = $false
)

$scriptfolder = "C:\Users\jinxu\Documents\GitHub"
Push-Location $scriptfolder
.\deleteDockerSetup.ps1 $reloadkatana
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
