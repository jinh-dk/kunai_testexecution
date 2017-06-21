# Check the integrationtest.xml
# if there is a testcase failed, send the error message to slack channel. 
# Only 360 chars are sent. 

# Slackbot is running in virtualenv. 

. .\settings.ps1

$env:VIRTUAL_ENV_DISABLE_PROMPT = 1
[xml]$IntegrationTestResult = Get-Content $testresultfolder$testresultname

Write-host("**************   Reporting *******************")

$testcases = $IntegrationTestResult.assemblies.assembly.collection.test
$olderror = Import-Csv $logfolder$errorcsvfile
$newerror = @()
$errorcounter = 0
$ErrorFileId = "1YCdJoTGPLcFuePoqY5MrNUUR_t6F_WJ6jRHsxMPYzh8"
$range = "A1:Z1000"

Set-ExecutionPolicy Unrestricted
.\GoogleSpreadSheet\Scripts\activate        
curl.exe -O https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/CreateTestcaseOverview/ClearSpreadSheet.py
python.exe ClearSpreadSheet.py $ErrorFileId $range 
deactivate
Set-ExecutionPolicy RemoteSigned

foreach($testcase in $testcases) {
    $TestcaseFullPath = $testcase.name
    $TestScenario = $testcase.method
    $Executiontime = $testcase.time
    $testresult = $testcase.result
    
    if ($testresult -eq "Fail"){
        $errorcounter++
        $sendslack = $true
        $ErrorMessage = $testcase.failure.message.'#cdata-section' 

        
        ## Send the error to Spread sheet, and local machine        
        
        $range = "A$errorcounter" + ":B$errorcounter"        
        Set-ExecutionPolicy Unrestricted
        .\GoogleSpreadSheet\Scripts\activate       
        curl.exe -O https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/CreateTestcaseOverview/UploadCSVtoGDrive.py
        python.exe UploadCSVToGDrive.py $ErrorFileId $range $TestcaseFullPath $ErrorMessage
        deactivate
        Set-ExecutionPolicy RemoteSigned
        
        #Recorde the new error
        $details = @{
            Testcase = $TestcaseFullPath
            ErrorMessage =  $ErrorMessage
        }

        $newerror += New-Object PSObject -Property $details        

        ## Check if the error is an old one##
        if ( $olderror.Testcase.Contains($TestcaseFullPath) -and $olderror.ErrorMessage.Contains($ErrorMessage) ) {              
            $sendslack = $false
        }
                        
        ## Only send new error to slack
        if ($sendslack) {
            if ($ErrorMessage.length -gt 360) {
                $ErrorMessage = $ErrorMessage.subString(0, 359)
            }
            $ErrorMessage = $TestcaseFullPath + ":" + $ErrorMessage
            Set-ExecutionPolicy Unrestricted
            .\slack\Scripts\activate
            #pip install slackclient
            #curl.exe -O https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/SendSlackMessage.py
            python.exe .\SendErrorToSlack.py "$ErrorMessage"
            deactivate
            Set-ExecutionPolicy RemoteSigned        
        }        
    } else {
        $ErrorMessage = ""
    }
}

$newerror | Export-Csv -Path $logfolder$errorcsvfile -NoTypeInformation
