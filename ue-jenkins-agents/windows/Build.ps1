param (
	[Parameter(Mandatory=$true)][string]$GceRegion,
	[Parameter(Mandatory=$true)][string]$Dockerfile,
	[Parameter(Mandatory=$true)][string]$ImageName,
	[Parameter(Mandatory=$true)][string]$ImageTag
)

Write-Host "Resizing C: partition to use all available disk space..."

. "${PSScriptRoot}\Resize-PartitionToMaxSize.ps1"
Resize-PartitionToMaxSize -DriveLetter C

Write-Host "Installing test dependencies..."

& "${PSScriptRoot}\InstallTestDependencies.ps1"

Write-Host "Running tests for Powershell scripts..."

& "${PSScriptRoot}\RunTests.ps1"

Write-Host "Setting up Docker authentication..."

& "${PSScriptRoot}\SetupDockerRegistryAuthentication.ps1" -GceRegion ${GceRegion}

Write-Host "Building image..."

& "${PSScriptRoot}\BuildImage.ps1" -Dockerfile $Dockerfile -ImageName ${ImageName} -ImageTag ${ImageTag}

Write-Host "Pushing image to registry..."

& "${PSScriptRoot}\PushImage.ps1" -ImageName ${ImageName} -ImageTag ${ImageTag}

Write-Host "Done."
