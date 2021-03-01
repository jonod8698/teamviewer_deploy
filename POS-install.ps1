if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;

$null = New-Item -Path C:\My_PowerShell_Transcripts -ItemType Directory -ErrorAction Ignore
Start-Transcript -Path 'C:\My_PowerShell_Transcripts\Get-Date-Transcript.txt'

curl https://raw.githubusercontent.com/jonod8698/teamviewer_deploy/master/HiBioAPI_setup_x64.exe --output HiBioAPI_setup_x64.exe

#font install
$SourceDir   = "${location}\FONTS"
$Source      = "${location}\FONTS\*"
$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$TempFolder  = "C:\Windows\Temp\Fonts"

# Create the source directory if it doesnt already exist
New-Item -ItemType Directory -Force -Path $SourceDir

New-Item $TempFolder -Type Directory -Force | Out-Null

Get-ChildItem -Path $Source -Include '*.ttf','*.ttc','*.otf' -Recurse | ForEach-Object {
    If (-not(Test-Path "C:\Windows\Fonts\$($_.Name)")) {

        $Font = "$TempFolder\$($_.Name)"
        
        # Copy font to local temporary folder
        Copy-Item $($_.FullName) -Destination $TempFolder
        
        # Install font
        $Destination.CopyHere($Font,0x10)

        # Delete temporary copy of font
        Remove-Item $Font -Force
    }
}

#Install BioAPI
curl https://raw.githubusercontent.com/jonod8698/teamviewer_deploy/master/HiBioAPI_setup_x64.exe --output HiBioAPI_setup_x64.exe
.\HiBioAPI_setup_x64.exe /S /v/qn
pause
