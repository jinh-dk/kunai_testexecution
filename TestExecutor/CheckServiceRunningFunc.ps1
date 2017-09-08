function CheckServiceRunning  {
    param(
        [Parameter(Mandatory)] [string] $Service        
    )

    Push-Location $location
    $isServiceRunning = $false    
    $cmd = 'docker-compose.exe -f .\docker-compose-dbs.yml -f .\docker-compose-full.yml ps | Select-String {0}' -f $Service    
    $_service = iex $cmd
    if ($_service) {
        $isServiceRunning = $_service.ToString().Contains('Up')
    }
    Pop-Location
    return $isServiceRunning
}