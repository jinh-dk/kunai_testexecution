<#
    Run Kunai Frontend and backend services. Can specify the log file names.
#>
param(
    [bool]$waiting = $false,
    [string]$localbackendlogfile = $null,
    [string]$localfrontendlogfile = $null
)

#.\_runSCD.ps1
if ($localbackendlogfile) {
    # Notice double { and } for -command switch, as we use string formatter here. 
    invoke-expression ('cmd /c start powershell -Command {{ .\_runKunaiBackend.ps1 -logfile {0} }}' -f $localbackendlogfile)
} else {
    invoke-expression ('cmd /c start powershell -Command { .\_runKunaiBackend.ps1}')

}


if ($Waiting) 
{
    Start-Sleep -s 300
}

if ($localfrontendlogfile) {
    invoke-expression ('cmd /c start powershell -Command {{ .\_runKunaiFrontend.ps1 -logfile {0}; read-host}}' -f $localfrontendlogfile)
} else {
    invoke-expression ('cmd /c start powershell -Command { .\_runKunaiFrontend.ps1; read-host}')
}