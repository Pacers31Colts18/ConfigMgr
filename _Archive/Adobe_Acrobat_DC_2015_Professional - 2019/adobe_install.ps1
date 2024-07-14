<#
.Synopsis
Install script for Adobe Acrobat.
.Description
Install script for Adobe Acrobat.
.Notes
This installer installs the base setup.exe file. The setup.ini file contains information on where logging is stored, along with what .msp file to patch to.
To update the .msp patch. Place the latest patch into the directory and update the setup.ini file.
Install Log file is written to C:\InstallLogs\Install-Adobe-AcrobatProfessional.log
Error Log file is written to C:\InstallLogs\Error-Adobe-AcrobatProfessional.log
#>

$LogFile = "C:\InstallLogs\Error-Adobe-AcrobatProfessional.log"

$Acrobat = Get-Process -Name Acrobat.exe -ErrorAction SilentlyContinue
$Acrord32 = Get-Process -Name AcroRd32.exe -ErrorAction SilentlyContinue


Function LogWrite
{
    Param ([string]$logstring)

    Add-content $Logfile -value $logstring
}

if (($Acrobat) -or ($Acrord32))
{
    LogWrite -logstring 'Acrobat is open, cancelling install with error.'

    exit(2)
}

else
{

    Start-Process 'setup.exe' -Wait

}