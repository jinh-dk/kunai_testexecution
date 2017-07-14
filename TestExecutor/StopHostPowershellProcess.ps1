param(
    [string]$processname    
)

Write-Host $processname
$processes = Get-WmiObject -Class Win32_Process -Filter "Name = $processname" 

foreach ($process in $processes)
{    
    $parentprocess = Get-Process -id $process.ParentProcessId  #Get parent id name    
    if ($parentprocess.Name.Contains('powershell'))
    {
        Write-Host "Stop Powershell process: " $parentprocess.Id
        #Stop-Process -Id $process.Id
        #Stop-Process -Id $parentprocess.Id
        taskkill.exe /F /PID $process.id
        taskkill.exe /F /PID $parentprocess.Id
    }

    if ($parentprocess.Name.Contains('cmd'))
    {        
        $cmdid = $parentprocess.id
        Write-Host "CMD process id is : " $parentprocess.id
        $cmdprocess = Get-WmiObject -Class Win32_Process -Filter "ProcessId = $cmdid"  # $parentprocess does not have parement id informaiton
        $grandparentprocess = Get-Process -id $cmdprocess.ParentProcessId

        Write-Host $grandparentprocess.Name
        if ($grandparentprocess.Name.Contains("powershell"))
        {
            Write-Host "Stop Powershell process: " $grandparentprocess.Id
            Stop-Process -id $processname.id
            #Stop-Process -id $parentprocess.id
            #Stop-Process -Id $grandparentprocess.Id
            taskkill.exe /F /PID $processname.id
            taskkill.exe /F /PID $parentprocess.id
            taskkill.exe /F /PID $grandparentprocess.Id
        }
    }
}
