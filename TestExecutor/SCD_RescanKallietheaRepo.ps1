<#
    Rescan kallithea repo in testing. 
    
    :After clean the volumed folder. The repo in Kallithea database need rescan. 
    :This script will rescan the repo.
#>

# Login Kallietha
$url = "http://localhost:3080/_admin/login"
$body = "username=admin&password=K4ll1th34&sign_in=Log+In"
$webrequest = Invoke-RestMethod -Uri $url -Method Post -ContentType application/x-www-form-urlencoded -Body $body -SessionVariable websession
$cookies = $websession.Cookies.GetCookies($url) 
foreach ($cookie in $cookies) { 
    # You can get cookie specifics, or just use $cookie 
    # This gets each cookie's name and value 
    Write-Host "$($cookie.name) = $($cookie.value)" 
}

#Get the authentication_token
$patternA = [regex]".*(_.*_token).*"
$matchResultA = $patternA.Match($webrequest) 
$matchlineA = $matchResultA.Captures[0].value

$patternB = [regex]"\d+"
$matchResultB = $patternB.Match($matchlineA)
$token = $matchResultB.Captures[0].Value

$url = "http://localhost:3080/_admin/settings/mapping"
$body = "_authentication_token=$token&destroy=True&rescan=Rescan+Repositories"
Invoke-RestMethod -Uri $url -Method Post -ContentType application/x-www-form-urlencoded -Body $body -WebSession $websession