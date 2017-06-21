docker stop $(docker ps -aq)


$processes = Get-Process -Name "node"

foreach ($process in $processes) {    
    Stop-Process $process.Id    
}

#$processes = Get-Process -Name "powershell"

#foreach ($process in $processes) {
#    if ($pid -ne $process.Id) 
#    {
#        Stop-Process $process.Id
#    }
    
#}
