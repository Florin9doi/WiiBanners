Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

#### Help
if ($args.count -gt 0 -and ($args[0] -eq "--help" -or $args[0] -eq "-h")) {
	Write-Output 'Usage: .\BackupBanners.ps1 "<Wii NAND Root>" <Git/Zip>'
	Write-Output '       In Git mode the files will be placed in .\Wii\title\ folder to prepare a commit'
	Write-Output '       In Zip mode the files will be archived to be sent manually (Discord/Github)'
	Write-Output 'Example: .\BackupBanners.ps1 "~\Documents\Dolphin Emulator\Wii\" Zip'
	exit
}

#### wiiNandRoot
if ($args.count -gt 0) {
	$wiiNandRoot = $args[0]
} else {
	$wiiNandRoot = [Environment]::GetFolderPath("MyDocuments") + "\Dolphin Emulator\Wii\title"
}
Write-Output " - Wii NAND Root = $wiiNandRoot"
if ( -not (Test-Path -Path "$wiiNandRoot")) {
	Write-Output "Error: Wii NAND Root ($wiiNandRoot) not found"
	pause
	exit
}

#### mode
if ($args.count -gt 1) {
	$mode = $args[1]
	if ($mode -ne "Git" -and $mode -ne "Zip") {
		Write-Output "Error: unknown mode: $mode"
		pause
		exit
	}
} else {
	if (Test-Path -Path ".git") {
		$mode = "Git"
	} else {
		$mode = "Zip"
	}
}
Write-Output " - Mode = $mode"

#### pack
if ($mode -eq "Git") {
	$files = Get-ChildItem $wiiNandRoot\banner.bin -Recurse -File
	foreach ($file in $files) {
		$name = $(Resolve-Path -Path $file -Relative) -replace '\.\\',''
		Write-Output $name
		$dest = $name -match "([0-9a-fA-F]{8}\\[0-9a-fA-F]{8}\\data\\banner\.bin)"
		if ($dest) {
			$dest = "Wii\title\" + $matches[0]
			$null = New-Item -ItemType File -Path $dest -Force
			Copy-Item -path $name -destination $dest -Force
		}
	}
} elseif ($mode -eq "Zip") {
	$files = Get-ChildItem $wiiNandRoot\banner.bin -Recurse -File
	$zip = [System.IO.Compression.ZipFile]::Open("$pwd\Banners_$(Get-Date -Format yyyy-MM-dd-HH-mm).zip", [System.IO.Compression.ZipArchiveMode]::Create)

	foreach ($file in $files) {
		$name = $(Resolve-Path -Path $file -Relative) -replace '\.\\',''
		Write-Output $name
		$dest = $name -match "([0-9a-fA-F]{8}\\[0-9a-fA-F]{8}\\data\\banner\.bin)"
		if ($dest) {
			$dest = $matches[0]
			$zentry = $zip.CreateEntry($dest)
			$zentryWriter = New-Object -TypeName System.IO.BinaryWriter $zentry.Open()
			$zentryWriter.Write([System.IO.File]::ReadAllBytes($file))
			$zentryWriter.Flush()
			$zentryWriter.Close()
		}
	}
	$zip.Dispose()
}
pause
