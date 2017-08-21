#.\_runSCD.ps1
param(
    [bool]$waiting = $false
)

invoke-expression 'cmd /c start powershell -Command { .\_runKunaiBackend.ps1}'
if ($Waiting) 
{
    Start-Sleep -s 300
}
invoke-expression 'cmd /c start powershell -Command { .\_runKunaiFrontend.ps1; read-host}'