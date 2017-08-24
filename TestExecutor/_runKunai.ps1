#.\_runSCD.ps1
param(
    [bool]$waiting = $false,
    [string]$localbackendlogfile = $null,
    [string]$localfrontendlogfile = $null
)


# Notice double { and } for -command switch, as we use string formatter here. 
invoke-expression ('cmd /c start powershell -Command {{ .\_runKunaiBackend.ps1 -logfile {0} }}' -f $localbackendlogfile)
if ($Waiting) 
{
    Start-Sleep -s 300
}
invoke-expression ('cmd /c start powershell -Command {{ .\_runKunaiFrontend.ps1 -logfile {0}; read-host}}' -f $localfrontendlogfile)