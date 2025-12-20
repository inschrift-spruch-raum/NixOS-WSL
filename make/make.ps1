$RootDir = Split-Path -Parent "$PSScriptRoot"

wsl --install --no-distribution
wsl --update
wsl --shutdown

Read-Host "Enter 继续"

$WSLRootDir = "$RootDir".Replace("C:\", "/mnt/c/").Replace("\", "/")

. "$PSScriptRoot\Win\HostsSet\HostsSet.ps1"
. "$PSScriptRoot\Win\WSLConf\WSLConfCopy.ps1"

Read-Host "Enter 继续"

wsl --install --from-file "$RootDir\WSLSysFile\NixOS.wsl" --location "C:\WSL\NixOS" --no-launch
wsl --set-default "NixOS"
wsl --shutdown

wsl sh "$WSLRootDir/make/WSL/WSLInit.sh"
wsl --shutdown
