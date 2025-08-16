$RootDir = Split-Path -Parent "$PSScriptRoot"

wsl --install --no-distribution
wsl --update
wsl --shutdown

$WSLRootDir = "$RootDir".Replace("C:\", "/mnt/c/").Replace("\", "/")

. "$PSScriptRoot\Win\HostsSet\HostsSet.ps1"
. "$PSScriptRoot\Win\WSLConf\WSLConfCopy.ps1"

wsl --install --from-file "$RootDir\WSLSysFile\NixOS.wsl" --location "C:\WSL\NixOS" --no-launch
wsl --set-default "NixOS"
wsl --shutdown

wsl sh "$WSLRootDir/make/WSL/WSLInit.sh"
wsl --shutdown
