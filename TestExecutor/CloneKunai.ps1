<#
    Clone the Kunai and install the submodule.
#>

param (
    [string]$folder = 'kunaitest'
)

$cmd = 'git clone https://github.com/Unity-Technologies/Kunai.git {0}' -f $folder
iex $cmd
$cmd = 'git submodule update --init'
iex $cmd