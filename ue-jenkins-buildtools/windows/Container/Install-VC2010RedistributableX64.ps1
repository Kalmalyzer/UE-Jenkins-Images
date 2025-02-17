class VC2010RedistributableX64InstallerException : Exception {
	$ExitCode

	VC2010RedistributableX64InstallerException([int] $exitCode) : base("VC++ 2010 Redistributable (x64) aka vcredist_x64.exe exited with code ${exitCode}") { $this.ExitCode = $exitCode }
}

function Install-VC2010RedistributableX64 {

	$TempFolder = "C:\Temp"
	$RedistExeName = "vcredist_x64.exe"

	# Create temp folder
	New-Item $TempFolder -ItemType Directory -Force -ErrorAction Stop | Out-Null
	
	try {
	
		# Determine installer download location
		$InstallerLocation = (Join-Path -Path $TempFolder -ChildPath $RedistExeName -ErrorAction Stop)

		# Download Microsoft Visual C++ 2010 Redistributable Package (x64) Installer
		Invoke-WebRequest -UseBasicParsing -Uri "https://download.microsoft.com/download/3/2/2/3224B87F-CFA0-4E70-BDA3-3DE650EFEBA5/vcredist_x64.exe" -OutFile $InstallerLocation -ErrorAction Stop
	
		$Process = Start-Process -FilePath $InstallerLocation -ArgumentList "/q" -NoNewWindow -Wait -PassThru
	
		if ($Process.ExitCode -ne 0) {
			throw [VC2010RedistributableX64InstallerException]::new($Process.ExitCode)
		}

	} finally {

		# Remove temp folder
		Remove-Item -Recurse $TempFolder -Force -ErrorAction Ignore
	}
}
