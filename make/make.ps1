param(
    [switch]$Update = $false,
    [switch]$InitConfig = $false,
    [switch]$Install = $false,
    [switch]$Export = $false
)

$RootDir = Split-Path -Parent "$PSScriptRoot"
$WSLRootDir = "$RootDir".Replace("C:\", "/mnt/c/").Replace("\", "/")

if ($Update) {
    wsl --install --no-distribution
    wsl --update
    wsl --shutdown

    Read-Host "Enter 继续"
}

if ($InitConfig) {
    . "$PSScriptRoot\Win\HostsSet\HostsSet.ps1"
    . "$PSScriptRoot\Win\WSLConf\WSLConfCopy.ps1"

    Read-Host "Enter 继续"

}

if ($Install) {
    wsl --install --from-file "$RootDir\WSLFile\NixOS.wsl" --location "C:\WSL\NixOS" --no-launch
    wsl --set-default "NixOS"
    wsl --shutdown
}

wsl sh "$WSLRootDir/make/WSL/WSLInit.sh"
wsl --shutdown

if ($Export) {
    wsl --export NixOS "$RootDir\WSLFile\NixOS-Make.wsl" --format tar.gz
    wsl --shutdown
}
