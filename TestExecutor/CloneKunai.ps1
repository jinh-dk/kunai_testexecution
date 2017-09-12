<#
    Clone the Kunai and install the submodule.

    Always clone to the dev folder.
#>

param (
    [string]$folder = 'kunaitest'
)

. ./settings.ps1

Push-Location $devmainfolder
$cmd = 'git clone https://github.com/Unity-Technologies/Kunai.git {0}' -f $folder
iex $cmd
cd "./$folder"
$cmd = 'git submodule update --init'
iex $cmd
Pop-Location