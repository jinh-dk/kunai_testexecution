$localtime = Get-Date -Format yyyyMMddhhmmss

$testfwkfolder = "C:\Users\jinxu\Documents\GitHub\kunai\dev\itest\test\Publishing.IntegrationTests.Framework\"
$testfwkproj = "Publishing.IntegrationTests.Framework.csproj"

$testcasefolder_api = "C:\Users\jinxu\Documents\GitHub\kunai\dev\itest\test\Publishing.Api.IntegrationTest\"
$testcaseproj_api = "Publishing.Api.IntegrationTest.csproj"

$testresultfolder = "C:\Users\jinxu\Documents\GitHub\kunai\test\result\"
$testresultname = "integrationTest.xml"

$venvgooglefolder = ".\GoogleSpreadSheet\Scripts\"


$masterfolder = "/Users/jinxu/codes/kunai/master/"
$masterdockerfolder = "/Users/jinxu/codes/kunai/master/docker/"
$masterfrontendfolder = "C:\Users\jinxu\Documents\GitHub\kunai\master\frontend\"
$testfolder = "C:\Users\jinxu\Documents\GitHub\kunai\test\"

$logfolder = "/Users/jinxu/codes/kunai/test/Log/"
$backendlogfile = "BackendOsx.log"
$localbackendlogfile = $backendlogfile -replace ".log", "$localtime.log"
$backendlogfileid = "1iecekG5Rlnme9rfJ4PWP1KPUh1Kt8JOLIMcJHIeZmvk"
$frontendlogfile = "FrontendOsx.log"
$localfrontendlogfile = $frontendlogfile -replace ".log", "$localtime.log"
$frontendlogfileid = "1CmjkWFjPUQZJmEHqgnFhruFMyfR2Gxm8EDGmUKPaMbY"
$buildserverlogfile = "BuildServersOsx.log"
$localbuildserverlogfile = $buildserverlogfile -replace ".log", "$localtime.log"
$kallithealogfile = "Kallithea.log"
$localkallithealogfile = $kallithealogfile -replace ".log", "$localtime.log"
$updatemasterlogfile = "PullMaster.log"
$errorcsvfile = "Error.csv"

$teamslackchannel = "G396UA2RY"
$ownslackChannel = "@jinxu"

$dockerserver = "docker_server_1"
$serverlogpath = ":/app/src/Publishing.Server/logs"
$dockerapi = "docker_api_1"
$apilogpath = ":/app/src/Publishing.Api/logs"

