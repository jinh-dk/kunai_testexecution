param (
    [bool] $reloadkatana = $false,
    [bool] $reloadfileserver = $true,
    [bool] $reloadkatanabase = $false,
    [bool] $reloadbuildserver = $false
)

docker rm docker_api_1
docker rm docker_server_1
docker rm docker_postgres_1
docker rm docker_repo-cache_1
docker rm docker_hangfire-db_1
docker rmi -f docker_server
docker rmi -f docker_api


if ($reloadkatana -eq $true) {
    docker rm $(docker ps -a -q --filter="name=katana")
    docker rmi docker_katana
    docker rmi docker_katana_artifacts
    docker rmi docker_katana_slave
    docker rmi docker_katana_mysql
}

if ($reloadkatanabase -eq $true) 
{
    docker rmi katana_base
}

if ($reloadfileserver -eq $true) {
	docker rm docker_fileserver_server_1
	docker rmi docker_fileserver_server
	docker rm docker_fileserver_proxy_1
	docker rmi docker_fileserver_proxy
}

if ($reloadbuildserver -eq $true){    
    docker rm docker_sourcecodestripagent01_1
    docker rm docker_sourcecodestripagent02_1
    docker rmi kunai_buildserver
    docker rm docker_kallithea_1
}