param(
    [Parameter(Mandatory=$true)]
    [string]$sourceFolder,

    [Parameter(Mandatory=$true)]
    [string]$targetFolder,

    [Parameter(Mandatory=$true)]
    [string]$appOfflineFolder,

    [string]$webRoot="wwwroot"
)

if (!(Test-Path "$sourceFolder"))
{
    Write-Host "The source folder '$sourceFolder' does not exist or is inaccessible"
    exit 1
}

if (!(Test-Path "$targetFolder"))
{
    Write-Host "The target folder '$targetFolder' does not exist or is inaccessible"
    exit 1
}

if (!(Test-Path "$appOfflineFolder"))
{
    Write-Host "The oflline app folder '$appOfflineFolder' does not exist or is inaccessible"
    exit 1
}

Write-Host "Starting deploying '$sourceFolder' to '$targetFolder'. Using '$appOfflineFolder' as the offline app"

#webroot - read from hosting.json/configuration? (can't be done in PS)
$TargetWebRootFolder = Join-Path -Path $targetFolder $webRoot

if (!(Test-Path "$TargetWebRootFolder"))
{
    New-Item -ItemType directory -Path "$TargetWebRootFolder"
}

$AppOfflineSubfolder = [String][GUID]::NewGuid()
$AppOfflineTargetFolder =  Join-Path -Path $targetFolder $AppOfflineSubfolder

Write-Host "Copying the offline app to '$AppOfflineTargetFolder'"

Copy-Item "$appOfflineFolder\*" "$AppOfflineTargetFolder\" -Force -Recurse

Write-Host "Updating '$TargetWebRootFolder\web.config' to point to the offline app"

$AppOfflineWebConfig = @'
<configuration>
  <system.webServer>
    <handlers>
      <add name="httpPlatformHandler" path="*" verb="*" modules="httpPlatformHandler" resourceType="Unspecified"/>
    </handlers>
    <httpPlatform processPath="..\{0}\AppOffline.exe" stdoutLogEnabled="false" startupTimeLimit="3600" stdoutLogFile="..\logs\stdout.log"/>
  </system.webServer>
</configuration>
'@ -f $AppOfflineSubfolder

$AppOfflineWebConfig | Out-File -FilePath "$TargetWebRootFolder\web.config" -ErrorAction Stop

Write-Host "Deleting existing application"

(Get-ChildItem $targetFolder -Exclude wwwroot,web.config -Recurse | select -ExpandProperty fullname) -NotLike "*$AppOfflineSubfolder*"  | Sort Length -Descending | Remove-Item -Recurse

Write-Host "Deploying target application from '$sourceFolder' to '$targetFolder'"

Copy-Item "$sourceFolder\*" "$targetFolder\" -Exclude "web.config" -Force -Recurse
Copy-Item "$sourceFolder\$webRoot" "$TargetWebRootFolder" -Force -Recurse

Write-Host "Cleaning up the offline app"

Remove-Item "$AppOfflineTargetFolder" -Recurse -ErrorVariable errors -ErrorAction SilentlyContinue
if ($errors.Count -gt 0)
{
    Write-Warning "Removing the offline app failed. Please remove the '$AppOfflineTargetFolder' folder manually"
}
