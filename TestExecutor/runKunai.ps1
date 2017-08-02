#.\_runSCD.ps1
invoke-expression 'cmd /c start powershell -Command { .\_runKunaiBackend.ps1}'
Start-Sleep -s 300
invoke-expression 'cmd /c start powershell -Command { .\_runKunaiFrontend.ps1; read-host}'