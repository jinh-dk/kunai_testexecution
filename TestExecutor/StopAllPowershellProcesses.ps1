<#
    Stop the powershell process which hosts node.exe process.
    Stop the powershell process which hosts docker-compose.exe processes.
    Stop all running dockers.
    Stop all node.exe process.
#>

.\StopHostPowershellProcess.ps1 -processname `"node.exe`"
.\StopHostPowershellProcess.ps1 -processname `"docker-compose.exe`"

docker stop $(docker ps -aq)

$processes = Get-Process -Name "node"

foreach ($process in $processes) {    
    Stop-Process -Force $process.Id    
}

# $processes = Get-Process -Name "powershell"

# foreach ($process in $processes) {
#     if ($pid -ne $process.Id) 
#     {
#         Stop-Process $process.Id
#     }    
# }


