<#
    move the volumed folder from temp folder into docker folder.

    Only the "source" folder in BuildServer need move out and move in to avoid long pull process.
    
    Detionation and build folder should be cleaned before test (for postive test)
    Kallithea folder should be cleaned too.

#>

. .\settings.ps1



Push-Location $builderserverrootfolder

$folders = Get-ChildItem -Directory
foreach ($f in $folders) {
    Write-Host $f.Name
    if( $f.Name -like "*buildserver_*" )
    {
        Write-Host $f.Name
        Push-Location $f.Name        
        Move-Item -Path $tempfolder$f\source -Destination .\source -Force
        #Move-Item -Path $tempfolder$f\destination -Destination .\destination -Force
        #Move-Item -Path $tempfolder$f\build -Destination .\build -Force
        Pop-Location
    }
}

Pop-Location


Push-Location $kallithearootfolder
$kallitheafolder = "kallithea\"
#Move-Item -Path $tempfolder$kallitheafolder\* -Destination $kallithearootfolder -Force
Pop-Location
