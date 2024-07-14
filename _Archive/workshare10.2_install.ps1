<#
.Synopsis
Install script for Workshare 10.2
.Description
Install script for Workshare 10.2
.Notes
This installer installs the base setup.exe file. The setup.ini file contains information on where logging is stored, along with what .msp file to patch to.
To update the .msp patch. Place the latest patch into the directory and update the setup.ini file.
Install Log file is written to C:\InstallLogs\Install-Adobe-AcrobatProfessional.log
Error Log file is written to C:\InstallLogs\Error-Adobe-AcrobatProfessional.log
#>

$LogFile = "C:\InstallLogs\Error-Workshare10.2.log"

$Outlook = Get-Process -Name 'Outlook.exe' -ErrorAction SilentlyContinue
$Word = Get-Process -Name 'WinWord.exe' -ErrorAction SilentlyContinue
$Workshare = Get-Process -Name 'DeltaVw.exe' -ErrorAction SilentlyContinue


Function LogWrite
{
    Param ([string]$logstring)

    Add-content $Logfile -value $logstring
}

if (($Word) -or ($Outlook) -or ($Workshare))
{
    LogWrite -logstring 'Word, Outlook, or Workshare is open, cancelling install with error.'

    exit (4)
}

else
{
    #Install Pre-Reqs
    Write-Output "INSTALLING WORKSHARE PRE-REQ FILES" | Out-File "C:\InstallLogs\Install-WorkshareCompare_10.2.log"

    Start-Process -FilePath "vc_redist.x64.exe" -ArgumentList "/quiet /norestart /log C:\InstallLogs\Install-WorkshareCompare_10.2.log" -Wait
    Start-Process -FilePath "vc_redist.x86.exe" -ArgumentList "/quiet /norestart /log C:\InstallLogs\Install-WorkshareCompare_10.2.log" -Wait
    Start-Process -FilePath "vstor_redist.exe" -ArgumentList "/q /norestart /log C:\InstallLogs\Install-WorkshareCompare_10.2.log" -Wait
    #Install MSIs

    Start-Process -FilePath "msiexec" -ArgumentList "/i WorkshareCompare.msi MSIRESTARTMANAGERCONTROL=Disable INSTALL_INTERWOVEN=ON INSTALL_EXCEL_INTEGRATION=OFF INSTALL_OUTLOOK_INTEGRATION=OFF INSTALL_POWERPOINT_INTEGRATION=ON INSTALL_WORD_INTEGRATION=OFF INSTALL_CONNECT=OFF INSTALL_SECUREFILETRANSFER=OFF CAPTURE_EMAIL=FALSE REINSTALL=ALL REINSTALLMODE=vomus ALLUSERS=1 SKIP_UPGRADE_WARNING=1 REBOOT=R /norestart /l*v c:\InstallLogs\Install-WorkshareCompare_10.2.log /qn" -Wait
    Start-Process -FilePath "msiexec" -ArgumentList "/i WorkshareCompareforPowerpoint.msi REINSTALLMODE=vomus ALLUSERS=1 POWERPOINT_INTEGRATION=0 /l*v c:\InstallLogs\Install-WorkshareCompare_10.2.log /qn" -Wait

    #Registry Settings

    Start-Process -FilePath "C:\Windows\Regedit.exe" -ArgumentList "/s Workshare_10.2_Deploy_Script.reg"
    Start-Process -FilePath "C:\windows\regedit.exe" -ArgumentList "/s Faegre_Baker_Daniels_WoW64.reg"
    Start-Process -FilePath "C:\Windows\Regedit.exe" -ArgumentList "/s DeskSite9.3.1_Workshare_Right_Click.reg"

    #Final step to complete install and configuration
    Start-Process -FilePath "C:\Program Files (x86)\Workshare\modules\WMConfigAssistant.exe" -ArgumentList "/silent"

    Copy-Item -Path ".\FBD.SET" -Destination "C:\Users\Public\Documents\Workshare\Rendering" -Force


}