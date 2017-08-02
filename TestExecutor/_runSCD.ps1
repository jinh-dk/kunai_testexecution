invoke-expression 'cmd /c start powershell -Command { .\_runBuilderServers.ps1}'
Start-Sleep -s 10
# TODO: Should we move Kallithea to dbs, as it is a part of test environment, not Kunai
invoke-expression 'cmd /c start powershell -Command { .\_runKallithea.ps1}'