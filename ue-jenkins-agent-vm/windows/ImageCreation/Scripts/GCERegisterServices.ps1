. ${PSScriptRoot}\..\Tools\Scripts\Register-AutoStartService.ps1

Write-Host "Registering Jenkins Agent script as autostarting..."

Register-AutoStartService -NssmLocation ${PSScriptRoot}\..\..\Runtime\Tools\nssm.exe -ServiceName "JenkinsAgent" -Program "powershell" -Arguments (Resolve-Path ${PSScriptRoot}\..\..\Runtime\Scripts\GCEService.ps1)

Write-Host "Done."
