# Check the integrationtest.xml
# if there is a testcase failed, send the error message to slack channel. 
# Only 360 chars are sent. 

# Slackbot is running in virtualenv. 

param(
    [bool] $localdebugmode = $false
)

. .\settings.ps1

$env:VIRTUAL_ENV_DISABLE_PROMPT = 1
[xml]$IntegrationTestResult = Get-Content $testresultfolder$testresultname

Write-host("**************   Reporting *******************")
if ($localdebugmode) {
    Write-host("** In Debug mode. **")
}

$testcases = $IntegrationTestResult.assemblies.assembly.collection.test
$olderror = Import-Csv $logfolder$errorcsvfile
$newerror = @()
$errorcounter = 0
$ErrorFileId = "1YCdJoTGPLcFuePoqY5MrNUUR_t6F_WJ6jRHsxMPYzh8"
$range = "A1:Z1000"

# Remove the content in the spreadsheet, so only new contents in the spreadsheet.
Set-ExecutionPolicy Unrestricted
Invoke-WebRequest -OutFile ClearSpreadSheet.py -Uri https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/CreateTestcaseOverview/ClearSpreadSheet.py
.\GoogleSpreadSheet\Scripts\activate        
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

        
        ## Send the error to Spreadsheet, and local machine                
        $range = "A$errorcounter" + ":B$errorcounter"        
        Set-ExecutionPolicy Unrestricted
        Invoke-WebRequest -OutFile UploadCSVToGDrive.py -Uri https://raw.githubusercontent.com/jinxuunity/ownScript/master/python/CreateTestcaseOverview/UploadCSVtoGDrive.py        
        .\GoogleSpreadSheet\Scripts\activate       
        python.exe UploadCSVToGDrive.py $ErrorFileId $range $TestcaseFullPath $ErrorMessage
        deactivate

        #send the error to own slack channel
        .\slack\Scripts\activate     
        if ($ErrorMessage.length -gt 360) {
            $msg = $TestcaseFullPath + ":" + $ErrorMessage.subString(0, 359)
        } else {
            $msg = $TestcaseFullPath + ":" + $ErrorMessage
        }
        python.exe .\SendErrorToSlack.py "$msg" $ownslackChannel
        deactivate

        Set-ExecutionPolicy RemoteSigned
        
        #Record the new error
        $details = @{
            Testcase = $TestcaseFullPath
            ErrorMessage =  $ErrorMessage
        }
        $newerror += New-Object PSObject -Property $details        

        ## Check if the error is already known yesterday##
        if ( $olderror.Testcase.Contains($TestcaseFullPath) -and $olderror.ErrorMessage.Contains($ErrorMessage) ) {              
            $sendslack = $false
        }
                        
        ## If a new error, send it to team slack channel
        if ($sendslack -and (-not $localdebugmode)) {
            if ($ErrorMessage.length -gt 360) {
                $ErrorMessage = $ErrorMessage.subString(0, 359)
            }
            $ErrorMessage = $TestcaseFullPath+":"+$ErrorMessage
            Set-ExecutionPolicy Unrestricted
            .\slack\Scripts\activate
            #pip install slackclient            
            #python.exe .\SendErrorToSlack.py "$ErrorMessage" $teamslackchannel
            python.exe .\SendErrorToSlack.py "$ErrorMessage" $ownslackChannel
            deactivate
            Set-ExecutionPolicy RemoteSigned        
        }        
    } else {
        $ErrorMessage = ""
    }
}

$newerror | Export-Csv -Path $logfolder$errorcsvfile -NoTypeInformation
