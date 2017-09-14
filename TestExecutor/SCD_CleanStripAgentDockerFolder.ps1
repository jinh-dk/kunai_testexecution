<#
    This script has some issue with IO Exception. It is a infamous issue of Remove-item in powershell
    
    something like: 
    Remove-Item : Cannot remove item I:\Documents and Settings\m\My Documents\prg\net\FileHelpers: The directory is not empty.
        At line:1 char:3
        + rm <<<<  -Force -Recurse .\FileHelpers
        + CategoryInfo          : WriteError: (I:\Documents an...net\FileHelpers:DirectoryInfo) [Remove-Item], IOException
        + FullyQualifiedErrorId : RemoveFileSystemItemIOError,Microsoft.PowerShell.Commands.RemoveItemCommand

    
    USE BASH version to do the job.
#>

param(
    [string]$folder
)


. .\settings.ps1

if (-not $folder)
{
    $folder = $masterdockerfolder
}


Push-Location $folder
## https://stackoverflow.com/questions/38141528/cannot-remove-item-the-directory-is-not-empty
## The Remove-Item sometimes does not work properly, so pipe with Get-ChildItem
Get-ChildItem ".\BuildServer\volumes\buildserver_01\build\" -Recurse | Remove-Item -Force
Get-ChildItem ".\BuildServer\volumes\buildserver_01\destination\" -Recurse | Remove-Item -Force
Get-ChildItem ".\Kallithea\volumes\repos\.cache\" -Recurse | Remove-Item -Force
Get-ChildItem ".\Kallithea\volumes\repos\unity-2017\pop" -Recurse | Remove-Item -Force
Pop-Location

