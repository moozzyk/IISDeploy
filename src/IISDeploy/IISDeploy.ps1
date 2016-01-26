param(
    [Parameter(Mandatory=$true)]
    [string]$sourceFolder,

    [Parameter(Mandatory=$true)]
    [string]$targetFolder,

    [Parameter(Mandatory=$true)]
    [string]$appOfflineFolder,

    [string]$webRoot="wwwroot"
)

$InstallDir = $env:DOTNET_INSTALL_DIR
if (!$InstallDir) {
    $InstallDir = "$env:LocalAppData\Microsoft\dotnet"
}

$LocalFile = "$InstallDir\cli\.version"
if (!(Test-Path $LocalFile))
{
    Write-Host ".Net Tools not installed - exiting"
    exit 1
}

if (!(Test-Path $appOfflineFolder))
{
    Write-Host "Can't find the offline app"
    exit 1
}

#webroot - read from hosting.json/configuration? (can't be done in PS)
$TargetWebRootFolder = Join-Path -Path $targetFolder $webRoot

Write-Host "Target webroot $TargetWebRootFolder"

if (!(Test-Path $TargetWebRootFolder))
{
    New-Item -ItemType directory -Path $TargetWebRootFolder
}

$AppOfflineFolder =  Join-Path -Path $targetFolder [String][GUID]::NewGuid
