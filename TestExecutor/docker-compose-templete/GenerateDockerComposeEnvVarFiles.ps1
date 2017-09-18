param(
    [string]$configrationfilename = "config.json"
)

Function RefineJson{
    param(
        [string]$json
    )

    return $json.Replace("@{", "").Replace("}", "").Replace(";", "`n")
}



$data = (Get-Content -Raw -Path config.json) 
$kunaiconfig = ConvertFrom-Json $data
#Write-Host $kunaiconfig

$hangfiredb = 'hangfire-db'
RefineJson($kunaiconfig.$hangfiredb) | Out-File "$hangfiredb.env" -Encoding utf8
$repocache = 'repo-cache'
RefineJson($kunaiconfig.$repocache) | Set-Content "$repocache.env" -Encoding utf8
$postgres = 'postgres'
RefineJson($kunaiconfig.$postgres) | Set-Content "$postgres.env" -Encoding utf8
$kallithea = 'kallithea'
RefineJson($kunaiconfig.$kallithea) | Set-Content "$kallithea.env" -Encoding utf8
$katana = 'katana'
RefineJson($kunaiconfig.$katana) | Set-Content "$katana.env" -Encoding utf8
$katana_artifacts = 'katana_artifacts'
RefineJson($kunaiconfig.$katana_artifacts) | Set-Content "$katana_artifacts.env" -Encoding utf8
$fileserver_server = 'fileserver_server'
RefineJson($kunaiconfig.$fileserver_server) | Set-Content "$fileserver_server.env" -Encoding utf8
$fileserver_proxy = 'fileserver_proxy'
RefineJson($kunaiconfig.$fileserver_proxy) | Set-Content "$fileserver_proxy.env" -Encoding utf8
$akamai_mock = 'akamai_mock'
RefineJson($kunaiconfig.$akamai_mock) | Set-Content "$akamai_mock.env" -Encoding utf8
$api = 'api'
RefineJson($kunaiconfig.$api) | Set-Content "$api.env" -Encoding utf8