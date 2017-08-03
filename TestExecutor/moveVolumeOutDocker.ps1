. .\settings.ps1
Push-Location $builderserverrootfolder

$folders = Get-ChildItem -Directory
foreach ($f in $folders) {
    Write-Host $f.Name
    if( $f.Name -like "*buildserver_*" )
    {
        Write-Host $f.Name
        Push-Location $f.Name
        mkdir -p $tempfolder$f
        if(Test-Path -Path ".\source")
        {
            Move-Item -Path .\source -Destination $tempfolder$f\source -Force
        }

        if(Test-Path -Path ".\destination")
        {
            Move-Item -Path .\destination -Destination $tempfolder$f\destination -Force         
        }

        if(Test-Path -Path ".\build")
        {            
            Move-Item -Path .\build -Destination $tempfolder$f\build -Force
        }
        Pop-Location
    }
}

Pop-Location


Push-Location $kallithearootfolder
$kallitheafolder = "kallithea\"
Move-Item -Path * -Destination $tempfolder$kallitheafolder\ -Force
Pop-Location
