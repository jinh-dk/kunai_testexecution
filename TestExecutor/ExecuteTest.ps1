<#
    Exeucte the Xunit testcase. the testcase path is mandatory to give. 
#>

param (
    [string]$testcasepath,
    [string]$testcaseproj = $null,
    [string]$resultfolder = $null,
    [string]$resultname = $null
)



. .\settings.ps1

if (-not $testcaseproj) {
    $testcaseproj = $testcaseproj_api
}

if (-not $resultfolder) {
    $resultfolder = $testresultfolder
}

if (-not $resultname) {
    $resultname = $testresultname
}


Push-Location $testcasepath
Write-Host "Start Test in "  $testcasepath "," $testcaseproj "," $resultfolder$resultname

dotnet restore
dotnet build $testcaseproj
dotnet xunit -notrait "Status=Unstable" -verbose -parallel none -xml $resultfolder$resultname

Pop-Location